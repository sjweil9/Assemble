class AttendsController < ApplicationController
    def create
        event = Event.find(params[:id])
        
        Attendee.create(user_id: session[:user_id], event_id: event.id) if event != nil
        
        return redirect_to :back
    end

    def destroy
        attend = Attendee.where(user_id: session[:user_id], event_id: params[:id])
        
        attend.first.destroy if attend.length > 0

        return redirect_to :back
    end
end
