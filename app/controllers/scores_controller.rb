class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :destroy]

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @scores = Score.get_scores_in_current_page(start_date, current_user)
    @scores_in_current_month = Score.get_scores_in_current_month(start_date, current_user)
  end

  def create
    @success_message = "売上を登録しました。"
    @score = current_user.scores.build(score_params)
    @score.save
  end

  def destroy
    @score.destroy!
    redirect_back fallback_location: scores_path, success: '売上を削除しました'
  end

  private

  def score_params
    params.require(:score).permit(:score, :start_time, :memo)
  end

  def set_score
    @score = Score.find(params[:id])
  end
end
