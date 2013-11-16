class CreateDMetaRegionships < ActiveRecord::Migration
  def change
    create_table :d_meta_regionships, :id => false do |t|
      t.references :d_metadata, :null => false
      t.references :g_region, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE d_meta_regionships
      ADD CONSTRAINT fk_dmeta_reg FOREIGN KEY (d_metadata_id) REFERENCES d_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE d_meta_regionships
      ADD CONSTRAINT fk_reg_dmeta FOREIGN KEY (g_region_id) REFERENCES g_regions(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end
  def down
    execute <<-SQL
      ALTER TABLE d_meta_regionships
        DROP FOREIGN KEY fk_reg_dmeta
    SQL

    execute <<-SQL
      ALTER TABLE d_meta_regionships
        DROP FOREIGN KEY fk_dmeta_reg
    SQL

    drop_table :d_meta_regionships
  end
end
