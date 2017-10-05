class Api::V1::GroupsController < Api::BaseController
  before_action :find_object, only: %i(show destroy).freeze
  before_action :authenticate_with_token!, only: %i(show index destroy).freeze

  def index
    tmp = []
    @current_user.member_group.each do |m|
      if m.group.status == true
        tmp.push group_mini_serializer m.group
      end
    end
    render json: {
      data: {groups: tmp}
    }, status: :ok
  end

  def show
    if (group.present? && group.status == true)
      if check_membered
        if (membered.accept == true)
          show_group
        else
          render json: {
          data: {group: group_mini_serializer(group),
          membered: false,
          accept: true}
          }, status: :ok
        end
      else
        render json: {
        data: {group: group_mini_serializer(group),
        membered: false,
        accept: false}
        }, status: :ok
      end
    else 
      render json: {
        messages: "not found groud"
      }, status: 404
    end
  end

  def create
    @group = Group.new group_params
    if @group.save
      member_group = @current_user.member_group.new(id_group: @group.id, admin: true)
      if member_group.save
        show_group
      else
        cant_show_group
      end
    else
      cant_show_group
    end
  end

  def destroy
    if (group.present? && group.status == true)
      if (check_membered && membered.admin == true)
        if group.update_attributes(status: false)
          render json: {
            messages: I18n.t("group.destroy_success")
          }, status: :ok
        end
      end
    end
  end

  attr_reader :group, :membered
  private
  # def find_group
  #   @group = Group.find_by id: params[:id]
  # end

  def show_group
    render json: {
      data: {group: group,
      membered: true,
      member_total: list_membered.count,
      list_membered: list_membered,
      member_waiting: member_waiting}
    }, status: :ok
  end

  def cant_show_group
    render json: {
    }, status: 404
  end

  def group_params
    params.require(:group).permit Group::ATTRIBUTES_PARAMS
  end

  def member_group_params
    id_group = @group.id, admin = true
  end

  def check_membered
    @membered = MemberGroup.
      find_by_membergrouptable_id_and_id_group(@current_user.id, group.id)
  end

  def member_waiting
    members = MemberGroup.waiting group.id
    tmp = []
    members.each do |m|
      tmp.push member_group_serializer m
    end
    tmp
  end

  def list_membered
    members = MemberGroup.membered group.id
    tmp = []
    members.each do |m|
      tmp.push user_serializer m.membergrouptable
    end
    tmp
  end

  def group_mini_serializer group_full
    Serializers::Group::GroupsMiniSerializer.new(object: group_full, user: @current_user.id).serializer
  end

  def user_serializer member
    Serializers::User::MiniUsersSerializer.new(object: member).serializer
  end

  def member_group_serializer member_group
    Serializers::MemberGroup::MembersGroupSerializer.new(object: member_group).serializer
  end
end