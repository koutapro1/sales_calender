module ScoresHelper
  def set_classes_for(day, start_date, sorted_events, date_range)
    dates_in_this_month = case date_range.last.month
                          when 1
                            (Date.new(date_range.first.year, 12, 18)..Date.new(date_range.last.year, 1, 16)).to_a
                          when 2
                            (Date.new(start_date.year, 1, 17)..Date.new(start_date.year, 2, 15)).to_a
                          when 3
                            (Date.new(start_date.year, 2, 16)..Date.new(start_date.year, 3, 17)).to_a
                          else
                            (Date.new(date_range.first.year, date_range.first.month, 18)..Date.new(date_range.first.year, date_range.last.month, 17)).to_a
                          end

    today = Date.current
    events = sorted_events.fetch(day, [])

    td_class = ['day']
    td_class << day.to_date
    td_class << "wday-#{day.wday}"
    td_class << 'today' if today == day
    td_class << 'past' if today > day
    td_class << 'future' if today < day
    td_class << 'start-date' if day.to_date == start_date.to_date
    td_class << 'prev-month' if dates_in_this_month.exclude?(day) && day < dates_in_this_month.first
    td_class << 'next-month' if dates_in_this_month.exclude?(day) && day > dates_in_this_month.last
    td_class << 'current-month' if dates_in_this_month.include?(day)
    events.each do |event|
      td_class << 'has-score-detail' if event.is_a?(Score) && event.score_details.present?
      td_class << 'has-schedule' if event.is_a?(Schedule)
    end
    td_class << 'start-date' if day.to_date == start_date.to_date

    td_class
  end
end
