class AddPitcherToPitch < ActiveRecord::Migration[5.2]
  def change
    change_table :pitches do |t|
      t.belongs_to :pitcher, index: true
      t.belongs_to :batter, index:true
    end
  end
end
