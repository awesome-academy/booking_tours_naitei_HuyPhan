class UsersController < ApplicationController

  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(new create)

    def create
    @user = User.new user_params
    if @user.save
      log_in @user
      redirect_back_or @user

    else
      render :new
    end
  end

  def show; end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "users.not_found"
  end

   def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "message.alert_login"
    redirect_to login_url
  end
end
