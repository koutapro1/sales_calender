class Sale < ApplicationRecord
  belongs_to :user

  validates :sales, presence: true
  validates :date, presence: true
end
