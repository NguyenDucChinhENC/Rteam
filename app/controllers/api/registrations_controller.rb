module Api
  class RegistrationsController < Devise::RegistrationsController
    protect_from_forgery with: :null_session

    def create
      user = User.new user_params
      if user.save
        render json: {
          message: I18n.t("devise.registrations.signed_up"),
          data: {user: user}
        }, status: 201
      else
        warden.custom_failure!
        render json: {
          message: user.errors.messages,
          data: {}
        }, status: 422
      end
    end

    private

    def user_params
      params.require(:user).permit User::ATTRIBUTES_PARAMS
    end
  end
end