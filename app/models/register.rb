class Register < ApplicationRecord
  belongs_to :residue
  validates :weight, presence: true
end
