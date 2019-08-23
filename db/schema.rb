# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_19_193339) do

  create_table "batters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "mlb_key"
  end

  create_table "pitchers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "mlb_key"
  end

  create_table "pitches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "horizontal_location", precision: 6, scale: 2
    t.decimal "vertical_location", precision: 6, scale: 2
    t.decimal "vertical_release", precision: 6, scale: 2
    t.decimal "horizontal_release", precision: 6, scale: 2
    t.decimal "vertical_movement", precision: 6, scale: 2
    t.decimal "horizontal_movement", precision: 6, scale: 2
    t.string "mlb_key"
    t.string "pitch_hand"
    t.string "bat_side"
    t.boolean "edge"
    t.boolean "strike"
    t.boolean "swing"
    t.boolean "whiff"
    t.boolean "foul"
    t.boolean "hit"
    t.integer "bases"
    t.integer "balls"
    t.integer "strikes"
    t.integer "outs"
    t.string "batted_ball_type"
    t.decimal "exit_velo", precision: 6, scale: 2
    t.decimal "launch_angle", precision: 6, scale: 2
    t.decimal "prev_pitch_velo", precision: 6, scale: 2
    t.decimal "prev_pitch_vertical_movement", precision: 6, scale: 2
    t.decimal "prev_pitch_horizontal_movement", precision: 6, scale: 2
    t.decimal "prev_pitch_vertical_location", precision: 6, scale: 2
    t.decimal "prev_pitch_horizontal_location", precision: 6, scale: 2
    t.integer "fielded_by"
    t.boolean "changeup"
    t.bigint "pitcher_id"
    t.bigint "batter_id"
    t.integer "year"
    t.integer "spin_rate"
    t.decimal "virtual_bases", precision: 6, scale: 2
    t.decimal "virtual_outs", precision: 6, scale: 2
    t.decimal "velocity", precision: 6, scale: 2
    t.index ["batter_id"], name: "index_pitches_on_batter_id"
    t.index ["horizontal_location"], name: "index_pitches_on_horizontal_location"
    t.index ["horizontal_movement"], name: "index_pitches_on_horizontal_movement"
    t.index ["mlb_key", "velocity", "horizontal_location"], name: "index_pitches_on_mlb_key_and_velocity_and_horizontal_location"
    t.index ["mlb_key"], name: "index_pitches_on_mlb_key"
    t.index ["pitcher_id"], name: "index_pitches_on_pitcher_id"
    t.index ["velocity"], name: "index_pitches_on_velocity"
    t.index ["vertical_location"], name: "index_pitches_on_vertical_location"
    t.index ["vertical_movement"], name: "index_pitches_on_vertical_movement"
  end

end
