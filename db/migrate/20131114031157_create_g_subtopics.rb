class CreateGSubtopics < ActiveRecord::Migration
  def change
    create_table :g_subtopics do |t|
      t.string :topic_chs, :limit => 50, :null => false
      t.string :topic_eng, :limit => 25, :null => false
      t.integer :priority, :default => 0
      t.integer :v_count, :default => 0
      t.integer :d_count, :default => 0

      t.references :g_topic

      t.timestamps
    end
  end
end
