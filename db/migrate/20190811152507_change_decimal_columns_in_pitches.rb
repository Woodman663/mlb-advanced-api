class ChangeDecimalColumnsInPitches < ActiveRecord::Migration[5.2]
  def change
    change_column :pitches, :velocity, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :prev_pitch_velo, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :horizontal_movement, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :prev_pitch_horizontal_movement, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :vertical_movement, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :prev_pitch_vertical_movement, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :horizontal_location, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :prev_pitch_horizontal_location, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :vertical_location, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :prev_pitch_vertical_location, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :launch_angle, :decimal, :precision => 6, :scale => 4
    change_column :pitches, :exit_velo, :decimal, :precision => 6, :scale => 4
  end
end
