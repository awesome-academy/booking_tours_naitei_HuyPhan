class Admin::ReviewsController < ApplicationController

  before_action :load_review, except: %i(index)
  def index
    @tours = Tour.all
    if params
      @reviews = Review
      if params[:tour_id]
        @reviews = @reviews.search_by_tour_id(params[:tour_id])
      end
       if params[:feel_status]
        @reviews = @reviews.search_by_feel_status(params[:feel_status])
      end
      @reviews = @reviews.paginate(page: params[:page], per_page: Settings.paginate.page_8)
    else
      @reviews = Review.sort_by_created_at.paginate(page: params[:page], per_page: Settings.paginate.page_8)
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
