class Residue < ApplicationRecord
  belongs_to :laboratory
  belongs_to :collection
  has_many :registers, dependent: :destroy
  
  
   def total_res
   self.registers.sum(:weight)
  end
end


