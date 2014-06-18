class BathroomVisit < ActiveRecord::Base

  def self.create_session
    BathroomVisit.create(start_time: Time.now, end_time: Time.now, active: true);
  end

  def self.in_use?
    BathroomVisit.last.active?
  end

  def activate
    self.active = true
    self.save
  end

  def self.count_trips_between(start_time,end_time)
    BathroomVisit.where("start_time >= ? AND end_time <= ?", start_time, end_time).count
  end

  def self.total_today
    count_trips_between(Date.today.to_time,Date.today.to_time + 24.hours)
  end

  def self.total_seven_day
    count_trips_between(Time.now - 7.days,Date.today.to_time + 24.hours)
  end

  def self.total_thirty_day
    count_trips_between(Time.now - 30.days,Date.today.to_time + 24.hours)
  end

  def deactivate
    self.active = false
    self.save
  end

  def update_end_time
    self.end_time = Time.now
    self.save
  end

end
