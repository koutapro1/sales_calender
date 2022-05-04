module SearchesHelper

  # dataの/を-に変換
  def convert_slash_into_hyphen(object)
    object.sub(/\//, '-')
  end


  def check_start_date_year(start_date, date)
    start_date = start_date.to_date
    if start_date >= Date.new(start_date.year, 12, 18) && start_date <= Date.new(start_date.year, 12, 31) && date.include?("12/")
      return start_date.year
    elsif start_date >= Date.new(start_date.year, 12, 18) && start_date <= Date.new(start_date.year, 12, 31) && date.include?("1-")
      return start_date.year + 1
    elsif start_date >= Date.new(start_date.year, 1, 1) && start_date <= Date.new(start_date.year, 1, 16) && date.include?("12-")
      return start_date.year - 1
    elsif start_date >= Date.new(start_date.year, 1, 1) && start_date <= Date.new(start_date.year, 1, 16) && date.include?("1-")
      return start_date.year
    else
      return start_date.year
    end
  end
end
