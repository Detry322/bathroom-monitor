class Time
  def self.day_start(days_ago)
    Date.today.prev_day(days_ago).to_time
  end
  def self.day_end(days_ago)
    Time.day_start(days_ago) + 24.hours
  end
  def self.day_start!
    self.day_start(0)
  end
  def self.day_end!
    self.day_end(0)
  end
end
