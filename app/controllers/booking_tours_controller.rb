class BookingToursController < ApplicationController
  before_action :logged_in_user
  before_action :load_tour, only: :create
  before_action :load_booking_tour, only: %i(show destroy)
  before_action :load_booking_tours, only: %i(index destroy)

  def index; end

  def show; end

  def destroy
    if @booking_tour.cancel!
      flash[:success] = "Đã thực hiện hủy bỏ thành công"
    else
      flash[:error] = "Hủy thất bại"
    end
    redirect_to booking_tours_path
  end

  def create
    @booking_tour = @current_user.booking_tours.build booking_tour_params
    @booking_tour.duaration = @tour.duaration
    @booking_tour.price = @tour.price
    @booking_tour.total_price = @tour.price * @booking_tour.quantity_person

    if @booking_tour.save
      flash[:success] = "Đăng ký tour thành công"
      redirect_to booking_tours_path
    else
      flash[:warning] = "Đã có lỗi xảy ra khi thực hiện đăng kí, vui lòng tải lại trang"
      render "tours/show"
    end
  end

  private

  def booking_tour_params
    params.require(:booking_tour)
      .permit(:start_date, :customer_name, :customer_email, :customer_phone, :duaration, :quantity_person, :note)
      .merge(tour_id: params[:tour_id])
  end

  def load_tour
    @tour = Tour.find_by id: params[:tour_id]
    return if @tour

    flash[:warning] = "Đã có lỗi xảy ra, vui lòng tải lại trang"
    redirect_to tours_path
  end

  def load_booking_tour
    @booking_tour = BookingTour.find_by id: params[:id]
    return if @booking_tour

    flash[:error] = "Đã có lỗi xảy ra, vui lòng tải lại trang"
    redirect_to booking_tours_path
  end

  def load_booking_tours
    @booking_tours = @current_user.booking_tours 
      .sort_by_update_at
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
  end
end
