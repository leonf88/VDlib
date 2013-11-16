class CreateVMetadata < ActiveRecord::Migration
  def change
    create_table :v_metadata do |t|
      t.string :gsv_number, :limit => 20, :null => false
      t.string :title_eng, :limit => 50, :null => false
      t.string :title_chs, :limit => 100, :null => false
      t.string :audio_language, :limit => 20
      t.string :subtitle_language, :limit => 20
      t.text :description, :limit => 2000
      t.integer :duration, :default => 0
      t.date :create_date

      t.string :video_path, :limit => 100
      t.string :img_path, :limit => 100

      t.integer :counter, :default => 0

      t.references :v_clarity
      t.references :v_provider

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE v_metadata
      ADD CONSTRAINT fk_v_clarity FOREIGN KEY (v_clarity_id) REFERENCES v_clarities(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE v_metadata
      ADD CONSTRAINT fk_v_provider FOREIGN KEY (v_provider_id) REFERENCES v_providers(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end

  def down
    execute <<-SQL
      ALTER TABLE v_metadata
        DROP FOREIGN KEY fk_v_provider
    SQL

    execute <<-SQL
      ALTER TABLE v_metadata
        DROP FOREIGN KEY fk_v_clarity
    SQL

    drop_table :v_metadata
  end
end
