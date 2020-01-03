class ToursController < ApplicationController
  before_action :load_tour, except: %i(index new create)
  load_and_authorize_resource

  def index
    @tours = if params.key?(:soft_deleted)
               Tour.includes(:category).all
                   .paginate(page: params[:page])
             else
               Tour.includes(:category).not_deleted
                   .paginate(page: params[:page])
             end
  end

  def show
    return if @category = Category.find_by(id: @tour.category_id)

    flash[:danger] = t "categories.nonexist"
    redirect_to root_path
  end

  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new tour_params
    if @tour.save
      flash[:success] = t ".add_success"
      redirect_to @tour
    else
      flash[:danger] = t ".add_failed"
      render :new
    end
  end

  def destroy
    if @tour.soft_delete
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to tours_path
  end

  def purge
    if @tour.destroy
      flash[:success] = t ".purge_success"
    else
      flash[:danger] = t ".purge_failed"
    end
    redirect_to tours_path
  end

  def recover
    if @tour.recover
      flash[:success] = t ".recover_success"
    else
      flash[:danger] = t ".recover_failed"
    end
    redirect_to tours_path
  end

  def edit; end

  def update
    if @tour.update tour_params
      flash[:success] = t ".update_success"
      redirect_to @tour
    else
      flash[:danger] = t ".update_failed"
      render :edit
    end
  end

  private

  def tour_params
    params.require(:tour).permit(:name, :description, :category_id)
  end

  def load_tour
    return if @tour = Tour.find_by(id: params[:id])

    flash[:danger] = t "tours.nonexist"
    redirect_to root_path
  end
end
