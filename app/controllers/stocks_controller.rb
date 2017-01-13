class StocksController < ApplicationController
	def create
		@user = current_user
		
		ticker = params[:ticker].upcase

		prev = Stock.where(symbol: ticker).order(updated_at: :desc)
		hasStock = false
		stockUpdated = false
		stock = {}

		if prev.exists?
			hasStock = true

			if prev.first.updated_at >= Date.yesterday
				stock = prev.first
				stockUpdated = true
			else 
				getStocksAndCreate ticker
				stockUpdated = true
			end
		end

		if !hasStock and !stockUpdated
			stock = getStocksAndCreate ticker
			stockUpdated = true
		end

		@stocks = @user.stocks
		byebug
		respond_to do |format|
			if stockUpdated and stock != {}
				format.js
				format.html { 
					redirect_to user_path(@user), 
					notice: "#{stock.symbol} has been added to your portfolio!"
				}
			else
				format.html{redirect_to user_path(@user), alert: "There was an error finding data on that stock"}
			end
		end
	end

	def show
		@stock = Stock.find params[:id]
		@dataset = Stock.get_dataset @stock.symbol
		@images = []
		@dataset["queryresult"]["pod"].each do |pod|
			@images << pod["subpod"]["img"]["src"]
			if pod["id"] == "Quote"
				@updatedPrice =  pod["subpod"]["img"]["alt"]
			end
		end
		# datatypes = @dataset["queryresult"]["datatypes"]
		# # should equal Financial

	end

	def destroy
		@stock = Stock.find params[:id]
		@stock.destroy

		respond_to do |format|
			format.html {redirect_to root_path}
			format.js
		end
	end

	private
	
	def getStocksAndCreate ticker
		#API query
		dataset = Stock.get_dataset_from_wiki "#{ticker}"
		# returns false if cant find
		unless dataset == false
			return @user.stocks.create(symbol: ticker, date:dataset.date, open: dataset.open, close: dataset.close, high: dataset.high, low:dataset.low, volume: dataset.volume)
		else
			return {}
		end
	end

	def stock_params
		params.require(:stock).permit(:ticker)
	end
end
