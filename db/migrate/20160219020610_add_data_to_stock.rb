class AddDataToStock < ActiveRecord::Migration
  def change
  	add_column :stocks, :date, :string
  	add_column :stocks, :open, :decimal
  	add_column :stocks, :close, :decimal
  	add_column :stocks, :high, :decimal
  	add_column :stocks, :low, :decimal
  	add_column :stocks, :volume, :integer
  end
end
