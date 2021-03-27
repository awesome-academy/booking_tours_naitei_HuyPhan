class ReviewsController < ApplicationController
  before_action :logged_in_user
  before_action :load_tour, only: %i(new create)
  before_action :build_review, only: %i(new)
 
  def new; end

  def index; end

  def show; end

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

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review

    flash[:error] = "Da co loi xay ra, vui long load lai trang"
    redirect_to booking_tours_path
  end

  def load_reviews
    @reviews = @current_user.reviews
      .sort_by_update_at
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
  end

  def build_review
    @review = @tour.reviews.new
  end
end
