class RegistrationsController < ApplicationController
  before_action :require_login
  before_action :set_event
  # before_action :require_admin, only: [:index, :destroy]
  def index
    @registrations = @event.registrations.includes(:user) 
  end


  def new
    @registration = @event.registrations.new
  end

  def create
    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user

    if @event.students.include?(current_user)
      flash.now[:alert] = "Already registered"
      render :new and return
    end

    if @registration.save
      flash[:notice] = "Registered successfully!"
      redirect_to @event
    else
      render :new
    end
  end

  def destroy
    reg = @event.registrations.find_by(user: current_user)
    if reg
      reg.destroy
      flash[:notice] = "Registration cancelled!"
    else
      flash[:alert] = "You are not registered"
    end
    redirect_to @event
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end

  def registration_params
    params.require(:registration).permit(:rtu_roll_no, :semester, :mobile_no)
  end
end
