class User < ApplicationRecord
  has_one :laboratory
  has_one :request, dependent: :destroy
  
  validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create}, uniqueness: {case_sensitive: false}
  validates :name, presence: true
  validates :password, presence: true
  validates :kind, presence: true
end
