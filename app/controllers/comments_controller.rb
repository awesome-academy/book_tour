class CommentsController < ApplicationController
  before_action :find_commentable, only: %i(create destroy)
  authorize_resource

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.build comment_params
    @comment.user = current_user
    if @comment.save
      flash.now[:success] = t(".add_success")
    else
      flash.now[:danger] = t(".add_failed")
    end
    redirect_back fallback_location: @tour_detail
  end

  def destroy
    @comment = Comment.find params[:id]
    if @comment.user == current_user || current_user&.admin?
      if @comment.destroy
        flash[:success] = t ".delete_success"
      else
        flash[:danger] = t ".delete_failed"
      end
    else
      flash[:danger] = t ".not_authorized"
    end
    redirect_back fallback_location: @tour_detail
  end

  private

  def comment_params
    params.require(:comment).permit :content, :user_id
  end

  def find_commentable
    if params[:comment_id]
      @commentable = Comment.find_by id: params[:comment_id]
    elsif params[:review_id]
      @commentable = Review.find_by id: params[:review_id]
    end
  end
end
