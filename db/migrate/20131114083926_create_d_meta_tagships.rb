class CreateDMetaTagships < ActiveRecord::Migration
  def change
    create_table :d_meta_tagships, :id => false do |t|
      t.references :d_metadata, :null => false
      t.references :g_tag, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE d_meta_tagships
      ADD CONSTRAINT fk_dmeta_tag FOREIGN KEY (d_metadata_id) REFERENCES d_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE d_meta_tagships
      ADD CONSTRAINT fk_tag_dmeta FOREIGN KEY (g_tag_id) REFERENCES g_tags(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end

  def down
    execute <<-SQL
      ALTER TABLE d_meta_tagships
        DROP FOREIGN KEY fk_dmeta_tag
    SQL

    execute <<-SQL
      ALTER TABLE d_meta_tagships
        DROP FOREIGN KEY fk_tag_dmeta
    SQL

    drop_table :d_meta_tagships
  end
end
