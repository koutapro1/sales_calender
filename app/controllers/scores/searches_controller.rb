class Scores::SearchesController < ApplicationController
  # 月度ジャンプ機能
  def index
    redirect_path = %Q[#{root_path}?start_date=#{params["selected_month(1i)"]}-#{params["selected_month(2i)"]}-#{params["selected_month(3i)"]}]
    redirect_to redirect_path
  end

  # クリックした日付の売上詳細、もしくは売上追加フォームを表示する機能
  def score
    @searched_score = current_user.scores.find_by(start_time: params[:start_time])
    @score = Score.new
    render partial: "searched_score_field", locals: { start_time: params[:start_time], start_date: params[:start_date] }
  end

  # 日報ページに遷移するときに、選択した日付のScoreがなければ作成してから遷移する
  def check
    @score = current_user.scores.find_or_create_by(start_time: params[:start_time])
    redirect_to score_score_details_path(@score)
  end
end
