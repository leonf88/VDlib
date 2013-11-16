class CreateVMetaRegionships < ActiveRecord::Migration
  def change
    create_table :v_meta_regionships, :id => false do |t|
      t.references :v_metadata, :null => false
      t.references :g_region, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE v_meta_regionships
      ADD CONSTRAINT fk_vmeta_reg FOREIGN KEY (v_metadata_id) REFERENCES v_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE v_meta_regionships
      ADD CONSTRAINT fk_reg_vmeta FOREIGN KEY (g_region_id) REFERENCES g_regions(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end

  def down
    execute <<-SQL
      ALTER TABLE v_meta_regionships
        DROP FOREIGN KEY fk_vmeta_reg
    SQL

    execute <<-SQL
      ALTER TABLE v_meta_regionships
        DROP FOREIGN KEY fk_reg_vmeta
    SQL

    drop_table :v_meta_regionships
  end
end
