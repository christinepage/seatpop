class AddTokenToParties < ActiveRecord::Migration
  def change
    add_column :parties, :token, :integer
  end
end
