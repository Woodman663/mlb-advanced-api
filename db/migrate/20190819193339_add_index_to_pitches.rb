class AddIndexToPitches < ActiveRecord::Migration[5.2]
  def change
    add_index(:pitches, :mlb_key)
    add_index(:pitches, :velocity)
    add_index(:pitches, :horizontal_movement)
    add_index(:pitches, :vertical_movement)
    add_index(:pitches, :horizontal_location)
    add_index(:pitches, :vertical_location)
  end
end
