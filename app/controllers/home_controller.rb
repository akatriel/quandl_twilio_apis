require 'quandl'
require 'twilio-ruby'
class HomeController < ApplicationController
	
	def message
		account_sid = 'AC43bb8565723b5728e0a1c4a286927135'
		auth_token = '3ce9a0560df8fcd67a7d520e869a534f'
		@client = Twilio::REST::Client.new account_sid, auth_token
		@client.messages.create(
		  from: '+14159341234',
		  to: '+12679718062',
		  body: 'Hey there!',
		  media_url: 'http://example.com/smileyface.jpg'
		)

	end
end
