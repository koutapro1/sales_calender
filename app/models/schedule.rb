class Schedule < ApplicationRecord
  belongs_to :user

  enum shift: { every_other_day: 0, day: 1, night: 2 }

  validates :work_on, presence: true, uniqueness: { scope: :user_id }
  validates :shift,   presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
