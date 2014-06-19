module BathroomHelper

  def self.trips
    BathroomVisit.count;
  end

  def self.today_trips
    BathroomVisit.count_trips_between(Time.day_start!,Time.day_end!)
  end

  def self.seven_day_trips
    BathroomVisit.count_trips_between(Time.day_start! - 6.days,Time.day_end!)
  end

  def self.thirty_day_trips
    BathroomVisit.count_trips_between(Time.day_start! - 29.days,Time.day_end!)
  end

  def self.seconds
    total = 0
    BathroomVisit.find_each{ |visit|
      total += visit.duration
    }
    total.to_i
  end

  def self.today_seconds
    trips = BathroomVisit.trips_between(Time.day_start!,Time.day_end!)
    self.get_seconds(trips)
  end

  def self.seven_day_seconds
    trips = BathroomVisit.trips_between(Time.day_start! - 6.days,Time.day_end!)
    self.get_seconds(trips)
  end

  def self.thirty_day_seconds
    trips = BathroomVisit.trips_between(Time.day_start! - 29.days,Time.day_end!)
    self.get_seconds(trips)
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
      result << [ Time.day_start(day).strftime("%A") , self.get_seconds(trips) ]
    end
    result.reverse
  end

end
