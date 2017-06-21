class TopicsController < ApplicationController
	def create
		@topic = Topic.new(topic_params)
		session[:req_name] = @topic.request_name
		if @topic.save
			# broadcast_topic
			# Broadcast happens from model
			# Mail the user here to notify them that a chat room just opened.
			redirect_to "/topics/#{@topic.id}"
		end
	end
	def view
		@topic = Topic.find(params[:id])
		@user = User.find(@topic.user.id)
		if session[:user_id] == @topic.user_id
			@current_user = User.find(session[:user_id])
		end
		if @current_user && @current_user.id == @topic.user.id
			# # ActionCable.server.broadcast 'messages',
	  #       message: "The agent has joined the channel",
	  #       username: "System",
	  #       topic_id: @topic.id,
	  #       user_id: @user.id
		end
	end
	def topic_params
		params.require(:topic).permit(:name, :user_id, :request_name)
	end
	def destroy
		@user = User.find(session[:user_id])
		Topic.destroy(params['topic_id'])
		redirect_to "/#{@user.username}"
	end
	# def broadcast_topic
	# end
end
