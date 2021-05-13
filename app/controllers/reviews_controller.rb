class ReviewsController < ApplicationController
  before_action :force_json, only: :search  
  before_action :logged_in_user
  before_action :load_tour, only: %i(new create)
  before_action :load_review, only: %i(edit update destroy)

  def new
    @review = @tour.reviews.new
  end

  def create
    @review = @tour.reviews.new review_params
    if @review.save
      flash[:info] = "Tao review thanh cong"
    else
      flash[:error] = "Da co loi, tao review that bai"
    end

    redirect_to tours_path
  end

  def index
    @reviews = Review.view.sort_by_created_at.paginate(page: params[:reviews], per_page: Settings.paginate.page_8)
    @tours = Tour.all# @reviews_of_tour = @tour.reviews.view.paginate(page: params[:reviews], per_page: Settings.paginate.page_8)
    @my_reviews = current_user.reviews.sort_by_created_at.paginate(page: params[:my_reviews], per_page: Settings.paginate.page_6)
    @tours = Tour.search_by_name(params[:name])
      .sort_by_name
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
    @reviews = Review.search_by_created_at(params[:created_at])
      .search_by_content(params[:content])

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

  def edit; end

  def update
    if @review.update(review_params)   
      redirect_to reviews_path(tab: 'my_reviews')
      flash[:success] = "Review Updated!"   
    else  
      render action: :edit   
    end   
  end 


  def review_params
    params.require(:review).permit(:content)
  end  

  def destroy
    @review.destroy
    flash[:success] = "Bạn đã xóa thành công!"
    redirect_to reviews_path(:tab => 'my_reviews')
  end

  # def search
  #   q = params[:q].downcase
  #   @review = Review.where("user_name ILIKE ? or content ILIKE ? or created_at ILIKE ?", "%#{q}%", "%#{q}%", "%#{q}%" ).limit(5)
  # end
  

  private

  def review_params
      params.require(:review)
      .permit(:content, :point)
      .merge(user_id: current_user.id)
  end

  def load_tour
    @tour = Tour.find_by id: params[:tour_id]
    return if @tour

    flash[:warning] = "Da co loi xay ra, vui long load lai page"
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

    flash[:error] = "Da co loi xay ra, vui long load lai trang"
    redirect_to reviews_path(reviews: 1)
  end

  def force_json
    request.format = :json
  end

end


