class SchedulesController < ApplicationController
  def new
    start_date = params.fetch(:start_date, Time.zone.today).to_date
    @schedules = current_user.schedules.get_schedules_in_current_page(start_date)
    @scores_in_current_month = current_user.schedules.get_schedules_in_current_month(start_date)
    gon.schedules = @schedules
  end

  def create
  end
end
