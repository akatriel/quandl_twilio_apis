class SessionsController < ApplicationController
	def new
	end
	def create
		user = User.where(username: params[:username]).first
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to current_user
		else
			render :new
		end
	end
	def destroy
		session[:user_id] = nil
		redirect_to '/login'
	end
end
