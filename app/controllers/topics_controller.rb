class TopicsController < ApplicationController
	def create
		@topic = Topic.new(topic_params)
		session[:req_name] = @topic.request_name
		if @topic.save
			# broadcast_topic
			redirect_to "/topics/#{@topic.id}"
		end
	end
	def view
		@topic = Topic.find(params[:id])
		@user = User.find(@topic.user.id)
		if session[:user_id] == @topic.user_id
			@current_user = User.find(session[:user_id])
		end
		# # if @user.permod
		# 	ActionCable.server.broadcast 'messages',
	 #        message: "A customer service representitive has joined the channel",
	 #        user: "System",
	 #        topic_id: @topic.id,
	 #        user_id: @user.id
		# # end
	end
	def topic_params
		params.require(:topic).permit(:name, :user_id, :request_name)
	end
	def destroy
		Topic.destroy(params['topic_id'])
		redirect_to '/chatroom_admin'
	end
	# def broadcast_topic
	# end
end
