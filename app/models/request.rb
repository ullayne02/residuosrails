class Request < ApplicationRecord
  belongs_to :user
  belongs_to :laboratory
  has_one :notification, dependent: :destroy
end
