class AddFieldsToStocks < ActiveRecord::Migration
  def change
  	add_column :stocks, :symbol, :string
  	add_column :stocks, :user_id, :integer
  end
end
