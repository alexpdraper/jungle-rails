class User < ActiveRecord::Base
  validates :email, presence: true

  has_many :reviews
  has_secure_password

end
