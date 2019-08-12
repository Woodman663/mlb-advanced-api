class ChangeVirtualOutsInPitches < ActiveRecord::Migration[5.2]
  def change
    change_column :pitches, :virtual_outs, :decimal, :precision => 6, :scale => 2
    change_column :pitches, :virtual_bases, :decimal, :precision => 6, :scale => 2
  end
end
