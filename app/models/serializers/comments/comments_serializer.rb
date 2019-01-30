include ActionView::Helpers::DateHelper

module Serializers
	module Comments
		class CommentsSerializer < Serializers::SupportSerializer
			attrs :id, :user_id, :user_name, :event_id, :body, :created_at, :time_ago

			def user_name
				object.user.name
			end

			def time_ago
				time_ago_in_words(created_at)
			end
		end
	end
end