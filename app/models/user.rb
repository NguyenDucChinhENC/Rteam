class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  ATTRIBUTES_PARAMS = [:email, :name, :avatar,
    :password, :password_confirmation].freeze
  UPDATE_ATTRIBUTES_PARAMS = [:email, :name, :avatar, :status].freeze
    
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    self.update_attributes authentication_token: token
  end
end
