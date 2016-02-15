require 'quandl'
class HomeController < ApplicationController
	def index
		Quandl::ApiConfig.api_key = 'exAUgh8NLoYAjuwd22PH'
		Quandl::ApiConfig.api_version = '2015-04-09'
		# @database = Quandl::Database.get('WIKI')
		@dataset = Quandl::Dataset.get('WIKI/AAPL').data.first
	end
end
