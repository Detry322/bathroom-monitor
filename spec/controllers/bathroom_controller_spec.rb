require 'rails_helper'

RSpec.describe BathroomController, :type => :controller do

  describe "GET index" do

    render_views

    before :each do
      BathroomVisit.create(start_time: Time.now,end_time: nil)
    end

    it 'should return HTTP 200 OK status' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'should say Vacant if vacant' do
      BathroomVisit.last.update_end_time
      get :index
      expect(response.body).to match(/VACANT/)
    end

    it 'should say in use if occupied' do
      get :index
      expect(response.body).to match(/IN USE/)
    end

  end

  describe "GET statistics" do

    render_views

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

    it 'should display total number of visits today' do
      get :statistics
      expect(response.body).to match(/<strong>3<\/strong>/)
    end

    it 'should display total number of visits in the past seven days' do
      get :statistics
      expect(response.body).to match(/<strong>4<\/strong>/)
    end

    it 'should display total number of visits in the past thirty days' do
      get :statistics
      expect(response.body).to match(/<strong>5<\/strong>/)
    end

    it 'should display total number of visits' do
      get :statistics
      expect(response.body).to match(/<strong>6<\/strong>/)
    end

    it 'should display total number of minutes today' do
      get :statistics
      expect(response.body).to match(/<strong>16<\/strong>/)
    end

    it 'should display total number of minutes in the past seven days' do
      get :statistics
      expect(response.body).to match(/<strong>76<\/strong>/)
    end

    it 'should display total number of hours in the past thirty days' do
      get :statistics
      expect(response.body).to match(/<strong>2.27<\/strong>/)
    end

    it 'should display total number of hours' do
      get :statistics
      expect(response.body).to match(/<strong>3.27<\/strong>/)
    end

  end
  describe "GET update" do
    render_views

    it 'should say Vacant if vacant' do
      BathroomVisit.create(start_time: Time.now,end_time: nil).update_end_time
      get :update_browser
      expect(response.body).to match(/vacant/)
    end

    it 'should say occupied if occupied' do
      BathroomVisit.create(start_time: Time.now,end_time: nil)
      get :update_browser
      expect(response.body).to match(/occupied/)
    end

  end

  describe "POST update" do

    before do
      BathroomVisit.create(start_time: Time.now,end_time: Time.now)
    end

    it 'should return HTTP 403 Forbidden without the secret key' do
      post :update_status
      expect(response).to have_http_status(:forbidden)
    end

    it 'should return HTTP 400 Bad Request if status is anything other than closed or open' do
      post :update_status, :secret => BathroomMonitor::SECRET, :status => nil
      expect(response).to have_http_status(:bad_request)
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'poopy'
      expect(response).to have_http_status(:bad_request)
    end

    it 'should return HTTP 200 OK if status is closed or open' do
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'closed'
      expect(response).to have_http_status(:ok)
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'open'
      expect(response).to have_http_status(:ok)
    end

    it 'should create a session if the session was inactive and the door is closed' do
      BathroomVisit.create(start_time: Time.now,end_time: Time.now)
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'closed'
      expect(BathroomVisit.last.active?).to eq true
    end

    it 'should keep the session if the session was active and the door is closed' do
      BathroomVisit.create(start_time: Time.day_start!, end_time: nil)
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'closed'
      expect(BathroomVisit.last.active?).to eq true
      expect(BathroomVisit.last.end_time).to eq nil
      expect(BathroomVisit.last.start_time).to eq Time.day_start!
      BathroomVisit.last.update_end_time
    end

    it 'should end the session if the session was active and the door is open' do
      BathroomVisit.create(start_time: Time.day_start(10), end_time: nil)
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'open'
      expect(BathroomVisit.last.start_time).to eq Time.day_start(10)
      expect(BathroomVisit.last.end_time).to be_truthy
    end

    it 'should not touch anything if the session was inactive and the door is open' do
      BathroomVisit.create(start_time: Time.day_start(10), end_time: Time.day_start(10))
      post :update_status, :secret => BathroomMonitor::SECRET, :status => 'open'
      expect(BathroomVisit.last.start_time).to eq Time.day_start(10)
      expect(BathroomVisit.last.start_time).to eq Time.day_start(10)
    end
  end

end
