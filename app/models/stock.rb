require 'httparty'
require 'nokogiri'

class Stock < ActiveRecord::Base
	has_many :assets
	has_many :users, through: :assets

	def self.get_dataset_from_fool ticker
		ticker = ticker.upcase
		apikey = ENV["fool_key"]
		url = "http://www.fool.com/a/caps/ws/Ticker/#{ticker}?apikey=#{apikey}"
		begin
			HTTParty.get url
		rescue
			return false
		end
	end

	def self.get_dataset_from_WA ticker
		ticker = ticker.upcase
		url = "http://api.wolframalpha.com/v2/query?
		input=#{ticker}
		&assumption=*C.#{ticker}-_*Financial-
		&scanner=FinancialData
		&appid=5UHKGU-L46E3GWYV9"
		begin
			response = HTTParty.get url
			
			response
		rescue
			return false
		end
	end

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
	# Need to refactor

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


end