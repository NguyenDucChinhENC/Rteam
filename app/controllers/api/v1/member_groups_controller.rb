class Api::V1::MemberGroupsController < Api::BaseController
  before_action :find_object, only: %i(update).freeze
  before_action :authenticate_with_token!

  def create
    if check_membered
      render json: {
        messageer: "memberd"
      }, status: :ok
    else
      member_group = @current_user.member_group.new(id_group: params[:id], admin: false, accept: false)
      if member_group.save
        byebug
        render json: {
          data: {group: member_group}
      }, status: :ok
      end
    end
  end

  def update
    byebug
    if check_membered && membered.accept == true && membered.admin == true
      if member_group.update_attributes member_group_params
        render json: {
          messages: I18n.t("member.update_success"),
          data: { user: member_group_serializer(member_group)}
        }, status: :ok
      else
        render json: {
          messages: I18n.t("member.no_update_success")
        }, status: :ok
      end
    end
  end

  attr_reader :membered, :member_group
  private
  def check_membered
    @membered = MemberGroup.find_by_membergrouptable_id_and_id_group(@current_user.id, params[:id])
  end

  def member_group_params
    params.require(:member).permit MemberGroup::ATTRIBUTES_PARAMS
  end

  def member_group_serializer member_group
    Serializers::MemberGroup::MembersGroupSerializer.new(object: member_group).serializer
  end
end
