class Api::V1::CommentsController < Api::BaseController
  before_action :find_object, only: %i(update destroy).freeze
  before_action :authenticate_with_token!

  def create
    @comment = @current_user.comments.new comment_params
    if @comment.save
      render_json_success("Create success", @comment)
    end
  end

  def update
    if check_yourself(comment.user_id)
      if comment.update_attributes update_comment_params
        render_json_success("Update success", comment)
      else
        render_json_not_success("Update not success", 422)
      end
    end
  end

  def destroy
    if check_admin_event(comment.event_id) || check_yourself(comment.user_id)
      if comment.destroy
        render_json_success("Destroy success", comment.id)
      else
        render_json_not_success("Destroy not success", 422)
      end
    end
  end

  attr_reader :comment

  def comment_params
    params.require(:comment).permit Comment::ATTRIBUTES_PARAMS
  end

  def update_comment_params
    params.require(:comment).permit Comment::UPDATE_ATTRIBUTES_PARAMS
  end

  def comment_serializer
    Serializers::Comments::CommentsSerializer.new(object: comment).serializer
  end
end