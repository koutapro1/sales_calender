class Scores::SearchesController < ApplicationController
  def index
  end

  def score
    start_date = params.fetch(:start_date, Date.today).to_date
    date = params[:date].sub(/\//, '-')
    @searched_score = Score.get_searched_score_in_current_page(date, start_date, current_user)
    respond_to do |format|
      format.json { render json: @searched_score }
    end
  end
end