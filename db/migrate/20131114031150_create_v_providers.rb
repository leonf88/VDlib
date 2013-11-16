class CreateVProviders < ActiveRecord::Migration
  def change
    create_table :v_providers do |t|
      t.string :provider, :null => false
      t.string :detail, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :v_providers
  end
end
