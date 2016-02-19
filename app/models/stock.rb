class Stock < ActiveRecord::Base
	belongs_to :user 

	validates :symbol, uniqueness: true

	Quandl::ApiConfig.api_key = 'exAUgh8NLoYAjuwd22PH'
	Quandl::ApiConfig.api_version = '2015-04-09'
	# @database = Quandl::Database.get('WIKI')
	
	#Need to set a variable to store stat of dataset call. Otherwise, if the first call returns false the other may not get called.

	def self.get_dataset ticker
		ticker = ticker.upcase
		get_dataset_from_wiki(ticker) ? get_dataset_from_wiki(ticker) : 		get_dataset_from_eod(ticker)

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
