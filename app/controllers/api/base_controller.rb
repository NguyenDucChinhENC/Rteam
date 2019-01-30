class Api::BaseController < ActionController::API  
  include Authenticable
  acts_as_token_authentication_handler_for User, {fallback: :none}

  private

  alias_method :authenticate_user_from_token, :authenticate_with_token!

  def find_variable_name
    return if params[:controller].blank?
    params[:controller].split("/").last.singularize
  end

  def ensure_parameters_exist
    find_variable_name
    return unless params[find_variable_name].blank?
    render json: {
      messages: I18n.t("api.missing_params")
    }, status: :unprocessable_entity
  end

  def find_object
    instance_name = find_variable_name
    instance_variable_set "@#{instance_name}",
      instance_name.classify.constantize.find_by(id: params[:id])
    render json: {
      messages:
        I18n.t("#{instance_name.pluralize}.messages.#{instance_name}_not_found")
    }, status: :not_found unless instance_variable_get "@#{instance_name}"
  end

  def check_admin_event event_id
    AdminEvent.find_by_event_id_and_user_id(event_id, @current_user.id)? true : false
  end

  def check_admin_group group_id
    MemberGroup.find_by_membergrouptable_id_and_id_group(@current_user.id, group_id).admin ? true : false
  end

  def check_yourself user_id
    @current_user.id == user_id ? true : false
  end

  def render_json_success(message, object)
    render json: {
      message: message,
      object: object
    }, status: :ok
  end

  def render_json_not_success(message, status)
    render json: {
      message: message
    }, status: status
  end
end