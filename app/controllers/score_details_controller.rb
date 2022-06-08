class ScoreDetailsController < ApplicationController
  protect_from_forgery
  before_action :set_score, only: [:index, :show, :destroy]
  
  def index
    @score_details = @score.score_details
    gon.score = @score
  end

  def create
    @score_detail = ScoreDetail.new(score_detail_params)
    if @score_detail.save!
      render json: @score_detail
    else
      redirect_to new_score_score_detail_path, warning: "失敗"
    end
  end

  def show
    @score_detail = @score.score_details.find(params[:id])
    gon.score_detail = @score_detail
    gon.translated_coordinates = @score_detail.translate_for_google_map
    gon.google_map_api_key = ENV['GOOGLE_MAP_API_KEY']
  end

  def destroy
    @score_detail = @score.score_details.find(params[:id])
    @score_detail.destroy!
  end

  private

  def set_score
    @score = Score.find(params[:score_id])
  end

  def score_detail_params
    params.require(:score_detail).permit(:pickup_address, :dropoff_address, :pickup_time, :dropoff_time, :fare, coords: []).merge(score_id: params[:score_id])
  end
end
