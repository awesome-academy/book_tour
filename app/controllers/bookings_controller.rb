class BookingsController < ApplicationController
  helper BookingsHelper
  before_action :load_booking, except: %i(index new create)
  respond_to :html, :json

  def index
    @bookings = Booking.includes(:tour_detail).all.paginate(page: params[:page])
  end

  def show
    @booking = Booking.find_by id: params[:id]
  end

  def new
    @booking = Booking.new
    @tour_detail = params[:tour_detail]
    respond_modal_with @booking, @tour_detail
  end

  def create
    @tour_detail = TourDetail.find_by id: params[:booking][:tour_detail_id]
    @booking = @tour_detail.bookings.build booking_params
    @booking.user = current_user
    if @booking.save
      flash[:success] = t(".add_success")
      redirect_to @booking
    else
      flash[:danger] = t(".add_failed")
      render :new
    end
  end

  def edit; end

  def update
    if @booking.update booking_params
      flash[:success] = t(".update_success")
      redirect_to @booking
    else
      flash[:danger] = t(".update_failed")
      render :edit
    end
  end

  def destroy
    if @booking.destroy
      flash[:success] = t(".delete_success")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:tour_detail_id, :price, :people_number)
  end

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:danger] = t("bookings.nonexist")
    redirect_to root_path
  end
end