class Sale < ApplicationRecord

  validates :sales, presence: true
  validates :date, presence: true
end
