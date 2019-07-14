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

ActiveRecord::Schema.define(version: 2019_07_13_205323) do

  create_table "batters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "mlb_key"
  end

  create_table "pitchers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "mlb_key"
  end

  create_table "pitches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "horizontal_location", precision: 10
    t.decimal "vertical_location", precision: 10
    t.decimal "vertical_release", precision: 10
    t.decimal "horizontal_release", precision: 10
    t.decimal "vertical_movement", precision: 10
    t.decimal "horizontal_movement", precision: 10
    t.integer "mlb_key"
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
    t.decimal "exit_velo", precision: 10
    t.decimal "launch_angle", precision: 10
    t.decimal "prev_pitch_velo", precision: 10
    t.decimal "prev_pitch_vertical_movement", precision: 10
    t.decimal "prev_pitch_horizontal_movement", precision: 10
    t.decimal "prev_pitch_vertical_location", precision: 10
    t.decimal "prev_pitch_horizontal_location", precision: 10
    t.integer "fielded_by"
    t.boolean "changeup"
    t.bigint "pitcher_id"
    t.bigint "batter_id"
    t.index ["batter_id"], name: "index_pitches_on_batter_id"
    t.index ["pitcher_id"], name: "index_pitches_on_pitcher_id"
  end

end
