class Score < ApplicationRecord
  belongs_to :user

  validates :score, presence: true
  validates :start_time, presence: true

  def self.get_scores_in_previous_month(start_date, current_user)
    if start_date.month == 1
      self.where(user_id: current_user.id, start_time: "#{start_date.year - 1}-12-18"..."#{start_date.year}-01-16 23:59:59")
    elsif start_date.month == 2
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-01-17"..."#{start_date.year}-02-15 23:59:59")
    elsif start_date.month == 3
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-02-16"..."#{start_date.year}-03-17 23:59:59")
    else
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-#{start_date.month - 1}-18"..."#{start_date.year}-#{start_date.month}-17 23:59:59")
    end
  end

  def self.get_scores_in_next_month(start_date, current_user)
    if start_date.month == 1
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-01-17"..."#{start_date.year}-02-15 23:59:59")
    elsif start_date.month == 2
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-02-16"..."#{start_date.year}-03-17 23:59:59")
    elsif start_date.month == 3
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-03-18"..."#{start_date.year}-04-17 23:59:59")
    else
      self.where(user_id: current_user.id, start_time: "#{start_date.year}-#{start_date.month}-18"..."#{start_date.year}-#{start_date.month + 1}-17 23:59:59")
    end
  end
end
