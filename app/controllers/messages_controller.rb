class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_event

  def index
    @messages = @event.messages.order(created_at: :asc)
    render json: @messages.as_json(include: { user: { only: :name } }, only: [:id, :content, :created_at])
  end

  def create
    @message = @event.messages.build(message_params)
    @message.user = current_user
    if @message.save
      MessagesChannel.broadcast_to(@event, {
        id: @message.id,
        user: current_user.name,
        content: @message.content,
        created_at: @message.created_at.strftime("%H:%M")
      })
      head :ok
    else
      render json: { error: @message.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
