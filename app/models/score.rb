class Score < ApplicationRecord
  belongs_to :user

  validates :score, presence: true
  validates :start_time, presence: true
end
