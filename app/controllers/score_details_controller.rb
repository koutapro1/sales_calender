class ScoreDetailsController < ApplicationController
  protect_from_forgery
  before_action :set_score, only: %i[index show edit update destroy]
  before_action :set_score_detail, only: %i[show edit destroy]

  def index
    @score_details = @score.score_details.decorate
    gon.score = @score
  end

  def create
    @score_detail = ScoreDetail.new(score_detail_params)
    if @score_detail.save!
      render partial: 'score_detail', locals: { score_detail: @score_detail.decorate }
    else
      redirect_to new_score_score_detail_path, warning: '失敗'
    end
  end

  def show
    @score_detail = @score_detail.decorate
    gon.score_detail = @score_detail
    gon.translated_coordinates = @score_detail.translate_for_google_map
    gon.google_map_api_key = ENV.fetch('GOOGLE_MAP_API_KEY')
  end

  def edit; end

  def update
    @score_detail = @score.score_details.find(params[:id]).decorate
    @score_detail.update(score_detail_params)
  end

  def destroy
    @score_detail.destroy!
  end

  private

  def set_score
    @score = current_user.scores.find(params[:score_id])
  end

  def set_score_detail
    @score_detail = @score.score_details.find(params[:id])
  end

  def score_detail_params
    params.require(:score_detail).permit(:pickup_address,
                                         :dropoff_address,
                                         :pickup_time,
                                         :dropoff_time,
                                         :fare,
                                         coords: []).merge(score_id: params[:score_id])
  end
end
