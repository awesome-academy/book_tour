class LikesController < ApplicationController
  before_action :load_review
  before_action :load_like, only: :destroy
  load_and_authorize_resource

  def create
    if already_liked?
      flash.now[:notice] = t ".like_more"
    else
      @review.likes.create user_id: current_user.id
    end
    respond_to do |format|
      format.html{redirect_back fallback_location: @tour_detail}
      format.js
    end
  end

  def destroy
    if !already_liked?
      flash.now[:notice] = t ".cannot_unlike"
    else
      @like.destroy
    end
    respond_to do |format|
      format.html{redirect_back fallback_location: @tour_detail}
      format.js
    end
  end

  private
  def load_review
    return if @review = Review.find(params[:review_id])

    flash[:danger] = t "reviews.nonexist"
    redirect_to root_path
  end

  def load_like
    return if @like = @review.likes.find(params[:id])

    flash[:danger] = t "likes.nonexist"
    redirect_to root_path
  end

  def already_liked?
    Like.where(user_id: current_user.id, review_id:
    params[:review_id]).exists?
  end
end
