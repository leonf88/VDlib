class CreateVMetaTranslatorships < ActiveRecord::Migration
  def change
    create_table :v_meta_translatorships, :id => false do |t|
      t.references :v_metadata, :null => false
      t.references :g_translator, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE v_meta_translatorships
      ADD CONSTRAINT fk_vmeta_trans FOREIGN KEY (v_metadata_id) REFERENCES v_metadata(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

    execute <<-SQL
    ALTER TABLE v_meta_translatorships
      ADD CONSTRAINT fk_trans_vmeta FOREIGN KEY (g_translator_id) REFERENCES g_translators(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
    SQL

  end

  def down
    execute <<-SQL
      ALTER TABLE v_meta_translatorships
        DROP FOREIGN KEY fk_trans_vmeta
    SQL

    execute <<-SQL
      ALTER TABLE v_meta_translatorships
        DROP FOREIGN KEY fk_vmeta_trans
    SQL

    drop_table :v_meta_translatorships
  end
end
