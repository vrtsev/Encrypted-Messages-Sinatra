class Message < ActiveRecord::Base # :nodoc:
  validates :content, presence: true
end
