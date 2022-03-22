class UserSessionsController < ApplicationController
  skip_before_action :require_login
  before_action :already_logged_in, only: [:new]

  def new; end

  def create
    @user = login(params[:name], params[:password], params[:remember])
    if @user
      redirect_back_or_to root_path
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to login_path, success: 'ログアウトしました'
  end
end
