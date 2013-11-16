class CreateVClarities < ActiveRecord::Migration
  def change
    create_table :v_clarities do |t|
      t.string :clarity, :limits => 20, :null => false, :unique => true

      t.timestamps
    end
  end

  def down
    drop_table :v_clarities
  end
end
