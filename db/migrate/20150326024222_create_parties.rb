class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.references :restaurant, index: true
      t.integer :size
      t.string :phone
      t.string :notes
      t.integer :token
      t.datetime :seated_time
      t.datetime :exit_time

      t.timestamps null: false
    end
  end
end
