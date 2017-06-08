class Message < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  after_commit { MessageRelayJob.perform_now(self) }
end
