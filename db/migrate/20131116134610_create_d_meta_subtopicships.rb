class CreateDMetaSubtopicships < ActiveRecord::Migration
  def change
    create_table :d_meta_subtopicships do |t|
      t.references :d_metadata, :null => false
      t.references :g_subtopic, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE d_meta_subtopicships
      ADD CONSTRAINT fk_dmeta_subtopic FOREIGN KEY (d_metadata_id) REFERENCES d_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE d_meta_subtopicships
      ADD CONSTRAINT fk_subtopic_dmeta FOREIGN KEY (g_subtopic_id) REFERENCES g_subtopics(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL
  end
end
