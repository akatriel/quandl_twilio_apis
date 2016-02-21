class StocksController < ApplicationController
	def create
		@user = current_user
		
		ticker = params[:ticker].upcase
		#API query
		dataset = Stock.get_dataset "#{ticker}"
		
		stock = Stock.new
		stock.symbol = ticker
		stock.user_id = @user.id
		stock.date = dataset.date
		stock.open = dataset.open
		stock.close = dataset.close
		stock.high = dataset.high
		stock.low = dataset.low
		stock.volume = dataset.volume

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
	end

	def destroy
		stock = Stock.find params[:id]
		stock.destroy
		redirect_to user_path(current_user)
	end
	private
	def stock_params
		params.require(:stock).permit(:ticker)
	end
end
