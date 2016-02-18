class MessagesController < ApplicationController
	def create
		account_sid = 'AC43bb8565723b5728e0a1c4a286927135'
		auth_token = '3ce9a0560df8fcd67a7d520e869a534f'
		@client = Twilio::REST::Client.new account_sid, auth_token
		@client.messages.create(
			from: '+18562882747',#provided by twilio
			to: '+12679718062',
			body: 'Hey there!'
		)
		redirect_to user_path(current_user)
	end
end
