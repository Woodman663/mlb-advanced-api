require 'open-uri'
require 'json'

class MlbConnection
  def initialize
    #todo: check whether mlb stats api is working correctly
  end

  def request_games(year, day_start, month_start, day_end, month_end)
    url = 'https://statsapi.mlb.com/api/v1/schedule?sportId=1&startDate=' + year.to_s + '-' + month_start.to_s + '-' + day_start.to_s + '&endDate=' + year.to_s + '-' + month_end.to_s + '-' + day_end.to_s
    response = open(url).read
    json = JSON.parse(response)
  end

  def request_data(year, day_start, month_start, day_end, month_end)
    gameIds = []
    games_played = self.request_games(year, day_start, month_start, day_end, month_end)
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
end
