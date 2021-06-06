class Admin::ReviewsController < ApplicationController

  before_action :load_review, except: %i(index)
  def index
    @reviews = Review.sort_by_created_at.sort_by_status.search_by_feel_status(params[:feel_status]).paginate(page: params[:page], per_page: Settings.paginate.page_8)
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
