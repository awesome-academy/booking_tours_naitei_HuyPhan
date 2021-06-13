class ToursController < ApplicationController
  before_action :load_tour, :build_booking_tour, only: :show

  def show; end

  def index
    @tours = Tour.search_by_duaration(params[:duaration])
      .search_by_name(params[:name])
      .sort_by_name
      .paginate(page: params[:page], per_page: Settings.paginate.page_9)
      flash.now[:error] = "Nội dung tìm kiếm không tồn tại" unless @tours.any?
  end

  private

  def load_tour
    @tour = Tour.find_by id: params[:id]
    return if @tour

    flash[:error] = "Đã có lỗi xảy ra, vui lòng tải lại trang"
    redirect_to tours_path
  end

  def build_booking_tour
    @booking_tour = @tour.booking_tours.new
  end
end
