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

		@stocks = @user.stocks

		respond_to do |format|
			if dataset && stock.save 
				format.js
				format.html { 
					redirect_to user_path(@user), 
					notice: "#{stock.symbol} has been added to your portfolio!"
				}
			else
				flash[:alert] = "Could not add stock to portfolio."
				format.html{redirect_to user_path(@user)}
			end
		end
	end

	def show
		@stock = Stock.find params[:id]
	end

	def destroy
		@stock = Stock.find params[:id]
		@stock.destroy
		# byebug
		respond_to do |format|
			format.html {redirect_to root_path}
			format.js
		end
	end

	private
	
	def stock_params
		params.require(:stock).permit(:ticker)
	end
end
