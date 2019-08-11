class AddSpinRateToPitch < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :spin_rate, :integer
  end
end
