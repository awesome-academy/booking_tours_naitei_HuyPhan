class BookingToursController < ApplicationController
  before_action :logged_in_user
  before_action :load_tour, only: :create
  before_action :load_booking_tour, only: %i(show destroy)
  before_action :load_booking_tours, only: %i(index destroy)

  def index; end

  def show; end

  def destroy
    @booking_tour.cancel!
    flash[:success] = "Da thuc hien cancel thanh cong"

  rescue
    flash[:error] = "Da co loi xay ra, vui long load lai page"
  ensure
    respond_to do |format|
      format.js
    end
  end

  def create
    @booking_tour = @current_user.booking_tours.build booking_tour_params
    @booking_tour.duaration = @tour.duaration
    @booking_tour.price = @tour.price
    @booking_tour.total_price = @tour.price * @booking_tour.quantity_person

    if @booking_tour.save
      flash[:success] = "Dang ky tour thanh cong"
      redirect_to booking_tours_path
    else
      flash[:warning] = "Da co loi xay ra khi thuc hien dang ky, vui long load page"
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

    flash[:warning] = "Da co loi xay ra, vui long load lai page"
    redirect_to tours_path
  end

  def load_booking_tour
    @booking_tour = BookingTour.find_by id: params[:id]
    return if @booking_tour

    flash[:error] = "Da co loi xay ra, vui long load lai trang"
    redirect_to booking_tours_path
  end

  def load_booking_tours
    @booking_tours = @current_user.booking_tours
      .sort_by_update_at
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
  end
end
