class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.integer :size
      t.string :phone
      t.datetime :start_time
      t.datetime :seated_time
      t.datetime :exit_time

      t.timestamps null: false
    end
  end
end
