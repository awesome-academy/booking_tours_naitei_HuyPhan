class Admin::ReviewsController < ApplicationController

  before_action :load_review, except: %i(index)
  def index
    @tours = Tour.all
    @reviews = Review.sort_by_created_at.sort_by_status.search_by_feel_status(params[:feel_status]).paginate(page: params[:page], per_page: Settings.paginate.page_8)
    if params
      @reviews = Review.view
      if params[:tour_id]
        @reviews = @reviews.search_by_tour_id(params[:tour_id])
      end
      @reviews = @reviews.paginate(page: params[:reviews], per_page: Settings.paginate.page_8)
    else
      @reviews = Review.view.sort_by_created_at.paginate(page: params[:reviews], per_page: Settings.paginate.page_8)
    end
      flash.now[:error] = "Nội dung tìm kiếm không tồn tại" unless @reviews.any?
  end


  def show
  end

  def rejected
    @review.rejected!
    flash[:success] = "Đã thực hiện cập nhật thành công"
    redirect_to admin_reviews_path
  end

  def public_view
    @review.view!
    flash[:success] = "Đã thực hiện cập nhật thành công"
    redirect_to admin_reviews_path
  end

  private

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review

    flash[:error] = "Đã có lỗi xảy ra, vui long tải lại trang"
    redirect_to admin_reviews_path
  end
end
