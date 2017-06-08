class MessageRelayJob < ApplicationJob
  def perform(message)
	ActionCable.server.broadcast 'messages',
    message: message.content,
    user: message.username,
    username: message.username, 
    topic_id: message.topic_id,
    user_id: message.user.id
  end
end