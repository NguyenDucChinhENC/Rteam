class Api::V1::UsersController < Api::BaseController
  before_action :find_object, only: %i(show update destroy).freeze
  before_action :authenticate_with_token!, only: %i(update destroy).freeze
  skip_before_action :authenticate_user_from_token, only: :show

  def show
    if user.status
      render json: {
        messages: I18n.t("flashs.messeges.found", name: User),
        data: {user: user_serializer}
      }, status: :ok
    else
      render json: {
        messages: I18n.t("flashs.messeges.not_found", name: User)
      }, status: 422
    end
  end

  def update
    if user.status
      if user.update_attributes user_params
        render json: {
          messages: I18n.t("user.update_success")
        }, status: :ok
      else 
        render json: {
          messages: I18n.t("user.not_update_success")
        }, status: 422
      end
    else
      restore_account
    end
  end

  def destroy
    user.update_attributes(status: false)
    user.sessions.destroy
    render json: {
      messages: I18n.t("user.delete_success")
    }, status: :ok
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit User::UPDATE_ATTRIBUTES_PARAMS
  end

  def restore_account
    if user.update_attributes user_params
      render json: {
        messages: I18n.t("user.restore_success")
      }, status: :ok
    else 
      render json: {
        messages: I18n.t("user.not_update_success")
      }, status: 422
    end
  end

  def user_serializer
    Serializers::Users::UsersSerializer.new(object: user).serializer
  end
end
