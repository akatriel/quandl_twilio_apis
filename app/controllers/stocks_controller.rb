class StocksController < ApplicationController
	def new
		if params[:ticker] == nil
			@dataset = Stock.new.get_dataset 'AAPL'
		else
			begin
				@dataset = Stock.new.get_dataset "#{params[:ticker]}"
			rescue
				@dataset = Stock.new.get_dataset 'AAPL'
				params[:ticker] = 'AAPL'
				render :index
			end
		end
	end
end
