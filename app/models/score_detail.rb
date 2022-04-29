class ScoreDetail < ApplicationRecord
  belongs_to :score
  serialize :coords, Array
end
