class MemberGroup < ApplicationRecord
  belongs_to :membergrouptable, polymorphic: true
  belongs_to :group, foreign_key: 'id_group'
  ATTRIBUTES_PARAMS = [:id_group, :admin, :status].freeze
end
