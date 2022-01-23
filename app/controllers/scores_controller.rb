class ScoresController < ApplicationController
  def index
    @scores = Score.all
  end

  def show
  end

  def new
    @score = Score.new
  end
end
