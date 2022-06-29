class ScoreDetail < ApplicationRecord
  belongs_to :score

  validates :coords,          presence: true
  validates :pickup_time,     presence: true
  validates :dropoff_time,    presence: true
  validates :pickup_address,  presence: true
  validates :dropoff_address, presence: true
  validates :fare,            presence: true, length: { maximum: 6 }, numericality: { only_integer: true, greater_than_or_equal_to: 420 }

  def translate_for_google_map
    coords = self.coords
    coords = coords.each_slice(2).to_a
    result = coords.map { |coord| coord.join(",") }
    result.join("|")
  end
end
