class AddAuthtokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_authtoken, :string
    add_column :users, :authtoken_expiry, :datetime
  end
end
