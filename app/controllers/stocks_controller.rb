class StocksController < ApplicationController
	def create
		@user = current_user
		ticker = params[:ticker].upcase
		begin
			dataset = Stock.get_dataset "#{ticker}"
			stock = Stock.new
			stock.symbol = ticker
			stock.user_id = @user.id
			stock.save
			flash[:notice] = "#{ticker} has been added to your portfolio!"
			redirect_to user_path(@user)
		rescue
			flash[:alert] = "Could not add stock to portfolio."
			redirect_to user_path(@user)
		end
	end

	# def show
	# 	@stock = params[:id]
	# 	@dataset = Stock.new.get_dataset "#{ticker}"
	# end
end
