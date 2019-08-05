class AddYearToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :year, :integer
  end
end
