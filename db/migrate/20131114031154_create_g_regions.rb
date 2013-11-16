class CreateGRegions < ActiveRecord::Migration
  def change
    create_table :g_regions do |t|
      t.string :name_chs, :limit => 100
      t.string :name_eng, :limit => 25

      t.timestamps
    end
  end
  def down
    drop_table :g_regions
  end

end
