class CreatePartyStatuses < ActiveRecord::Migration
  def change
    create_table :party_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
