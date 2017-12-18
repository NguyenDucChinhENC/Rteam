class Api::V1::SearchController < Api::BaseController
  skip_before_action :authenticate_user_from_token

  def search
    if params[:q].nil?
      @groups = []
    else
      @groups = Group.search params[:q]
      tmp =[]
      @groups.each do |m|
      	tmp.push group_serializer(m)
      end
    end
    render json: {
      messages: "Search succsess",
      data: {
      	groups: groups
      }
    }, status: :ok
  end


  attr_reader :groups

  private


  def group_serializer full_groups
    Serializers::Groups::GroupsMiniSerializer.new(object: full_groups).serializer
  end
end