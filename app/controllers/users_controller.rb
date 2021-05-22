  class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :create
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(new create)

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      redirect_back_or root_url
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
          .permit :name, :email, :password, :password_confirmation, :phone, :address
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "users.not_found"
    redirect_to root_path
  end
end
