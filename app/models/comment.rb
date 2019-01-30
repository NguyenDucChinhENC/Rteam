class Comment < ApplicationRecord
	belongs_to :user, foreign_key: 'user_id'
	belongs_to :event, foreign_key: 'event_id'
	has_many :reply

	ATTRIBUTES_PARAMS = [:event_id, :body].freeze
	UPDATE_ATTRIBUTES_PARAMS = [:body].freeze

	validates :event_id, presence: true
	validates :body, presence: true
end
