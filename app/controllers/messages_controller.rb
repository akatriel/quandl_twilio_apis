class MessagesController < ApplicationController
	def create
		@client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]

		user = current_user
		portfolio = user.stocks

		body = []
		portfolio.each do |stock|
			stock_str = ""
			stock_str += "Symbol: #{stock.symbol}" + "\n Date: #{stock.date}" + "\n Open: #{stock.open}" + "\n Close: #{stock.close}" + "\n High: #{stock.high}" + "\n Low: #{stock.low}" + "\n Volume: #{stock.volume}"
			body.push(stock_str)
		end
		body = body.join("\n").html_safe
		p ">>>>>>>>>>>>>>>>>>>>>>>"
		p body


		begin
			@client.messages.create(
				from: "+1#{ENV['twilio_number']}",#provided by twilio
				to: "+1#{user.phone}",
				body: "#{body}"
			)
		rescue
			flash[:alert] = "There was an issue sending your message."
		ensure
			redirect_to user_path(current_user)
		end
	end
end