class CreateVMetaSubtopicships < ActiveRecord::Migration
  def change
    create_table :v_meta_subtopicships do |t|
      t.references :v_metadata, :null => false
      t.references :g_subtopic, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE v_meta_subtopicships
      ADD CONSTRAINT fk_vmeta_subtopic FOREIGN KEY (v_metadata_id) REFERENCES v_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE v_meta_subtopicships
      ADD CONSTRAINT fk_subtopic_vmeta FOREIGN KEY (g_subtopic_id) REFERENCES g_subtopics(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL
  end
end
