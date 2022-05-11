class ScoreDetail < ApplicationRecord
  belongs_to :score
  serialize :coords, Array

  def translate_for_google_map
    coords = self.coords
    coords = coords.each_slice(2).to_a
    result = coords.map { |coord| coord.join(",") }
    result.join("|")
  end
end
