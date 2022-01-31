class ScoresController < ApplicationController
  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @scores = current_user.scores.all.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
    @scores_in_previous_month = if start_date.month == 1
                                  current_user.scores.all.where(start_time: "#{start_date.year - 1}-12-18"..."#{start_date.year}-01-16 23:59:59")
                                elsif start_date.month == 2
                                  current_user.scores.all.where(start_time: "#{start_date.year}-01-17"..."#{start_date.year}-02-15 23:59:59")
                                elsif start_date.month == 3
                                  current_user.scores.all.where(start_time: "#{start_date.year}-02-16"..."#{start_date.year}-03-17 23:59:59")
                                else
                                  current_user.scores.all.where(start_time: "#{start_date.year}-#{start_date.month - 1}-18"..."#{start_date.year}-#{start_date.month}-17 23:59:59")
                                end
    @scores_in_next_month = if start_date.month == 1
                              current_user.scores.all.where(start_time: "#{start_date.year}-01-17"..."#{start_date.year}-02-15 23:59:59")
                            elsif start_date.month == 2
                              current_user.scores.all.where(start_time: "#{start_date.year}-02-16"..."#{start_date.year}-03-17 23:59:59")
                            elsif start_date.month == 3
                              current_user.scores.all.where(start_time: "#{start_date.year}-03-18"..."#{start_date.year}-04-17 23:59:59")
                            else
                              current_user.scores.all.where(start_time: "#{start_date.year}-#{start_date.month}-18"..."#{start_date.year}-#{start_date.month + 1}-17 23:59:59")
                            end
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
