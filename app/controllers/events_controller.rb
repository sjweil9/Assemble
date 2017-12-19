class EventsController < ApplicationController

    def index
        @user = current_user
        @states = get_states
        @local_events = Event.includes(:user).where("events.state = '#{@user.state}' AND (events.date - current_date) > -1").order("date ASC, time ASC").references(:user)
        @local_events = @local_events.reject{ |e| e.date == Date.current and Time.parse(e.time.strftime("%H:%M")) - Time.parse((Time.now - e.time_offset.hours).strftime("%H:%M")) <= 0 }
        @other_events = Event.includes(:user).where("events.state != '#{@user.state}' AND (events.date - current_date) > -1").order("date ASC, time ASC").references(:user)
        @other_events = @other_events.reject{ |e| e.date == Date.current and Time.parse(e.time.strftime("%H:%M")) - Time.parse((Time.now - e.time_offset.hours).strftime("%H:%M")) <= 0 }
    end

    def create
        event = Event.new(event_params)
        unless event.save
            event.errors.each do |tag, error|
                flash[tag.to_sym] ||= []
                flash[tag.to_sym] << error
            end
            flash[:creating] = true
        end
        return redirect_to events_path
    end

    def past
        @user = current_user
        @events = Event.includes(:user).where("events.date <= current_date").references(:user)
        @events = @events.reject{ |e| e.date == Date.current and Time.parse(e.time.strftime("%H:%M")) - Time.parse((Time.now - e.time_offset.hours).strftime("%H:%M")) > 0 }
    end

    def show
        @user = current_user
        @event = Event.includes(:user, :attendees).where("events.id = #{params[:id]}").references(:user, :attendees)
        return redirect_to events_path if @event == nil
        @comments = Comment.includes(:event, :user).where("events.id = #{params[:id]}").references(:event, :user)
        @event = @event.first
    end

    def destroy
        event = Event.find(params[:id])
        event.destroy if event != nil && event.user_id == session[:user_id]
        return redirect_to events_path
    end

    def edit
        @event = Event.find(params[:id])
        @states = get_states
        @user = current_user
        return redirect_to events_path if @event.user_id != session[:user_id] or @event == nil
    end

    def update
        event = Event.find(params[:id])
        return redirect_to events_path if event.user_id != session[:user_id] or event == nil
        event.update(event_params)
        if event.valid?
            flash[:success] = "Event successfully updated!"
        else
            event.errors.each do |tag, error|
                flash[tag.to_sym] ||= []
                flash[tag.to_sym] << error
            end
        end
        return redirect_to edit_event_path(event.id)
    end

    private
        def event_params
            params.require(:event).permit(:name, :time, :date, :location, :state, :description).merge(user_id: session[:user_id])
        end

end
