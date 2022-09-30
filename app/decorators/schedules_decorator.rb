class SchedulesDecorator < Draper::CollectionDecorator
  def count_work_days
    work_days = 0
    object.each do |s|
      if Schedule.shifts[s.shift] == 0
        work_days += 1
      else
        work_days += 0.5
      end
    end
    return work_days
  end
end
