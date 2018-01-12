module Serializer
	module Comments
		class CommentsSerializer < Serializers::SupportSerializer
			attrs :id, :user_id, :user_name, :event_id, :body, :created_at, :time_ago

			def user_name
				object.user.name
			end
		end
	end
end