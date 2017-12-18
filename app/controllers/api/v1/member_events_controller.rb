class Api::V1::MemberEventsController < Api::BaseController
	before_action :find_object, only: %i(destroy).freeze
	before_action :authenticate_with_token!

	def create
		if joined
			render json: {
		      messageer: "memberd"
		    }, status: :ok
		else
			member_event = @current_user.member_event.new(event_id: params[:id])
			if member_event.save
				render json: {
			      messageer: "joined",
			      member_event: member_event
			    }, status: :ok
			end
		end
	end

	def destroy
		if check_admin_event || check_userself
			if member_event.destroy
				render json: {
					messageer: "cancle join success",
					member_event_id: member_event.id
				}
			end
		end
	end

	attr_reader :member, :member_event
	private

	def joined
		@member = MemberEvent.find_by(user_id: @current_user.id, event_id: params[:id])
	end

	def check_admin_event
		@admin_event = AdminEvent.find_by(event_id: params[:id],user_id: @current_user.id)
	end

	def check_userself
		if @member_event.membereventtable_id = @current_user.id
			return true
		else
			return false
		end
	end
end