class ChangeMlbKeyToBeStringInPitches < ActiveRecord::Migration[5.2]
  def change
    change_column :pitches, :mlb_key, :string
  end
end
