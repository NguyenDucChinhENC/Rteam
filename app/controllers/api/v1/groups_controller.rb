class Api::V1::GroupsController < Api::BaseController
  before_action :find_object, only: %i(show).freeze
  before_action :authenticate_with_token!, only: %i(show index).freeze

  def index
    tmp = []
    @current_user.member_group.each do |m|
      tmp.push m.group
    end
    render json: {
      data: {groups: tmp}
    }, status: :ok
  end

  def show
    if group.present?
      if check_membered
        show_group
      end
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

  attr_reader :group, :membered
  private
  # def find_group
  #   @group = Group.find_by id: params[:id]
  # end

  def show_group
    render json: {
      data: {group: @group}
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
    @membered = MemberGroup.find_by_membergrouptable_id_and_id_group(@current_user.id, group.id)
  end
end