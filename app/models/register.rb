class Register < ApplicationRecord
  belongs_to :residue
  
  validates :weight, presence: true
  def total_reg
    self.sum(:weight)
  end
end
