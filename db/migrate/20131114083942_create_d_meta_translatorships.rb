class CreateDMetaTranslatorships < ActiveRecord::Migration
  def change
    create_table :d_meta_translatorships, :id => false do |t|
      t.references :d_metadata, :null => false
      t.references :g_translator, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE d_meta_translatorships
      ADD CONSTRAINT fk_dmeta_trans FOREIGN KEY (d_metadata_id) REFERENCES d_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE d_meta_translatorships
      ADD CONSTRAINT fk_trans_dmeta FOREIGN KEY (g_translator_id) REFERENCES g_translators(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end

  def down
    execute <<-SQL
      ALTER TABLE d_meta_translatorships
        DROP FOREIGN KEY fk_trans_dmeta
    SQL

    execute <<-SQL
      ALTER TABLE d_meta_translatorships
        DROP FOREIGN KEY fk_dmeta_trans
    SQL

    drop_table :v_meta_translatorships
  end
end
