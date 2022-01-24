class Score < ApplicationRecord
  belongs_to :user

  validates :score, presence: true
  validates :date, presence: true
end
