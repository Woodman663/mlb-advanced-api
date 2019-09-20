namespace :mlb do
  desc "import data from MLB Stats API"
  task :import_week => :environment do
    mlb = MlbConnection.new
    today = Date.today
    year = today.year
    month_two = today.month
    day_two = today.day
    last_week = Date.today-7
    month_one = last_week.month
    day_one = last_week.day
    ids = mlb.game_ids(year,day_one,month_one,day_two,month_two)
    mlb.save_pitches(ids)
  end
end
