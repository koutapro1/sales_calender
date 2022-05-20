class Scores::SearchesController < ApplicationController
  # 月度ジャンプ機能
  def index
    redirect_path = %Q[#{root_path}?start_date=#{params["selected_month(1i)"]}-#{params["selected_month(2i)"]}-#{params["selected_month(3i)"]}]
    redirect_to redirect_path
  end

  # クリックした日付の売上詳細、もしくは売上追加フォームを表示する機能
  def score
    start_date = params[:start_date].to_date
    selected_date = params[:selected_date].sub(/\//, '-')
    @searched_score = Score.get_searched_score_in_current_page(selected_date, start_date, current_user)
    @score = Score.new
    render partial: "searched_score_field", locals: { start_date: start_date, selected_date: selected_date }
  end

  # 日報ページに遷移するときに、選択した日付のScoreがなければ作成してから遷移する
  def check
    @score = Score.find_by(start_time: params[:start_time], user: current_user)
    if @score.present?
      redirect_to score_score_details_path(@score)
    else
      @score = Score.create!(start_time: params[:start_time], user: current_user)
      redirect_to score_score_details_path(@score)
    end
  end
end