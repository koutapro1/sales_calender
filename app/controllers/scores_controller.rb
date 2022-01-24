class ScoresController < ApplicationController
  def index
    @scores = Score.all
  end

  def show
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
    params.require(:score).permit(:score, :date, :memo).merge(user_id: current_user.id)
  end
end
