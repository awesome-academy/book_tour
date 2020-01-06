class TourDetailsController < ApplicationController
  before_action :load_tour_detail, except: %i(index new create)
  load_and_authorize_resource

  def index
    @tour_details = if current_user&.admin?
                      if params.key?(:soft_deleted)
                        TourDetail.includes(:tour).all
                                  .paginate(page: params[:page])
                      else
                        get_existed_tour_details
                      end
                    else
                      get_available_tour_details
                    end
    search_tour
  end

  def new
    @tour_detail = TourDetail.new
  end

  def show
    if @tour = Tour.find_by(id: @tour_detail.tour_id)
      return if @category = Category.find_by(id: @tour.category_id)

      flash[:danger] = t "categories.nonexist"
    else
      flash[:danger] = t "tours.nonexist"
    end
    render :index
  end

  def create
    @tour_detail = TourDetail.new tour_detail_params
    @tour_detail.link = params[:tour_detail][:pictures_attributes][:link]
    if @tour_detail.save
      flash[:success] = t ".create_success"
      redirect_to @tour_detail
    else
      flash[:danger] = t ".create_failed"
      render :new
    end
  end

  def destroy
    if @tour_detail.soft_delete
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to tour_details_path
  end

  def purge
    if @tour_detail.destroy
      flash[:success] = t ".purge_success"
    else
      flash[:danger] = t ".purge_failed"
    end
    redirect_to tour_details_path
  end

  def recover
    if @tour_detail.recover
      flash[:success] = t ".recover_success"
    else
      flash[:danger] = t ".recover_failed"
    end
    redirect_to tour_details_path
  end

  def edit; end

  def update
    @tour_detail.link = params[:tour_detail][:pictures_attributes][:link]
    if @tour_detail.update tour_detail_params
      flash[:success] = t ".update_success"
      redirect_to @tour_detail
    else
      flash[:danger] = t ".update_failed"
      render :edit
    end
  end

  private

  def search_tour
    @search = TourDetail.ransack(params[:q])
    @tour_details = @search.result.includes(:tour)
                           .paginate(page: params[:page])
    return if params.key?(:q)
  end

  def tour_detail_params
    params.require(:tour_detail).permit :start_time, :end_time, :tour_id,
                                        :price, :people_number, :term
  end

  def load_tour_detail
    return if @tour_detail = TourDetail.find_by(id: params[:id])

    flash[:danger] = t "tour_details.nonexist"
    redirect_to root_path
  end

  def get_existed_tour_details
    TourDetail.includes(:tour).not_deleted
              .paginate(page: params[:page])
  end

  def get_available_tour_details
    TourDetail.includes(:tour).available
              .paginate(page: params[:page])
  end
end
