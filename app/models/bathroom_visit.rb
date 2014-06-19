class BathroomVisit < ActiveRecord::Base

  def active?
    self.end_time.nil?
  end

  def update_end_time
    self.end_time = Time.now
    self.save
  end

  def duration
    end_time = (self.end_time.nil?) ? Time.now : self.end_time
    end_time-self.start_time
  end

end
