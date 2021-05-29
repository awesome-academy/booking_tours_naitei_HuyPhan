  class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :create
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(new create confirm_mail_address)

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = 'Tạo tài khoản thành công, vui lòng kiểm tra email để kích hoạt tài khoản'
      redirect_to root_path
    else
      render :new
    end
  end

  def show; end

  def new
    @user = User.new
  end

  def confirm_mail_address
    @user = User.find_by email: params[:email]
    if @user && Digest::MD5.hexdigest(@user.confirm_token) == params[:token]
      @user.update confirm_token: nil, confirmed_at: Time.now
      log_in @user
      flash[:success] = 'Kích hoạt tài khoản thành công'
      redirect_to root_path
    else
      flash[:warning] = 'Token không hợp lệ hoặc đã hết hạn'
      redirect_to root_path
    end
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
