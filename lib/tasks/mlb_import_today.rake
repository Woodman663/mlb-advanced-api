namespace :mlb do
  desc "import data from MLB Stats API"
  task :import_today => :environment do
    mlb = MlbConnection.new
    today = Date.today
    year = today.year
    month_two = today.month
    day_two = today.day
    yesterday = Date.yesterday
    month_one = yesterday.month
    day_one = yesterday.day
    ids = mlb.game_ids(year,day_one,month_one,day_two,month_two)
    mlb.save_pitches(ids)
  end
end
