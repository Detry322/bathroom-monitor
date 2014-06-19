class BathroomController < ApplicationController

  if BathroomVisit.last.nil?
    BathroomVisit.create_session.deactivate
  end

  def index
    @in_use = BathroomVisit.in_use?
  end

  def statistics
    @today_visit_count = BathroomHelper::today_trips;
    @seven_day_visit_count = BathroomHelper::seven_day_trips;
    @thirty_day_visit_count = BathroomHelper::thirty_day_trips;
    @total_visit_count = BathroomHelper::trips;
    @today_visit_seconds = BathroomHelper::today_seconds;
    @seven_day_visit_seconds = BathroomHelper::seven_day_seconds;
    @thirty_day_visit_seconds = BathroomHelper::thirty_day_seconds;
    @total_visit_seconds = BathroomHelper::seconds;
    @seven_day_time_graph = BathroomHelper::seven_day_report_seconds;
    @seven_day_trip_graph = BathroomHelper::seven_day_report_trips;

  end

  def update
    if params[:secret] == BathroomMonitor::SECRET
      if ['open','closed'].include?(params[:status])
        last_visit = BathroomVisit.last
        if params[:status] == 'closed'
          if last_visit.active?
            last_visit.update_end_time
          else
            BathroomVisit.create_session
          end
        elsif params[:status] == 'open'
          if last_visit.active?
            last_visit.deactivate
            last_visit.update_end_time
          end
        end
        head :ok
      else
        head :bad_request
      end
    else
      head :forbidden
    end
  end
end
