class BathroomController < ApplicationController

  if BathroomVisit.last.nil?
    BathroomVisit.create_session.deactivate
  end

  def index
    @in_use = BathroomVisit.in_use?
  end

  def statistics
    @total_visit_count = BathroomHelper::total;
    @today_visit_count = BathroomHelper::total_today;
    @seven_day_visit_count = BathroomHelper::total_seven_day;
    @thirty_day_visit_count = BathroomHelper::total_thirty_day;
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
