class Notification < ApplicationRecord
  belongs_to :collection
  belongs_to :request
  
  validates :message, presence: true
end
