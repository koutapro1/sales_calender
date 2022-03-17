class Scores::SearchesController < ApplicationController
  def index
    redirect_path = %Q[#{root_path}?start_date="#{params["selected_month(1i)"]}-#{params["selected_month(2i)"]}-#{params["selected_month(3i)"]}"]
    redirect_to redirect_path
    # byebug
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