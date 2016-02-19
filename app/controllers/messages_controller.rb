class MessagesController < ApplicationController
	def create
		account_sid = ENV['TWILIO_SID']
		auth_token = ENV['TWILIO_AUTH_TOKEN']
		@client = Twilio::REST::Client.new account_sid, auth_token

		user = current_user
		portfolio = user.stocks


		body = []
		stock_str = ""
		portfolio.each do |stock|
			stock_str += "Symbol: #{stock.symbol}" + "\n Date: #{stock.date}" + "\n Open: #{stock.open}" + "\n Close: #{stock.close}" + "\n High: #{stock.high}" + "\n Low: #{stock.low}" + "\n Volume: #{stock.volume}"
			body.push(stock_str)
		end
		body = body.join("\n").html_safe	
		p ">>>>>>>>>>>>>>>>>>>>>>>"
		p body


		@client.messages.create(
			from: '+18562882747',#provided by twilio
			to: "+#{user.phone}",
			body: "#{body}"
		)
		
		redirect_to user_path(current_user)
	end
end
#A user should be able to send a message to their phone with stock information. Including: Opening, Closing, High, and Low prices.	