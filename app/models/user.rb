class User < ActiveRecord::Base
	has_secure_password
	has_many :assets
	has_many :stocks, through: :assets

	validates :username, presence: true, uniqueness: true 
	validates :password, length: { in: 6..20 }
	validates :password, presence: true, on: :create
	validates :phone, phone: true
end
