class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  ATTRIBUTES_PARAMS = [:email, :name, :avatar,
    :password, :password_confirmation, :number_phone, 
    :birthday, :address, :country, :id_number, 
    :link_facebook, :workplace].freeze
  UPDATE_ATTRIBUTES_PARAMS = [:email, :name, :avatar, :status,
    :number_phone, :birthday, :address, :country, :id_number, 
    :link_facebook, :workplace].freeze

  mount_base64_uploader :avatar, AvatarUploader

  has_many :sessions, dependent: :destroy
  has_many :member_group, as: :membergrouptable
  has_many :member_event, as: :membereventtable
  has_many :events, as: :eventtable
  has_many :comments
  has_many :admin_events

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    self.update_attributes authentication_token: token
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end
end
