class AddPartyStatusRefToParties < ActiveRecord::Migration
  def change
    add_reference :parties, :party_status, index: true
    add_foreign_key :parties, :party_statuses
  end
end
