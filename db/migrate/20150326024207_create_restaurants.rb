class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.integer :est_wait_time
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
