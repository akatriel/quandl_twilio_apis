class AddKeysToAssets < ActiveRecord::Migration
  def change
  		add_column :assets, :user_id, :integer
  		add_column :assets, :stock_id, :integer
  end
end
