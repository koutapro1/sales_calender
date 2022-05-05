class Scores::SearchesController < ApplicationController
  # 月度ジャンプ機能
  def index
    redirect_path = %Q[#{root_path}?start_date=#{params["selected_month(1i)"]}-#{params["selected_month(2i)"]}-#{params["selected_month(3i)"]}]
    redirect_to redirect_path
  end

  # クリックした日付の売上詳細、もしくは売上追加フォームを表示する機能
  def score
    start_time = params.fetch(:start_time).to_date
    @searched_score = Score.find_by(start_time: params[:start_time], user: current_user)
    @score = Score.new
    render partial: "searched_score_field", locals: { start_time: start_time }
  end

  # 日報ページに遷移するときに、選択した日付のScoreがなければ作成してから遷移する
  def check
    @score = Score.find_by(start_time: params[:start_time], user: current_user)
    if @score.present?
      redirect_to score_score_details_path(@score), success: "あった"
    else
      @score = Score.create!(start_time: params[:start_time], user: current_user)
      redirect_to score_score_details_path(@score), warning: "なかった"
    end
  end
end