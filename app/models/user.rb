class User < ActiveRecord::Base
	has_secure_password
	has_many :stocks

	validates :username, presence: true, uniqueness: true 
	validates :password, presence: true, length: { in: 6..20 }
	validates :phone, phone: true
end
