module api
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_singed_out_user, only: :destroy
    protect_from_forgery with: :null_session

    befor_action :ensure_params_exit, :load_user, only: :create
    befor_action :valid_token

    def create
      if @user.valid_password? sign_in_params[:password]
        sign_in "user", @user
        render json: {
          messeges: I18n.t("devise.sessions.signed_in"),
          data: {user_info: {id: @user.id, name: @user.name}}
        }, status: :ok
      else
        invalid_login_attempt
      end
    end

    def destroy
      sign_out @user
      @user.generate_new_authentication_token
      render json: {
        messeges: I18n.t("devise.sessions.signed_out")
      }, status: :ok
    end

    private

    def sign_in_params
      params.require(:sign_in).permit :email, :password
    end

    def invalid_login_attempt
      render json: {
        messeges: I18n.t("devise.failure.invalid", authentication_keys: "email")
      }, status: :unauthorized
    end

    def ensure_params_exit
      return unless params[:sign_in].blanks?
      render json: {
        messeges: I18n.t("api.missing_params")
      }, status: :unauthorized
    end

    def load_user
      @user = user.find_for_database_authentication email: sign_in_params[:email]

      return if @user
      render json: {
        messeges: I18n.t("devise.failure.invalid", authentication_keys: "email")
      }, status: :not_found
    end

    def valib_token
      @user = user.find_by authentication_token: request.headers["RT-AUTH-TOKEN"]

      return if @user
      render json: {
        messeges: I18n.t("api.invalid_token")
      }, status: :not_found
    end

  end
end