class SchedulesController < ApplicationController
  def new
    @start_date = params.fetch(:start_date, Time.zone.today).to_date
    @schedules = current_user.schedules.get_schedules_in_current_month(@start_date).decorate
    gon.schedules = @schedules
  end

  def create
    schedule_params = params.fetch(:schedules, []).map{ |schedule| schedule.merge(user_id: current_user.id, created_at: Time.current, updated_at: Time.current) }
    schedules_in_current_month = current_user.schedules.get_schedules_in_current_month(params[:start_date].to_date)
    unselected_dates = current_user.schedules.get_unselected_schedule(schedule_params, schedules_in_current_month)
    unselected_dates.destroy_all
    unless schedule_params.empty?
      Schedule.upsert_all(schedule_params, unique_by: :index_schedules_on_work_on_and_user_id)
    end
    redirect_to new_schedule_path
  end
end
