class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :already_logged_in, only: [:new]
  before_action :set_user, only: %i[show edit update]
  before_action :forbid_access_to_other_user, only: %i[show edit update]
  before_action :restrict_guest_access, only: %i[edit update]

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to login_path, success: 'ユーザー登録が完了しました'
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, success: 'ユーザー情報を変更しました'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def forbid_access_to_other_user
    redirect_to root_path, danger: '権限がありません' if @user != current_user
  end

  def restrict_guest_access
    redirect_to user_path, danger: 'ゲストユーザーではご利用になれません' if @user.guest?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
