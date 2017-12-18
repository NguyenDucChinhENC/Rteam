class Api::V1::AdminEventsController < Api::BaseController
	before_action :authenticate_with_token!

	def create
		if admined
			render json: {
				message: "admined"
			}
		else
			if check_admin_event
				admin_event = AdminEvent.new(event_id: params[:event_id], user_id: params[:user_id])
				if admin_event.save
					render json: {
						message: "success",
						admin_event: admin_event
					}
				end
			end
		end
	end

	attr_reader :admin_event
	private

	def admined
		@admin = AdminEvent.find_by(event_id: params[:event_id], user_id: params[:user_id])
	end

	def check_admin_event
		@admin_event = AdminEvent.find_by(event_id: params[:event_id],user_id: @current_user.id)
	end
end