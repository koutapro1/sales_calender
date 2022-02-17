class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :destroy]

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @scores = current_user.scores.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
    @scores_in_previous_month = Score.get_scores_in_previous_month(start_date, current_user)
    @scores_in_next_month = Score.get_scores_in_next_month(start_date, current_user)
  end

  def show; end

  def new
    @score = Score.new
  end

  def create
    @score = Score.new(score_params)
    if @score.save
      redirect_to scores_path, success: '売上を登録しました'
    else
      flash.now[:warning] = '売上を登録できませんでした'
      render :new
    end
  end

  def destroy
    @score.destroy!
    redirect_to scores_path, success: '売上を削除しました'
  end

  private

  def score_params
    params.require(:score).permit(:score, :start_time, :memo).merge(user_id: current_user.id)
  end

  def set_score
    @score = Score.find(params[:id])
  end
end
