class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :destroy]

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @scores = Score.get_scores_in_current_page(start_date, current_user)
    @scores_in_current_month = Score.get_scores_in_current_month(start_date, current_user)
  end

  def create
    @score = Score.new(score_params)
    if @score.save
      redirect_back fallback_location: scores_path, success: '売上を登録しました'
    else
      redirect_back fallback_location: scores_path, warning: '売上を登録できませんでした'
    end
  end

  def destroy
    @score.destroy!
    redirect_back fallback_location: scores_path, success: '売上を削除しました'
  end

  private

  def score_params
    params.require(:score).permit(:score, :start_time, :memo).merge(user_id: current_user.id)
  end

  def set_score
    @score = Score.find(params[:id])
  end
end
