class CreateGTopics < ActiveRecord::Migration
  def change
    create_table :g_topics do |t|
      t.string :topic_chs, :limit => 50, :null => false
      t.string :topic_eng, :limit => 25, :null => false
      t.integer :priority, :default => 0

      t.timestamps
    end
  end
end
