require 'rails_helper'

describe BathroomVisit do

  it 'should correctly say if it is active' do
    x = BathroomVisit.create(start_time: Time.now, end_time: nil)
    expect(x.active?).to eq true
    x.end_time = Time.now
    x.save
    expect(x.active?).to eq false
  end

  it 'should correctly return its duration' do
    now = Time.now
    x = BathroomVisit.create(start_time: now - 3.minutes, end_time: now - 2.minutes)
    expect(x.duration).to eq 60.0
    y = BathroomVisit.create(start_time: now - 1.minute, end_time: nil)
    expect(y.duration).to be >= 60.0
  end

  it 'should correctly update its own end time' do
    x = BathroomVisit.create(start_time: Time.now, end_time: nil)
    expect(x.end_time).to eq nil
    x.update_end_time
    expect(x.end_time).to be_truthy
  end

end
