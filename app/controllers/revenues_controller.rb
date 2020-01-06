class RevenuesController < ApplicationController
  before_action :load_revenue, only: %i(show destroy)
  load_and_authorize_resource

  def index
    @revenues = Revenue.includes(:tour_detail).all.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.csv{send_data @revenues.to_csv}
      format.xls{send_data @revenues.to_csv(col_sep: "\t")}
    end
  end

  def show
    @tour_detail = TourDetail.find_by(id: @revenue.tour_detail_id)
    @bookings = Booking.where(tour_detail_id: @tour_detail.id)
                       .paginate(page: params[:page])
  end

  def destroy
    if @revenue.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to revenues_path
  end

  def revenue_detail
    @revenues = Revenue.includes(:tour_detail).all.paginate(page: params[:page])
    render :table
  end

  private

  def load_revenue
    return if @revenue = Revenue.find_by(id: params[:id])

    flash.now[:danger] = t "revenues.nonexist"
    render :index
  end
end
