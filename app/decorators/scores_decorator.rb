class ScoresDecorator < Draper::CollectionDecorator
  def calc_total_score
    object.sum { |hash| hash[:score] }
  end

  def calc_average_score
    object.sum { |hash| hash[:score] } / object.size
  rescue ZeroDivisionError
    0
  end
end
