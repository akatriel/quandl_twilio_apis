class Stock < ActiveRecord::Base
	Quandl::ApiConfig.api_key = 'exAUgh8NLoYAjuwd22PH'
	Quandl::ApiConfig.api_version = '2015-04-09'
	# @database = Quandl::Database.get('WIKI')
	def get_dataset ticker
		@dataset = Quandl::Dataset.get('WIKI/AAPL').data.first
	end
end
