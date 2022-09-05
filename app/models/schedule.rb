class Schedule < ApplicationRecord
  belongs_to :user

  enum shift: { every_other_day: 0, day: 1, night: 2 }

  validates :work_on, presence: true, uniqueness: { scope: :user_id }
  validates :shift,   presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 表示している月度の範囲
  def self.get_schedules_in_current_month(start_date)
    if start_date.between?(Date.new(start_date.year, 12, 18), Date.new(start_date.year, 12, 31))
      where(work_on: "#{start_date.year}-12-18".."#{start_date.year + 1}-01-16")
    elsif start_date.between?(Date.new(start_date.year, 1, 1), Date.new(start_date.year, 1, 16))
      where(work_on: "#{start_date.year - 1}-12-18".."#{start_date.year}-01-16")
    elsif start_date.between?(Date.new(start_date.year, 1, 17), Date.new(start_date.year, 2, 15))
      where(work_on: "#{start_date.year}-01-17".."#{start_date.year}-02-15")
    elsif start_date.between?(Date.new(start_date.year, 2, 16), Date.new(start_date.year, 3, 17))
      where(work_on: "#{start_date.year}-02-16".."#{start_date.year}-03-17")
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      where(work_on: "#{start_date.year}-#{start_date.month}-18".."#{start_date.year}-#{start_date.month + 1}-17")
    elsif start_date <= Date.new(start_date.year, start_date.month, 17)
      where(work_on: "#{start_date.year}-#{start_date.month - 1}-18".."#{start_date.year}-#{start_date.month}-17")
    end
  end

  # 表示している月度 + カレンダーに表示される月度外の範囲
  def self.get_schedules_in_current_page(start_date)
    if start_date.between?(Date.new(start_date.year, 12, 18), Date.new(start_date.year, 12, 31))
      where(work_on: Date.new(start_date.year, 12, 18).beginning_of_week.to_s..Date.new(start_date.year + 1, 1, 16).end_of_week.to_s)
    elsif start_date.between?(Date.new(start_date.year, 1, 1), Date.new(start_date.year, 1, 16))
      where(work_on: Date.new(start_date.year - 1, 12, 18).beginning_of_week.to_s..Date.new(start_date.year, 1, 16).end_of_week.to_s)
    elsif start_date.between?(Date.new(start_date.year, 1, 17), Date.new(start_date.year, 2, 15))
      where(work_on: Date.new(start_date.year, 1, 17).beginning_of_week.to_s..Date.new(start_date.year, 2, 15).end_of_week.to_s)
    elsif start_date.between?(Date.new(start_date.year, 2, 16), Date.new(start_date.year, 3, 17))
      where(work_on: Date.new(start_date.year, 2, 16).beginning_of_week.to_s..Date.new(start_date.year, 3, 17).end_of_week.to_s)
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      where(work_on: Date.new(start_date.year, start_date.month, 18).beginning_of_week.to_s..Date.new(start_date.year, start_date.month + 1, 17).end_of_week.to_s)
    elsif start_date <= Date.new(start_date.year, start_date.month, 17)
      where(work_on: Date.new(start_date.year, start_date.month - 1, 18).beginning_of_week.to_s..Date.new(start_date.year, start_date.month, 17).end_of_week.to_s)
    end
  end

  def self.get_unselected_schedule(schedule_params, schedules_in_current_month)
    dates_in_params = schedule_params.map { |s| s[:work_on].to_date }
    dates_in_db = schedules_in_current_month.map { |s| s[:work_on].to_date }
    unselected_dates = dates_in_db - dates_in_params
    where(work_on: unselected_dates)
  end
end
