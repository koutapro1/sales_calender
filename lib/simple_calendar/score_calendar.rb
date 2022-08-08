class SimpleCalendar::ScoreCalendar < SimpleCalendar::Calendar
  private

  def date_range
    if start_date.between?(Date.new(start_date.year, 12, 18), Date.new(start_date.year, 12, 31))
      (Date.new(start_date.year, 12, 18).beginning_of_week..Date.new(start_date.year + 1, 1, 16).end_of_week).to_a
    elsif start_date.between?(Date.new(start_date.year, 1, 1), Date.new(start_date.year, 1, 16))
      (Date.new(start_date.year - 1, 12, 18).beginning_of_week..Date.new(start_date.year, 1, 16).end_of_week).to_a
    elsif start_date.between?(Date.new(start_date.year, 1, 17), Date.new(start_date.year, 2, 15))
      (Date.new(start_date.year, 1, 17).beginning_of_week..Date.new(start_date.year, 2, 15).end_of_week).to_a
    elsif start_date.between?(Date.new(start_date.year, 2, 16), Date.new(start_date.year, 3, 17))
      (Date.new(start_date.year, 2, 16).beginning_of_week..Date.new(start_date.year, 3, 17).end_of_week).to_a
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      (Date.new(start_date.year, start_date.month, 18).beginning_of_week..Date.new(start_date.year, start_date.month + 1, 17).end_of_week).to_a
    elsif start_date <= Date.new(start_date.year, start_date.month, 18)
      (Date.new(start_date.year, start_date.month - 1, 18).beginning_of_week..Date.new(start_date.year, start_date.month, 17).end_of_week).to_a
    end
  end

  def second_attribute
    options.fetch(:second_attribute, :start_time).to_sym
  end

  def sorted_events
    @sorted_events ||= begin
      events = options.fetch(:events, []).reject { |e| e.send(attribute).nil? }.sort_by(&attribute)
      second_events = options.fetch(:second_events, []).reject { |e| e.send(second_attribute).nil? }.sort_by(&second_attribute)
      group_events = group_events_by_date(events)
      second_group_events = group_second_events_by_date(second_events)
      group_events.merge(second_group_events){|key, v1, v2| v1 + v2}
    end
  end

  def group_events_by_date(events)
    events_grouped_by_date = Hash.new { |h, k| h[k] = [] }

    events.each do |event|
      event_start_date = event.send(attribute).to_date
      event_end_date = event.respond_to?(end_attribute) && !event.send(end_attribute).nil? ? event.send(end_attribute).to_date : event_start_date
      (event_start_date..event_end_date.to_date).each do |enumerated_date|
        events_grouped_by_date[enumerated_date] << event
      end
    end

    events_grouped_by_date
  end

  def group_second_events_by_date(events)
    events_grouped_by_date = Hash.new { |h, k| h[k] = [] }

    events.each do |event|
      event_start_date = event.send(second_attribute).to_date
      event_end_date = event.respond_to?(end_attribute) && !event.send(end_attribute).nil? ? event.send(end_attribute).to_date : event_start_date
      (event_start_date..event_end_date.to_date).each do |enumerated_date|
        events_grouped_by_date[enumerated_date] << event
      end
    end

    events_grouped_by_date
  end
end
