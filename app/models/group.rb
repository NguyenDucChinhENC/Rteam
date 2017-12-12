class Group < ApplicationRecord
  ATTRIBUTES_PARAMS = [:name, :description, :public_status, :enable_search, :cover].freeze

  mount_base64_uploader :cover, CoverUploader

  has_many :member_group
  has_many :events, as: :eventtable

  validates :name, presence: true
end
