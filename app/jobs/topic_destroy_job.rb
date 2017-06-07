class TopicDestroyJob < ApplicationJob
  def perform(topic)
	ActionCable.server.broadcast 'messages',
    message: "Thank you, your conversation has ended.  If you need further support, click <a href='/chatroom'>here</a> to submit another ticket.",
    user: "System",
    topic_id: topic.id
  end
end