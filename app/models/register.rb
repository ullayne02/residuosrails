class Register < ApplicationRecord
  belongs_to :residue
  belongs_to :report
  
  validates :weight, presence: true
  
  def total_reg
    self.sum(:weight)
  end

end
