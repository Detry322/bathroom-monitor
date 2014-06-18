class BathroomController < ApplicationController

  if BathroomVisit.last.nil?
    BathroomVisit.create_session.deactivate

  def index
    @open = BathroomVisit.in_use?
  end

  def update
    if params[:secret] == BathroomMonitor::SECRET
      if ['open','closed'].include?(params[:status])
        last_visit = BathroomVisit.last
        if params[:status] == 'closed'
          if last_visit.active?
            last_visit.update_end_time
          else
            last_visit.create_session
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
