class MessagesController < ApplicationController
	def create
		@message = Message.new(message_params)
		if @message.save
			# ActionCable.server.broadcast 'messages',
	  #       message: @message.content,
	  #       user: @message.username,
	  #       username: @message.username, 
	  #       topic_id: @message.topic_id,
	  #       user_id: @message.user.id
	        head :ok
		end
	end
	def message_params
		params.require(:message).permit(:content, :topic_id, :user_id, :username)
	end
end
