require 'rails_helper'

describe Concierge do

  before do
    now = Time.now

    visit1_start = now - (40.days + 1.hours)
    visit1_end = now - (40.days)

    visit2_start = now - (25.days + 1.hours)
    visit2_end = now - (25.days)

    visit3_start = now - (5.days + 1.hours)
    visit3_end = now - (5.days)

    visit4_start = now - (1.hours)
    visit4_end = now - (50.minutes)

    visit5_start = now - (45.minutes)
    visit5_end = now - 40.minutes

    visit6_start = now - 30.minutes
    visit6_end = now - 29.minutes

    BathroomVisit.create(start_time: visit1_start, end_time: visit1_end);
    BathroomVisit.create(start_time: visit2_start, end_time: visit2_end);
    BathroomVisit.create(start_time: visit3_start, end_time: visit3_end);
    BathroomVisit.create(start_time: visit4_start, end_time: visit4_end);
    BathroomVisit.create(start_time: visit5_start, end_time: visit5_end);
    BathroomVisit.create(start_time: visit6_start, end_time: visit6_end);
  end

  it 'should get the trips between two times' do
    x = Concierge.trips_between(Date.today.to_time,Time.now)
    y = Concierge.trips_between(Time.day_start(6),Time.now - 47.minutes)
    expect(x.count).to eq 3
    expect(y.count).to eq 2
  end

  it 'should count the trips between two times' do
    x = Concierge.count_trips_between(Date.today.to_time,Time.now)
    y = Concierge.count_trips_between(Time.day_start(6),Time.now - 47.minutes)
    expect(x).to eq 3
    expect(y).to eq 2
  end

  it 'should count the total number of trips' do
    expect(Concierge.total_trips).to eq 6
  end

  it 'should count the number of trips today' do
    expect(Concierge.today_trips).to eq 3
  end

  it 'should count the number of trips in the past 7 days' do
    expect(Concierge.seven_day_trips).to eq 4
  end

  it 'should count the number of trips in the past 30 days' do
    expect(Concierge.thirty_day_trips).to eq 5
  end

  it 'should get the total number of seconds' do
    expect(Concierge.total_seconds).to eq 11760
  end

  it 'should get the number of seconds today' do
    expect(Concierge.today_seconds).to eq 960
  end

  it 'should get the number of seconds in the past 7 days' do
    expect(Concierge.seven_day_seconds).to eq 4560
  end

  it 'should get the number of seconds in the past 30 days' do
    expect(Concierge.thirty_day_seconds).to eq 8160
  end

  it 'should generate a report of trips for the past seven days' do
    x = Concierge.seven_day_report_trips
    expect(x.count).to eq 7
    expect(x[6][1]).to eq 3
    expect(x[6][0]).to eq Time.now.strftime("%A")
  end

  it 'should generate a report of seconds for the past seven days' do
    x = Concierge.seven_day_report_seconds
    expect(x.count).to eq 7
    expect(x[6][1]).to eq 960
    expect(x[6][0]).to eq Time.now.strftime("%A")
  end

  it 'should correctly say if the bathroom is occupied' do
    BathroomVisit.create(start_time: Time.now, end_time: nil)
    expect(Concierge.occupied?).to eq true
    x = BathroomVisit.last
    x.end_time = Time.now
    x.save
    expect(Concierge.occupied?).to eq false
  end

  it 'should properly create an active BathroomVisit' do
    Concierge.create_session
    expect(BathroomVisit.last.end_time).to eq nil
    BathroomVisit.last.end_time = Time.now;
    BathroomVisit.last.save
  end


end
