class Api::BaseController < ActionController::API
  include Authenticable
  acts_as_token_authentication_handler_for User, {fallback: :none}

  private

  alias_method :authenticable_user_form_token, :authenticable_with_token!

  def find_variable_name
    return if params[:controller].blank?
    params[:controller].split("/").last.singularize
  end

  def ensure_parameters_exist
    find_variable_name

    return unless params[find_variable_name].blank?
    render json: {
      messages: "Missing parameter"
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
end