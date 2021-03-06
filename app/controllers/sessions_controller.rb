class SessionsController < ApplicationController
  def create
    @user = User.find_by email: params[:sessions][:email].downcase
    if @user&.authenticate params[:sessions][:password]
      log_in @user
      handler_remember @user
      flash[:success] = "Đăng nhập thành công"
      redirect_to (@user.admin? ? admin_booking_tours_path : root_path )
    else
      load_tours
      flash[:error] = "Email, mật khẩu không hợp lệ"
      render "static_pages/home"
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = "Đăng xuất thành công"
    redirect_to root_path
  end

  private

  def handler_remember user
   if params[:sessions][:remember_me] == "1"
      remember(user)
    else
      forget(user)
    end
  end
end
