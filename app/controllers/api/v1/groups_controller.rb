class Api::V1::GroupsController < Api::BaseController
  before_action :find_object, only: %i(show update destroy).freeze
  before_action :authenticate_with_token!, only: %i(show index update destroy).freeze

  def index
    tmp = []
    groups = @current_user.member_group.page(params[:page]).per(5)
    groups.each do |m|
      if m.group.status == true
        tmp.push group_mini_index_serializer(m.group, @current_user.id)
      end
    end
    tmp_admin = []
    groups_1 = @current_user.member_group
    groups_1.each do |m|
      if m.group.status == true
        is_admin = MemberGroup.find_by(membergrouptable_id: @current_user.id, id_group: m.group.id).admin
          if is_admin
            tmp_admin.push groups_name_index_serializer(m.group)
          end
      end
    end

    render json: {
      data: {groups: tmp,
        admin_groups: tmp_admin}
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
          id_membered_group: membered.id,
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

  def update
    if (group.present? && group.status == true)
      if (check_membered && membered.admin == true)
        if group.update_attributes group_params
          render json: {
            messages: "Update success"
          }, status: :ok
        end
      end
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

  attr_reader :group, :membered, :groups
  private
  
  def groups_params
    params.require(:group).permit Group::ATTRIBUTES_PARAMS
  end

  def show_group
    check_membered
    tmp_event = []
    events_list = group.events
    events_list.each do |event|
      tmp_event.push event_serializer(event, @current_user.id)
    end
    tmp_event.uniq
    tmp_event = tmp_event.sort_by{|e| e[:created_at]}.reverse
    render json: {
      data: {group: group,
      events: tmp_event,
      membered: true,
      admin: membered.admin,
      member_total: list_membered.count,
      id_membered_group: membered.id,
      event_total: events_list.count,
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
      tmp.push member_group_serializer m
    end
    tmp
  end

  def group_mini_serializer group_full
    Serializers::Group::GroupsMiniSerializer.new(object: group_full, id_user: @current_user.id).serializer
  end

  def groups_name_index_serializer group_full
    Serializers::Group::GroupsNameSerializer.new(object: group_full).serializer
  end

  def group_mini_index_serializer(group_full, id_user)
    Serializers::Group::GroupsMiniSerializer.new(object: group_full, id_user: @current_user.id).serializer
  end

  def user_serializer member
    Serializers::User::MiniUsersSerializer.new(object: member).serializer
  end

  def member_group_serializer member_group
    Serializers::MembersGroup::MembersGroupSerializer.new(object: member_group).serializer
  end

  def event_serializer(event, id_user)
    Serializers::Event::EventsSerializer.new(object: event, id_user: id_user).serializer
  end
end