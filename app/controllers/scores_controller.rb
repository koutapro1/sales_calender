class ScoresController < ApplicationController
  def index
    @scores = current_user.scores.all

    start_date = params.fetch(:start_date, Date.today).to_date
    @meetings = Score.where(starts_at: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def show
    @score = Score.find(params[:id])
  end

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

  private

  def score_params
    params.require(:score).permit(:score, :start_time, :memo).merge(user_id: current_user.id)
  end
end
