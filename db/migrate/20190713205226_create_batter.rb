class CreateBatter < ActiveRecord::Migration[5.2]
  def change
    create_table :batters do |t|
      t.string :name
      t.integer :mlb_key
    end
  end
end
