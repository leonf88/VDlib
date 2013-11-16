class CreateDMetadata < ActiveRecord::Migration
  def change
    create_table :d_metadata do |t|
      t.string :gsd_number, :limit => 20, :null => false
      t.string :title_eng, :limit => 50, :null => false
      t.string :title_chs, :limit => 100, :null => false

      t.references :v_metadata

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE d_metadata
      ADD CONSTRAINT fk_v_meta FOREIGN KEY (v_metadata_id) REFERENCES v_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE d_metadata
        DROP FOREIGN KEY fk_v_meta
    SQL

    drop_table :d_metadata
  end
end
