class Admin::ToursController < ApplicationController
  before_action :load_tour, only: %i(show update destroy)
  
  def show
     @category = Category.all
  end

  def new
    @tour = Tour.new
    @category = Category.all
  end

  def create
    @category = Category.find(params[:category]) 
    @tour = @category.tours.create tour_params
    if @tour.save
      flash[:success] = "Thêm tour thành công"
      @tour.image.attach params[:tour][:image] if params[:tour][:image]
      redirect_to admin_tours_path
    else
      flash[:error] = "Đã có lỗi, tạo tour thất bại"
      redirect_to admin_tour_path
    end
      
  end

  def index
    @tours = Tour.search_by_duaration(params[:duaration])
      .sort_by_updated_at
      .paginate(page: params[:page], per_page: Settings.paginate.page_6)
  end

    def edit
      @tour = Tour.find_by id: params[:id]
    end

  def update
    if @tour.update tour_params
      flash[:success] = "Cập nhật thông tin tour thành công"
    else
      flash[:error] = "Cập nhật thông tin tour thất bại"
    end
    @tour.image.attach params[:tour][:image] if params[:tour][:image]
    redirect_to admin_tour_path
  end 


  def destroy
    if @tour.destroy 
    flash[:success] = "Bạn đã xóa thành công!"
    else
    flash[:error] = " Bạn đã xóa thất bại"
    end
    redirect_to admin_tours_path
  end

  
  private

  def load_tour
    @tour = Tour.find_by id: params[:id]
    return if @tour

    flash[:error] = "Đã có lỗi xảy ra, vui lòng tải lại trang"
    redirect_to tours_path
  end

  def tour_params
    params.require(:tour)
          .permit :name, :description, :price, :image, :duaration, :category_id
  end
end
