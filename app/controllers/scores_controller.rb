class ScoresController < ApplicationController
  before_action :set_score, only: [:edit, :update, :destroy]

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @scores = current_user.scores.get_scores_in_current_page(start_date)
    @scores_in_current_month = current_user.scores.get_scores_in_current_month(start_date)
  end

  def create
    @start_date = params[:start_date].to_date
    @scores_in_current_month = current_user.scores.get_scores_in_current_month(@start_date)
    @success_message = "売上を登録しました"
    @score = current_user.scores.build(score_params)
    @score.save
  end

  def edit
    @start_date = params[:start_date].to_date
  end

  def update
    @start_date = params[:start_date].to_date
    @scores_in_current_month = current_user.scores.get_scores_in_current_month(@start_date)
    @success_message = "売上を変更しました"
    @score.update(score_params)
  end

  def destroy
    @success_message = "売上を削除しました"
    @score.destroy!
  end

  private

  def score_params
    params.require(:score).permit(:score, :start_time, :memo)
  end

  def set_score
    @score = Score.find(params[:id])
  end
end
