class StocksController < ApplicationController
	def create
		@user = current_user
		
		ticker = params[:ticker].upcase
		#API query
		dataset = Stock.get_dataset "#{ticker}"
		
		stock = Stock.new
		stock.symbol = ticker
		stock.user_id = @user.id
		if dataset && stock.save 
			flash[:notice] = "#{ticker} has been added to your portfolio!"
			redirect_to user_path(@user)
		else
		flash[:alert] = "Could not add stock to portfolio."
		redirect_to user_path(@user)
		end
	end

	def show
		@stock = Stock.find params[:id]
		ticker = @stock.symbol
		@dataset = Stock.get_dataset "#{ticker}"

	end

	def destroy
		stock = Stock.find params[:id]
		stock.destroy
		redirect_to user_path(current_user)
	end
	
end
