class CreateVMetaTagships < ActiveRecord::Migration
  def change
    create_table :v_meta_tagships, :id => false do |t|
      t.references :v_metadata, :null => false
      t.references :g_tag, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE v_meta_tagships
      ADD CONSTRAINT fk_vmeta_tag FOREIGN KEY (v_metadata_id) REFERENCES v_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE v_meta_tagships
      ADD CONSTRAINT fk_tag_vmeta FOREIGN KEY (g_tag_id) REFERENCES g_tags(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end

  def down
    execute <<-SQL
      ALTER TABLE v_meta_tagships
        DROP FOREIGN KEY fk_tag_vmeta
    SQL

    execute <<-SQL
      ALTER TABLE v_meta_tagships
        DROP FOREIGN KEY fk_vmeta_tag
    SQL

    drop_table :v_meta_tagships
  end
end
