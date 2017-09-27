module Authenticable
  def current_user
    @current_user_id ||= Session.find_by token_session: request.headers["RT-AUTH-TOKEN"]
    if @current_user_id
      @current_user ||= User
        .find_by id: @current_user_id.id_user
    end
  end

  def authenticate_with_token!
    return if current_user
    render json: {
      messages: I18n.t("devise.failure.unauthenticated")
    }, status: :unauthorized
  end

  def user_signed_in?
    current_user.present?
  end
end