class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :require_login
  before_action :ensure_domain

  private

  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  # すでにログイン済みの場合はカレンダーページに遷移させる
  def already_logged_in
    redirect_to root_path if logged_in?
  end

  # .herokuapp.comにアクセスがあった際に、sales-calendar.netに301リダイレクトさせる
  def ensure_domain
    return unless /\.herokuapp.com/.match? request.host

    fdqn = 'sales-calendar.net'
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{fdqn}#{port}#{request.path}", status: :moved_permanently
  end
end
