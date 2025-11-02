class AnnouncementsChannel < ApplicationCable::Channel
  def subscribed
    event = Event.find(params[:event_id])
    stream_for event
  end
end
