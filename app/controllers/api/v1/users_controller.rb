class Api::V1::UsersController < Api::BaseController
  before_action :find_object, only: [:show, :destroy]

  def show
    if @user.status
      render json: {
        messages: I18n.t("flashs.messeges.found", name: User),
        data: {user: @user}
      }, status: :ok
    else
      render json: {
        messages: I18n.t("flashs.messeges.not_found", name: User)
      }, status: 422
    end
  end

  def destroy
    @user.update_attributes(status: false)
    render json: {
      messages: I18n.t("user.delete_success")
    }, status: :ok
  end

  private

end
