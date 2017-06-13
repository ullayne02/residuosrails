class Notification < ApplicationRecord
  belongs_to :collection
  belongs_to :request
  
  attr_accessor :fac_id
  
  validates :message, presence: true
end
