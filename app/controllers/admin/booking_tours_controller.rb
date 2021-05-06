class Admin::BookingToursController < ApplicationController
  before_action :load_booking_tours, only: %i(index update)
  before_action :load_booking_tour, only: %i(show update)
  before_action :is_exits_value_status, :valid_booking_status, only: %i(update)

  def index; end

  def update
    binding.pry
    @booking_tour.update status: params[:status].to_i
    flash[:success] = "Da thuc hien update thanh cong"

  rescue
    flash[:error] = "Da co loi xay ra, vui long load lai page"
  ensure
    respond_to do |format|
      format.js
    end
  end

  def show; end

  private

  def load_booking_tours
    @booking_tours = BookingTour.sort_by_start_date
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
    end

  def load_booking_tour
    byebug
    @booking_tour = BookingTour.find_by id: params[:id]
    return if @booking_tour

    flash[:error] = "Da co loi xay ra, vui long load lai trang"
    redirect_to admin_booking_tours_path
  end

  def is_exits_value_status
    return if BookingTour.statuses.values.include? params[:status]&.to_i

    flash[:error] = "Da co loi xay ra, vui long load lai trang"
    redirect_to admin_booking_tours_path
  end

  def valid_booking_status
    if params[:status] == BookingTour.statuses[:pending] &&  !@booking_tour.waiting?
      flash[:error] = "Da co loi xay ra, vui long load lai trang"
      redirect_to admin_booking_tours_path
    end
  end
end
