class Stock < ActiveRecord::Base
	belongs_to :user 

	Quandl::ApiConfig.api_key = 'exAUgh8NLoYAjuwd22PH'
	Quandl::ApiConfig.api_version = '2015-04-09'
	# @database = Quandl::Database.get('WIKI')	

	def self.get_dataset ticker
		ticker = ticker.upcase
		get_dataset_from_wiki(ticker) ? get_dataset_from_wiki(ticker) : 		get_dataset_from_eod(ticker)
	end
	def self.update
		users = User.all
		users.each do |u|
			stocks = u.stocks
			stocks.each do |s|
				ticker = s.symbol
				dataset = Stock.get_dataset ticker
				s.date = dataset.date
				s.open = dataset.open
				s.close = dataset.close
				s.high = dataset.high
				s.low = dataset.low
				s.volume = dataset.volume
				s.save
			end
		end
	end
	private
	def self.get_dataset_from_wiki ticker
		begin
			query = Quandl::Dataset.get("WIKI/#{ticker}").data.first
			cloned = query.clone
			p ">>>>>>>>>>>>>>>>>>>>>>> WIKI"
			return cloned
		rescue
			return false
		end
	end
	def self.get_dataset_from_eod ticker
		begin
			query = Quandl::Dataset.get("EOD/#{ticker}").data.first
			cloned = query.clone
			p ">>>>>>>>>>>>>>>>>>>>>>>>>> EOD"
			return cloned
		rescue	
			return false
		end
	end
end
