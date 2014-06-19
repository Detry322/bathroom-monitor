class Concierge

  scope :trips_between, -> (start_time,end_time) {
    BathroomVisit.where("start_time >= ? AND start_time <= ?", start_time, end_time)
  }

  def self.count_trips_between (start_time, end_time)
    Concierge.trips_between(start_time,end_time).count
  end

  def self.total_trips
    BathroomVisit.count;
  end

  def self.today_trips
    Concierge.count_trips_between(Time.day_start!,Time.day_end!)
  end

  def self.seven_day_trips
    Concierge.count_trips_between(Time.day_start! - 6.days,Time.day_end!)
  end

  def self.thirty_day_trips
    Concierge.count_trips_between(Time.day_start! - 29.days,Time.day_end!)
  end

  def self.total_seconds
    total = 0
    BathroomVisit.find_each{ |visit|
      total += visit.duration
    }
    total.to_i
  end

  def self.today_seconds
    trips = BathroomVisit.trips_between(Time.day_start!,Time.day_end!)
    Concierge.get_seconds(trips)
  end

  def self.seven_day_seconds
    trips = BathroomVisit.trips_between(Time.day_start! - 6.days,Time.day_end!)
    Concierge.get_seconds(trips)
  end

  def self.thirty_day_seconds
    trips = BathroomVisit.trips_between(Time.day_start! - 29.days,Time.day_end!)
    Concierge.get_seconds(trips)
  end

  def self.get_seconds(trips)
    trips.map{|user| user.duration}.inject(:+).to_i
  end

  def self.seven_day_report_trips
    result = []
    7.times do |day|
      times = BathroomVisit.count_trips_between(Time.day_start(day),Time.day_end(day))
      result << [ Time.day_start(day).strftime("%A") , times ]
    end
    result.reverse
  end

  def self.seven_day_report_seconds
    result = []
    7.times do |day|
      trips = BathroomVisit.trips_between(Time.day_start(day),Time.day_end(day))
      result << [ Time.day_start(day).strftime("%A") , get_seconds(trips) ]
    end
    result.reverse
  end

  def self.occupied?
    BathroomVisit.last.active?
  end

  def self.create_session
    BathroomVisit.create(start_time: Time.now, end_time: Time.now, active: true);
  end

end
