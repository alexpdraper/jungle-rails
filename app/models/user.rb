class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, length: { minimum: 5 }

  has_many :reviews
  has_secure_password

  def self.authenticate_with_credentials(email, password)
    formatted_email = email.downcase.strip
    user = User.where('lower(email) = ?', formatted_email).first
    user = nil unless user && user.authenticate(password)
    user
  end

end
