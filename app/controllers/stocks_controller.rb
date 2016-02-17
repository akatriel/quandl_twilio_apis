class StocksController < ApplicationController
	def create
		@user = current_user
		ticker = params[:ticker]
		begin
			dataset = Stock.new.get_dataset "#{@ticker}"
			stock = Stock.new(stock_params)
			stock.symbol = ticker
			stock.user_id = @user.id
			stock.save
		rescue
			flash[:alert] = "Could not add stock to portfolio."
			redirect_to users_path(@user)
		end
	end
end
