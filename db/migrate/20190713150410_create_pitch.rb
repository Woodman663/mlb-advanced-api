class CreatePitch < ActiveRecord::Migration[5.2]
  def change
    create_table :pitches do |t|
      t.decimal :horizontal_location
      t.decimal :vertical_location
      t.decimal :vertical_release
      t.decimal :horizontal_release
      t.decimal :vertical_movement
      t.decimal :horizontal_movement
      t.integer :mlb_key
      t.string :pitch_hand
      t.string :bat_side
      t.boolean :edge
      t.boolean :strike
      t.boolean :swing
      t.boolean :whiff
      t.boolean :foul
      t.boolean :hit
      t.integer :bases
      t.integer :balls
      t.integer :strikes
      t.integer :outs
      t.string :batted_ball_type
      t.decimal :exit_velo
      t.decimal :launch_angle
      t.decimal :prev_pitch_velo
      t.decimal :prev_pitch_vertical_movement
      t.decimal :prev_pitch_horizontal_movement
      t.decimal :prev_pitch_vertical_location
      t.decimal :prev_pitch_horizontal_location
      t.integer :fielded_by
      t.boolean :changeup
    end
  end
end
