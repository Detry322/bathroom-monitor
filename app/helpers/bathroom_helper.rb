module BathroomHelper

  def self.total
    BathroomVisit.count;
  end

  def self.total_today
    BathroomVisit.count_trips_between(Date.today.to_time,Date.today.to_time + 24.hours)
  end

  def self.total_seven_day
    BathroomVisit.count_trips_between(Time.now - 7.days,Date.today.to_time + 24.hours)
  end

  def self.total_thirty_day
    BathroomVisit.count_trips_between(Time.now - 30.days,Date.today.to_time + 24.hours)
  end

end
