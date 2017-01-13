require 'httparty'
require 'nokogiri'
class Stock < ActiveRecord::Base
	has_many :assets
	has_many :users, through: :assets

	Quandl::ApiConfig.api_key = 'exAUgh8NLoYAjuwd22PH'
	Quandl::ApiConfig.api_version = '2015-04-09'
	# @database = Quandl::Database.get('WIKI')	

	def self.get_dataset_from_wiki ticker
		begin
			query = Quandl::Dataset.get("WIKI/#{ticker.upcase}").data.first
			cloned = query.clone
			p ">>>>>>>>>>>>>>>>>>>>>>> WIKI"
			return cloned
		rescue
			return false
		end
	end

	# Fucking awful to iterate through every user every time a stock/etf is updated.
	# Not a scalable method

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
	

	def self.get_dataset_from_WA ticker
		url = "http://api.wolframalpha.com/v2/query?input=#{ticker}&appid=5UHKGU-L46E3GWYV9&assumption=*C.AA-_*Financial-&format=image,imagemap"
		response = HTTParty.get url
		response
	end
end