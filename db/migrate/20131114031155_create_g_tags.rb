class CreateGTags < ActiveRecord::Migration
  def change
    create_table :g_tags do |t|
      t.string :tag, :limit => 100
      t.integer :grade, :default => 0
      t.integer :v_count, :default => 0
      t.integer :d_count, :default => 0

      t.references :g_topic

      t.timestamps
    end
  end

  def down
    drop_table :g_tags
  end
end
