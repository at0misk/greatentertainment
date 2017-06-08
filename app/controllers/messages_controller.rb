class MessagesController < ApplicationController
	def create
		@message = Message.new(message_params)
		if @message.save
	        head :ok
		end
	end
	def message_params
		params.require(:message).permit(:content, :topic_id, :user_id, :username)
	end
end
