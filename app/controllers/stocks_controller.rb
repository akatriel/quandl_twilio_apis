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
				getWIKIAndCreate ticker
				stockUpdated = true
			end
		end

		if !hasStock and !stockUpdated
			stock = getWIKIAndCreate ticker
			stockUpdated = true
		end

		@stocks = @user.stocks
		
		respond_to do |format|
			if stockUpdated and stock != {}
				format.js
				format.html { 
					redirect_to user_path(@user), 
					notice: "#{stock.symbol} has been added to your portfolio!"
				}
			else
				flash.now[:alert] = "We could not add that stock to your portfolio."
				format.html{redirect_to user_path(@user)}
			end
		end
	end

	def show
		@stock = Stock.find params[:id]
		@data = clean_wolf_data @stock.symbol
		# if request fails @data will be false and page section will not render
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

	def clean_wolf_data ticker
		# Things to display
			# Updated price
			# Time and DAte
			# Company name
		# API call
		dataset = Stock.get_dataset_from_WA ticker
		
		return false if dataset == false

		if dataset == false 
			return false
		else 
			return_data = {}
			
			if dataset["queryresult"]["datatypes"] == "Financial"
				images = []
				quote_data = nil
				historyIMG = nil
				dataset["queryresult"]["pod"].each do |pod|
					if pod["id"] == "Quote"
						quote_data = get_quote_data pod
						return_data = return_data.merge quote_data unless quote_data.nil?
					end
					if pod["id"] == "PriceHistory"
						historyIMG = get_price_history pod
						return_data = return_data.merge(historyIMG) unless historyIMG.nil?
					end
				end
			end
		end
		return_data
	end

	def get_price_history pod
		src = pod["subpod"]["img"]["src"]
		alt = pod["subpod"]["img"]["alt"]
		width = pod["subpod"]["img"]["width"]
		height = pod["subpod"]["img"]["height"]
		{
			src: src,
			alt: alt,
			width: width,
			height: height
		}
	end

	def get_quote_data pod
		alt = pod["subpod"]["img"]["alt"].split(' ')

		price = alt[0].gsub(/[^\d\.]/, '').to_f
		time = alt[-3] << " " << alt[-2] << " " << alt[-1][0...alt[-1].length - 1]
		exchange = alt[3]

		{
			price: price,
			time: time,
			exchange: exchange
		}
	end
	
	def getWIKIAndCreate ticker
		#API query
		dataset = Stock.get_dataset_from_wiki "#{ticker}"
		# returns false if cant find
		if dataset != false
			
			return @user.stocks.create(
				symbol: ticker,
				date:dataset.date,
				open: dataset.open,
				close: dataset.close,
				high: dataset.high,
				low:dataset.low,
				volume: dataset.volume)
		else
			return {}
		end
	end

	def stock_params
		params.require(:stock).permit(:ticker)
	end
end
