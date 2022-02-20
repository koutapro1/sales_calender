class Score < ApplicationRecord
  belongs_to :user

  validates :score, presence: true
  validates :start_time, presence: true

  def self.get_scores_in_current_month(start_date, current_user)
    if start_date >= Date.new(start_date.year, 12, 18) && start_date <= Date.new(start_date.year, 12, 31)
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-12-18".."#{start_date.year + 1}-01-16")
    elsif start_date >= Date.new(start_date.year, 1, 1) && start_date <= Date.new(start_date.year, 1, 16)
      self.where(user_id: current_user.id, start_time: "#{start_date.year - 1}-12-18".."#{start_date.year}-01-16")
    elsif start_date >= Date.new(start_date.year, 1, 17) && start_date <= Date.new(start_date.year, 2, 15)
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-01-17".."#{start_date.year}-02-15")
    elsif start_date >= Date.new(start_date.year, 2, 16) && start_date <= Date.new(start_date.year, 3, 17)
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-02-16".."#{start_date.year}-03-17")
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-#{start_date.month}-18".."#{start_date.year}-#{start_date.month + 1}-17")
    elsif start_date <= Date.new(start_date.year, start_date.month, 18)
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-#{start_date.month - 1}-18".."#{start_date.year}-#{start_date.month}-17")
    end
  end

  def self.get_scores_in_current_page(start_date, current_user)
    if start_date >= Date.new(start_date.year, 12, 18) && start_date <= Date.new(start_date.year, 12, 31)
      self.where(user_id: current_user.id, start_time: "#{Date.new(start_date.year, 12, 18).beginning_of_week}".."#{Date.new(start_date.year + 1, 1, 16).end_of_week}")
    elsif start_date >= Date.new(start_date.year, 1, 1) && start_date <= Date.new(start_date.year, 1, 16)
      self.where(user_id: current_user.id, start_time: "#{Date.new(start_date.year - 1, 12, 18).beginning_of_week}".."#{Date.new(start_date.year, 1, 16).end_of_week}")
    elsif start_date >= Date.new(start_date.year, 1, 17) && start_date <= Date.new(start_date.year, 2, 15)
      self.where(user_id: current_user.id, start_time: "#{Date.new(start_date.year, 1, 17).beginning_of_week}".."#{Date.new(start_date.year, 2, 15).end_of_week}")
    elsif start_date >= Date.new(start_date.year, 2, 16) && start_date <= Date.new(start_date.year, 3, 17)
      self.where(user_id: current_user.id, start_time: "#{Date.new(start_date.year, 2, 16).beginning_of_week}".."#{Date.new(start_date.year, 3, 17).end_of_week}")
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      self.where(user_id: current_user.id, start_time: "#{Date.new(start_date.year, start_date.month, 18).beginning_of_week}".."#{Date.new(start_date.year, start_date.month + 1, 17).end_of_week}")
    elsif start_date <= Date.new(start_date.year, start_date.month, 18)
      self.where(user_id: current_user.id, start_time: "#{Date.new(start_date.year, start_date.month - 1, 18).beginning_of_week}".."#{Date.new(start_date.year, start_date.month, 17).end_of_week}")
    end
  end
end