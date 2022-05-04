class Scores::SearchesController < ApplicationController
  include SearchesHelper

  def index
    redirect_path = %Q[#{root_path}?start_date=#{params["selected_month(1i)"]}-#{params["selected_month(2i)"]}-#{params["selected_month(3i)"]}]
    redirect_to redirect_path
  end

  def score
    start_date = params.fetch(:start_date, Date.today).to_date
    date = convert_slash_into_hyphen(params[:date])
    @searched_score = Score.get_searched_score_in_current_page(date, start_date, current_user)
    @score = Score.new
    render partial: "searched_score_field", locals: { start_date: start_date, date: date }
  end

  def check
    date = (check_start_date_year(params[:start_date], params[:date]).to_s + "-" + convert_slash_into_hyphen(params[:date]))
    @score = Score.find_by(start_time: date, user: current_user)
    if @score.present?
      redirect_to score_score_details_path(@score), success: "あった"
    else
      @score = Score.create(start_time: date, user: current_user)
      redirect_to score_score_details_path(@score), warning: "なかった"
    end
  end
end