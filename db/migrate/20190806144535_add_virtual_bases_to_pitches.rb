class AddVirtualBasesToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :virtual_bases, :decimal
    add_column :pitches, :virtual_outs, :decimal
  end
end
