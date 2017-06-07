class TopicRelayJob < ApplicationJob
  def perform(topic)
    ActionCable.server.broadcast "topics",
      id: topic.id,
      name: topic.name,
      user: topic.user.username,
      request_name: topic.request_name,
      user_id: topic.user.id,
      time: topic.created_at.strftime("%I:%M %p")
  end
end