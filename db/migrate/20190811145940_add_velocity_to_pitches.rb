class AddVelocityToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :velocity, :decimal
  end
end
