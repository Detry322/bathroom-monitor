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

  def deactivate
    self.active = false
    self.save
  end

  def update_end_time
    self.end_time = Time.now
    self.save
  end

end
