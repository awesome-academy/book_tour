class ReviewsController < ApplicationController
  before_action :logged_in_user, only: %i(new update edit)
  before_action :load_review, except: %i(index new create)
  respond_to :html, :json
  load_and_authorize_resource

  def index
    @reviews = if current_user&.admin?
                 Review.includes(:user, :tour_detail).all
                       .paginate(page: params[:page])
               else
                 Review.includes(:user, :tour_detail)
                       .where(user_id: current_user.id)
                       .paginate(page: params[:page])
               end
  end

  def show; end

  def new
    @review = Review.new
    @tour_detail = params[:tour_detail]
    @user = params[:user]
    respond_modal_with @review, @tour_detail
  end

  def create
    @review = Review.new review_params
    @review.user = current_user
    @review.link = params[:review][:pictures_attributes][:link]
    if @review.save
      flash.now[:success] = t ".create_success"
    else
      flash.now[:danger] = t ".create_failed"
    end
    redirect_back fallback_location: @tour_detail
  end

  def edit; end

  def update
    @review.assign_attributes review_params
    if @review.save
      flash.now[:success] = t ".update_success"
    else
      flash.now[:danger] = t ".update_failed"
    end
    render :edit
  end

  def destroy
    if @review.destroy
      flash.now[:success] = t ".delete_success"
    else
      flash.now[:danger] = t ".delete_failed"
    end
    redirect_back fallback_location: @tour_detail
  end

  private

  def review_params
    params.require(:review).permit :content, :rating,
                                   :tour_detail_id, :user_id
  end

  def load_review
    return if @review = Review.includes(:user, :tour_detail)
                              .find_by(id: params[:id])

    flash[:danger] = t "reviews.nonexist"
    redirect_to root_path
  end
end
