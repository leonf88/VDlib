class CreateGTranslators < ActiveRecord::Migration
  def change
    create_table :g_translators do |t|
      t.string :name, :null => false, :unique => true, :limit => 100

      t.timestamps
    end
  end

  def down
    drop_table :v_clarities
  end
end
