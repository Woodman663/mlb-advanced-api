namespace :mlb do
  desc "import data from MLB Stats API"
  task :import, [:year, :month] => :environment do |task, args|
    mlb = MlbConnection.new
    next_month = args[:month].to_i + 1
    ids = mlb.game_ids(args[:year],1,args[:month],1,next_month)
    mlb.save_pitches(ids)
  end
end
