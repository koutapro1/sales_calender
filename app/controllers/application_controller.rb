class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  # すでにログイン済みの場合はカレンダーページに遷移させる
  def already_logged_in
    if logged_in?
      redirect_to root_path
    end
  end

  # 引数をFloatオブジェクトに変換できるか判定する
  def unixtime_string?(str)
    Float(str)
    true
  rescue ArgumentError
    false
  rescue TypeError
    false
  end
end