class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
  end

  def create
    @room = Room.new(message_params[:room_id])
    @message = @room.messages.new(message_params)
    if @message.save
      redirect_to room_messages_path
    else
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
    # mergeってなんだっけ
  end
end



