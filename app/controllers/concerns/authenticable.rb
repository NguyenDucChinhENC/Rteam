module Authenticable
	def current_user
		@current_user ||= User.
			find_by authentication_token: request.headers["RT-AUTH-TOKEN"]
	end

	def authenticable_with_token!
		return if current_user
		render json: {
			messeges: I18n.t("devise.failure.unauthenticated")
		}, status: :unauthenticated
	end

	def user_signed_in?
		current_user.present?
	end
end