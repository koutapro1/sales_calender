class ScoreDetailsController < ApplicationController
  before_action :set_score, only: [:index, :show]
  
  def index
    @score_details = @score.score_details
  end

  def create
    @score_detail = ScoreDetail.new(params_to_time_with_zone(score_detail_params))
    if @score_detail.save!
      render json: @score_detail
    else
      redirect_to new_score_score_detail_path, warning: "失敗"
    end
  end

  def show
    @score_detail = @score.score_details.find(params[:id])
  end

  private

  def set_score
    @score = Score.find(params[:score_id])
  end

  def score_detail_params
    params.require(:score_detail).permit(:pickup_address, :dropoff_address, :pickup_time, :dropoff_time, coords: []).merge(score_id: params[:score_id])
  end

  # String型になっているUnixtimeをTimeWithZoneオブジェクトに変換する
  def params_to_time_with_zone(model_params)
    model_params.each do |key,value|
      if unixtime_string?(value)
        string = value.to_i
        model_params[key]=Time.at(string)
      end
    end
  end
end
