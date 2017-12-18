class Comment < ActiveRecord::Base
    belongs_to :event, required: true
    belongs_to :user, required: true
    validates :content, length: { in: 1..140, message: "Comment must be between 1 and 140 characters." }
end
