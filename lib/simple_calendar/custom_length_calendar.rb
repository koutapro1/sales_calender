class SimpleCalendar::CustomLengthCalendar < SimpleCalendar::Calendar
  private

  def date_range
    if start_date >= Date.new(start_date.year, 12, 18) && start_date <= Date.new(start_date.year, 12, 31)
      (Date.new(start_date.year, 12, 18).beginning_of_week..Date.new(start_date.year + 1, 1, 16).end_of_week).to_a
    elsif start_date >= Date.new(start_date.year, 1, 1) && start_date <= Date.new(start_date.year, 1, 16)
      (Date.new(start_date.year - 1, 12, 18).beginning_of_week..Date.new(start_date.year, 1, 16).end_of_week).to_a
    elsif start_date >= Date.new(start_date.year, 1, 17) && start_date <= Date.new(start_date.year, 2, 15)
      (Date.new(start_date.year, 1, 17).beginning_of_week..Date.new(start_date.year, 2, 15).end_of_week).to_a
    elsif start_date >= Date.new(start_date.year, 2, 16) && start_date <= Date.new(start_date.year, 3, 17)
      (Date.new(start_date.year, 2, 16).beginning_of_week..Date.new(start_date.year, 3, 17).end_of_week).to_a
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      (Date.new(start_date.year, start_date.month, 18).beginning_of_week..Date.new(start_date.year, start_date.month + 1, 17).end_of_week).to_a
    elsif start_date <= Date.new(start_date.year, start_date.month, 18)
      (Date.new(start_date.year, start_date.month - 1, 18).beginning_of_week..Date.new(start_date.year, start_date.month, 17).end_of_week).to_a
    end
  end
end
