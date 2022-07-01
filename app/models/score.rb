class Score < ApplicationRecord
  belongs_to :user
  has_many :score_details, dependent: :destroy

  validates :score, presence: true, length: { maximum: 6 }, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :start_time, presence: true, uniqueness: { scope: :user_id }
  validates :memo, length: { maximum: 300 }

  # 表示している月度の範囲
  def self.get_scores_in_current_month(start_date)
    if start_date.between?(Date.new(start_date.year, 12, 18), Date.new(start_date.year, 12, 31))
      self.where(start_time: "#{start_date.year}-12-18".."#{start_date.year + 1}-01-16")
    elsif start_date.between?(Date.new(start_date.year, 1, 1), Date.new(start_date.year, 1, 16))
      self.where(start_time: "#{start_date.year - 1}-12-18".."#{start_date.year}-01-16")
    elsif start_date.between?(Date.new(start_date.year, 1, 17), Date.new(start_date.year, 2, 15))
      self.where(start_time: "#{start_date.year}-01-17".."#{start_date.year}-02-15")
    elsif start_date.between?(Date.new(start_date.year, 2, 16), Date.new(start_date.year, 3, 17))
      self.where(start_time: "#{start_date.year}-02-16".."#{start_date.year}-03-17")
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      self.where(start_time: "#{start_date.year}-#{start_date.month}-18".."#{start_date.year}-#{start_date.month + 1}-17")
    elsif start_date <= Date.new(start_date.year, start_date.month, 17)
      self.where(start_time: "#{start_date.year}-#{start_date.month - 1}-18".."#{start_date.year}-#{start_date.month}-17")
    end
  end

  # 表示している月度 + カレンダーに表示される月度外の範囲
  def self.get_scores_in_current_page(start_date)
    if start_date.between?(Date.new(start_date.year, 12, 18), Date.new(start_date.year, 12, 31))
      self.where(start_time: Date.new(start_date.year, 12, 18).beginning_of_week.to_s..Date.new(start_date.year + 1, 1, 16).end_of_week.to_s).includes(:score_details)
    elsif start_date.between?(Date.new(start_date.year, 1, 1), Date.new(start_date.year, 1, 16))
      self.where(start_time: Date.new(start_date.year - 1, 12, 18).beginning_of_week.to_s..Date.new(start_date.year, 1, 16).end_of_week.to_s).includes(:score_details)
    elsif start_date.between?(Date.new(start_date.year, 1, 17), Date.new(start_date.year, 2, 15))
      self.where(start_time: Date.new(start_date.year, 1, 17).beginning_of_week.to_s..Date.new(start_date.year, 2, 15).end_of_week.to_s).includes(:score_details)
    elsif start_date.between?(Date.new(start_date.year, 2, 16), Date.new(start_date.year, 3, 17))
      self.where(start_time: Date.new(start_date.year, 2, 16).beginning_of_week.to_s..Date.new(start_date.year, 3, 17).end_of_week.to_s).includes(:score_details)
    elsif start_date >= Date.new(start_date.year, start_date.month, 18)
      self.where(start_time: Date.new(start_date.year, start_date.month, 18).beginning_of_week.to_s..Date.new(start_date.year, start_date.month + 1, 17).end_of_week.to_s).includes(:score_details)
    elsif start_date <= Date.new(start_date.year, start_date.month, 17)
      self.where(start_time: Date.new(start_date.year, start_date.month - 1, 18).beginning_of_week.to_s..Date.new(start_date.year, start_date.month, 17).end_of_week.to_s).includes(:score_details)
    end
  end
end
