class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end

  def already_logged_in
    if logged_in?
      redirect_to root_path
    end
  end
end
