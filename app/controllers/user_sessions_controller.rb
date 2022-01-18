class UserSessionsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = login(params[:name], params[:password])
    if @user
      redirect_back_or_to root_path, success: 'ログインに成功しました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to root_path, success: 'ログアウトしました'
  end
end
