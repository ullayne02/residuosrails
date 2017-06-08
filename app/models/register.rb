class Register < ApplicationRecord
  belongs_to :residue
  belongs_to :report
  
  validates :weight, presence: true

end
