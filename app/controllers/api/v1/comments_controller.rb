class Api::V1::CommentsController < Api::BaseController
	before_action :find_object, only: %i().freeze
	before_action :authenticate_with_token!

	def create
		@comment = @current_user.comments.new comment_params
		if @comment.save
			render json: {
				comment: @comment
			}, status: :ok
		end
	end

	attr_reader :comment
	private

	def comment_params
		params.require(:comment).permit Comment::ATTRIBUTES_PARAMS
	end
end