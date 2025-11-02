class EventsController < ApplicationController
  before_action :require_login
  before_action :require_admin, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def show
    @registration = @event.registrations.find_by(user: current_user)
  end
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: "Event created successfully."
    else
      # Turbo compatible fallback
      redirect_to new_event_path, alert: @event.errors.full_messages.join(", ")
    end
  end


  def edit; end

  def update
    if @event.update(event_params)
      flash[:notice] = "Event updated!"
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event deleted!"
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :venue, :date, :start_time, :end_time,:teacher_id)
  end
end
