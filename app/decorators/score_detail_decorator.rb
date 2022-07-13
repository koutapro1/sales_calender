class ScoreDetailDecorator < ApplicationDecorator
  delegate_all

  def pickup_time_long
    object.pickup_time.strftime('%-H時%-M分%-S秒')
  end

  def dropoff_time_long
    object.dropoff_time.strftime('%-H時%-M分%-S秒')
  end

  def pickup_time_short
    object.pickup_time.strftime('%H:%M')
  end

  def dropoff_time_short
    object.dropoff_time.strftime('%H:%M')
  end
end
