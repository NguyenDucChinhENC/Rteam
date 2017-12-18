class MemberEvent < ApplicationRecord
	belongs_to :membereventtable, polymorphic: true
	belongs_to :event, foreign_key: 'event_id'
	ATTRIBUTES_PARAMS = [:event_id, :status].freeze

end
