class AnnouncementsController < ApplicationController
  before_action :require_login
  before_action :require_teacher
  before_action :set_event

  def create
    @announcement = @event.announcements.build(announcement_params)
    @announcement.user = current_user
    if @announcement.save
      # broadcast via ActionCable
      AnnouncementsChannel.broadcast_to(@event, {
        id: @announcement.id,
        user: current_user.name,
        message: @announcement.message,
        created_at: @announcement.created_at.strftime("%H:%M")
      })
      redirect_to @event, notice: "Announcement posted!"
    else
      redirect_to @event, alert: @announcement.errors.full_messages.join(", ")
    end
  end

  def destroy
    @announcement = @event.announcements.find(params[:id])
    @announcement.destroy
    redirect_to @event, notice: "Announcement deleted"
  end

  private
    def set_event
      @event = Event.find(params[:event_id])
    end

    def announcement_params
      params.require(:announcement).permit(:message)
    end

    def require_teacher
      redirect_to root_path unless current_user.role == "admin" || current_user.role == "teacher"
    end
end
