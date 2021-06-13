class ReviewsController < ApplicationController
  before_action :logged_in_user
  before_action :load_tour, only: %i(new create)
  before_action :load_review, only: %i(edit update destroy)

  def new
    @review = @tour.reviews.new
  end

  def create
    @review = @tour.reviews.new review_params.merge(feel_status: 0)
    if @review.save
      flash[:info] = "Tạo review thành công"
    else
      flash[:error] = "Đã có lỗi, tạo review thất bại"
    end

    redirect_to tours_path
  end

  def index
    @tours = Tour.all
    @my_reviews = current_user.reviews.sort_by_created_at.paginate(page: params[:my_reviews], per_page: Settings.paginate.page_6)
    
    if params
      @reviews = Review.view
      if params[:content]
        @reviews = @reviews.search_by_key(params[:content])
      end
      if params[:tour_id]
        @reviews = @reviews.search_by_tour_id(params[:tour_id])
      end
      if params[:created_at].present?
        @reviews = @reviews.search_by_created_at(Date.parse(params[:created_at]))
      end
      @reviews = @reviews.paginate(page: params[:reviews], per_page: Settings.paginate.page_8)
    else
      @reviews = Review.view.sort_by_created_at.paginate(page: params[:reviews], per_page: Settings.paginate.page_8)
    end
      flash.now[:error] = "Nội dung tìm kiếm không tồn tại" unless @reviews.any?
  end



  def from_url_view
    render "reviews/from_url"
  end

  def from_url
    @tour = Tour.find_by id: 1
    @review = @tour.reviews.new
    @agent = Mechanize.new
    @agent.get params[:review_params][:url]
    @var = @agent.page.search('.entry-content').to_s
    @review.content = @var
    @review.point = rand(1..5)
    @review.user_id = 1
    @review.tour_id = 1
    @review.status = 0
    @review.is_active = false
    # @review.is_positive = false
    @review.save
    render "reviews/from_url"
  end

  def show
      @review = Review.find_by id: params[:id]
      @related_reviews = Review.where(["tour_id = ? and id != ?", @review.tour_id, @review.id]).limit(5)
      @newest_reviews = Review.order(created_at: :desc).limit(5)
  
  end

  def edit
    @tour = Tour.find_by id: @review.tour_id
  end

  def update
    if @review.update(review_params)   
      redirect_to reviews_path(tab: 'my_reviews')
      flash[:success] = "Bài review đã được cập nhật "   
    else  
      render action: :edit   
    end   
  end 


  def destroy
    @review.destroy
    flash[:success] = "Bạn đã xóa thành công!"
    redirect_to reviews_path(:tab => 'my_reviews')
  end

    private

  def review_params
      params.require(:review)
      .permit(:content, :point, :title)
      .merge(user_id: current_user.id)
  end

  def load_tour
    @tour = Tour.find_by id: params[:tour_id]
    return if @tour

    flash[:warning] = "Đã có lỗi xảy ra vui lòng tải lại trang "
    redirect_to tours_path
  end

  def load_reviews
    @reviews = @current_user.reviews
      .sort_by_update_at
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
  end

  def load_review
    @review = @current_user.reviews.find_by id: params[:id]
    return if @review

    flash[:error] = "Đã có lỗi xảy ra vui lòng tải lại trang "
    redirect_to reviews_path(reviews: 1)
  end

end


