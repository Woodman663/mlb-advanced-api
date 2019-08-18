require 'open-uri'
require 'json'
require 'active_support'

class MlbConnection
  attr_reader :year
  def initialize
    #todo: check whether mlb stats api is working correctly
  end

  def request_games(year, day_start, month_start, day_end, month_end)
    url = 'https://statsapi.mlb.com/api/v1/schedule?sportId=1&startDate=' + year.to_s + '-' + month_start.to_s + '-' + day_start.to_s + '&endDate=' + year.to_s + '-' + month_end.to_s + '-' + day_end.to_s
    request(url)
  end

  def game_ids(year, day_start, month_start, day_end, month_end)
    @year = year
    gameIds = []
    games_played = request_games(year, day_start, month_start, day_end, month_end)
    dates = games_played["dates"]
    dates.each do |date|
      games = date['games']
      games.each do |game|
        # filter by gameType set to R to limit results to Regular Season games
        gameIds << game['gamePk'] if game['gameType'] == 'R'
      end
    end
    gameIds
  end

  def save_pitches(gameIds)
    pitcher_exists = ''
    gameIds.each do |gameId|
      data = request_pitches(gameId)
      plate_appearances = data['allPlays']
      plate_appearances.each do |pa|
        if pa['matchup'].present?
          matchup = pa['matchup']
        else
          next
        end
        if matchup['pitcher'].present?
          pitcher_id = matchup['pitcher']['id']
        else
          next
        end
        if matchup['batter'].present?
          batter_id = matchup['batter']['id']
        else
          next
        end
        # check if we've got a matchup with identifiable pitcher and batter
        unless pitcher_id.to_i > 0 && batter_id.to_i > 0
          next
        end
        pitcher = Pitcher.find_by mlb_key: pitcher_id # find the pitcher if he exists in our database
        unless pitcher.present? # run this if he's not yet in the database
          pitcher = Pitcher.new
          pitcher.mlb_key = pitcher_id
          pitcher.name = matchup['pitcher']['fullName']
          pitcher.save
        end
        batter = Batter.find_by mlb_key: batter_id
        unless batter.present?
          batter = Batter.new
          batter.mlb_key = batter_id
          batter.name = matchup['batter']['fullName']
          batter.save
        end
        if pa['playEvents'].present?
          result = pa['result']['eventType']
          prev_pitch = nil
          balls = 0
          strikes = 0
          pa['playEvents'].each do |pitch|
            next if pitch['isPitch'] == false # don't process play events that are not pitches
            pitch_exists = Pitch.where(:mlb_key => pitch['pfxId']).exists?
            unless pitch_exists # we only want to save a pitch we haven't already added
              params = {
                'pitcher' => pitcher.id,
                'batter' => batter.id,
                'result' => result,
                'prev_pitch' => prev_pitch,
                'pitch_hand' => check_value(matchup['pitchHand']['code']),
                'bat_side' => check_value(matchup['batSide']['code']),
                'outs' => check_value(pa['count']['outs']),
                'balls' => balls,
                'strikes' => strikes,
              }
              prev_pitch = process_pitch_event(pitch, params)
              balls = check_value(pitch['count']['balls'])
              strikes = check_value(pitch['count']['strikes'])
            end
          end
        else
          puts 'could not find playEvents in plate appearance data'
        end
      end
    end
  end

  def request_pitches(gameId)
    url = 'https://statsapi.mlb.com/api/v1/game/' + gameId.to_s + '/playByPlay'
    request(url)
  end

  def request(url)
    response = open(url).read
    json = JSON.parse(response)
  end

  def process_pitch_event(pitch_event, params)
    # we don't want to save pitches that lack the most basic data
    return unless validate_pitch_event(pitch_event) # check if the event contains the expected data structure
    pitch = Pitch.new
    # unpack some params
    result = params['result']
    prev_pitch = params['prev_pitch']
    pitch.mlb_key = pitch_event['pfxId']
    pitch.pitcher_id = params['pitcher']
    pitch.batter_id = params['batter']
    pitch.pitch_hand = params['pitch_hand']
    pitch.bat_side = params['bat_side']
    pitch.outs = params['outs']
    pitch.strikes = params['strikes']
    pitch.balls = params['balls']
    pitch.year = @year
    # handle the pitch data here
    pitch_data = pitch_event['pitchData']
    pitch.vertical_location = normalize_height(pitch_event) # special function to correct for different size of strikezones depending on batter height
    pitch.horizontal_location = check_and_format_value(pitch_data['coordinates']['pX'])
    pitch.vertical_movement = check_and_format_value(pitch_data['coordinates']['pfxZ'])
    pitch.horizontal_movement = check_and_format_value(pitch_data['coordinates']['pfxX'])
    pitch.vertical_release = check_and_format_value(pitch_data['coordinates']['z0'])
    pitch.horizontal_release = check_and_format_value(pitch_data['coordinates']['x0'])
    pitch.velocity = check_and_format_value(pitch_data['startSpeed'])
    if pitch_data['breaks'].present?
      pitch.spin_rate = check_value(pitch_data['breaks']['spinRate'])
    end
    if pitch_event['details']['type'].present?
      type = pitch_event['details']['type']['code']
    end
    if type.nil?
      pitch.changeup = nil
    end
    pitch.changeup = type == 'CH' || type == 'FS' ? true : false
    # save some of the data of the pitch before for pitch sequencing analysis
    if prev_pitch.present?
      pitch.prev_pitch_vertical_location = prev_pitch.vertical_location
      pitch.prev_pitch_horizontal_location =  prev_pitch.horizontal_location
      pitch.prev_pitch_vertical_movement =  prev_pitch.vertical_movement
      pitch.prev_pitch_horizontal_movement =  prev_pitch.horizontal_movement
      pitch.prev_pitch_velo = prev_pitch.velocity
    end
    in_play = check_value(pitch_event['details']['isInPlay'])
    # now we switch to the hit data
    if in_play # when the ball was hit in play we need to save the result of the batted ball
      pitch.strike = true
      pitch.swing = true
      pitch.foul = false
      pitch.whiff = false
      if pitch_event['hitData'].present?
        hit_data = check_value(pitch_event['hitData'])
        pitch.exit_velo = check_and_format_value(hit_data['launchSpeed'])
        pitch.launch_angle = check_and_format_value(hit_data['launchAngle'])
        pitch.fielded_by = check_value(hit_data['location']).to_i
        pitch.batted_ball_type = check_value(hit_data['trajectory'])
      end
      # defaults to reduce duplicate code
      pitch.hit = true
      pitch.virtual_outs = 0
      # list all the various ways a batter could make an out
      out = [
        'field_error',
        'field_out',
        'sac_fly',
        'sac_bunt',
        'force_out',
        'fielders_choice',
        'grounded_into_double_play',
        'double_play',
        'fielders_choice_out',
        'triple_play',
        'batter_interference',
        'sac_bunt_double_play'
      ]
      case result # check for hit, type of hit and outs
      when 'single'
        pitch.bases = 1
        pitch.virtual_bases = 1
      when 'double', 'fan_interference'
        pitch.bases = 2
        pitch.virtual_bases = 2
      when 'triple'
        pitch.bases = 3
        pitch.virtual_bases = 3
      when 'home_run'
        pitch.bases = 4
        pitch.virtual_bases = 4
      when *out
        pitch.bases = 0
        pitch.hit = false
        pitch.virtual_bases = 0
        pitch.virtual_outs = 1
      when 'catcher_interf' # this outcome has nothing to do with either batter or pitcher, so we disregard it
        return nil
      else
        puts 'I do not know what to do with result ' + result
        pitch.hit = nil
      end
    else
      pitch.strike = pitch_event['details']['isStrike']
      # set defaults for whiff and foul to reduce duplicate lines
      pitch.whiff = false
      pitch.foul = false
      case pitch_event['details']['code']
      when 'B', '*B', 'P' # ball, ball in dirt and pitchout
        pitch.swing = false
        pitch.virtual_outs = 0
        pitch.virtual_bases = 1/4.to_d
      when 'H' # hit by pitch
        pitch.swing = false
        pitch.virtual_outs = 0
        pitch.virtual_bases = 1
      when 'C' # called strike
        pitch.swing = false
        pitch.virtual_outs = 1/3.to_d
        pitch.virtual_bases = 0
      when 'S', 'T', 'W', 'M', 'O' # we count foul tips 'T' as swinging strikes, 'W' is swinging strike (blocked) and 'M' and 'O' are missed bunts'
        pitch.swing = true
        pitch.virtual_outs = 1/3.to_d
        pitch.virtual_bases = 0
        pitch.whiff = true
      when 'F', 'L' # 'L' is a foul bunt attempt
        pitch.swing = true
        pitch.foul = true
        pitch.virtual_bases = 0
        if params['strikes'].present?
          if params['strikes'] < 2
            pitch.virtual_outs = 1/3.to_d
          else
            pitch.virtual_outs = 0
          end
        end
      else
        puts 'I do not know what to do with code ' + pitch_event['details']['code']
      end
    end
    pitch.save
    return pitch
  end

  def normalize_height(pitch_event)
    unless pitch_event['pitchData']['coordinates']['pZ'].present?
      return nil
    end
    valid = pitch_event['pitchData']['strikeZoneTop'].present? && pitch_event['pitchData']['strikeZoneBottom'] > 0
    top_of_zone =  valid ? pitch_event['pitchData']['strikeZoneTop'].to_f : 3.4
    bottom_of_zone = pitch_event['pitchData']['strikeZoneBottom'].present? ? pitch_event['pitchData']['strikeZoneBottom'].to_f : 1.6
    size_factor = 1.8 / (top_of_zone - bottom_of_zone)
    normalized_height = size_factor * (pitch_event['pitchData']['coordinates']['pZ'].to_f - bottom_of_zone)
    normalized_height.to_d #todo: remove
  end

  def validate_pitch_event(pitch_event)
    # this function will return false unless the data we need to save a meaningful pitch is all present
    return false unless pitch_event['details'].present?
    return false unless pitch_event['pitchData'].present?
    return false unless pitch_event['pitchData']['startSpeed'].present?
    return false unless pitch_event['pitchData']['coordinates'].present?
    return true
  end

  def check_value(value)
    if value.present?
      return value
    end
  end

  def check_and_format_value(value)
    if value.present?
      return value.to_d
    end
    return nil
  end
end
