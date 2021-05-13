class Admin::ReviewsController < ApplicationController

  before_action :load_review, except: %i(index)
  def index
    @reviews = Review.view.sort_by_created_at.sort_by_status.paginate(page: params[:page], per_page: Settings.paginate.page_8)
  end

  def show
  end

  def rejected
    @review.rejected!
    flash[:success] = "Da update thanh cong"
    redirect_to admin_reviews_path
  end

  def public_view
    @review.view!
    flash[:success] = "Da update thanh cong"
    redirect_to admin_reviews_path
  end

  private

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review

    flash[:error] = "Da co loi xay ra, vui long load lai page"
    redirect_to admin_reviews_path
  end
end
