class BathroomController < ApplicationController

  if ['development','production'].include?(Rails.env) and BathroomVisit.last.nil?
    puts "hi"
    Concierge.create_session.update_end_time
  end

  def index
    @in_use = Concierge.occupied?
  end

  def statistics
    @today_visit_count = Concierge.today_trips;
    @seven_day_visit_count = Concierge.seven_day_trips;
    @thirty_day_visit_count = Concierge.thirty_day_trips;
    @total_visit_count = Concierge.total_trips;
    @today_visit_seconds = Concierge.today_seconds;
    @seven_day_visit_seconds = Concierge.seven_day_seconds;
    @thirty_day_visit_seconds = Concierge.thirty_day_seconds;
    @total_visit_seconds = Concierge.total_seconds;
    @seven_day_time_graph = Concierge.seven_day_report_seconds;
    @seven_day_trip_graph = Concierge.seven_day_report_trips;

  end

  def update_browser
    output = (Concierge.occupied?) ? "occupied" : "vacant"
    if (Concierge.occupied? and params[:with_time] == 'yes')
        output = "%s %i" % [output, BathroomVisit.last.duration.to_i]
    end
    if Concierge.occupied?
      render plain: output
    else
      render plain: output
    end
  end

  def update_status
    if params[:secret] == BathroomMonitor::SECRET
      if ['open','closed'].include?(params[:status])
        last_visit = BathroomVisit.last
        if params[:status] == 'closed'
          Concierge.create_session unless last_visit.active?
        elsif params[:status] == 'open'
          last_visit.update_end_time if last_visit.active?
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
