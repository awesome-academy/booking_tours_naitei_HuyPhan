class SessionsController < ApplicationController
  def create
    byebug
    @user = User.find_by email: params[:sessions][:email].downcase
    if @user&.authenticate params[:sessions][:password]
      log_in @user
      handler_remember @user
      flash[:success] = "Login thanh cong"
    else
      flash[:danger] = t "Email/password khong hop le"
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to static_pages_home_path
  end

  private

  def handler_remember user
   if params[:session][:remember_me] == S1
      remember(user)
    else
      forget(user)
    end
  end
end
