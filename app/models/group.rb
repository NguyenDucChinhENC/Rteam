class Group < ApplicationRecord
  ATTRIBUTES_PARAMS = [:name, :description, :public_status, :enable_search].freeze
  has_many :member_group
end
