class Residue < ApplicationRecord
  belongs_to :laboratory
  belongs_to :collection
  has_many :registers, dependent: :destroy
  
  def weight
    total = 0.0
    Register.where(created_at: [Collection.last.created_at..Time.now]).each do |register|
      if self.id = register.residue_id
        total += register.weight
      end
    end
    return total
  end
  
  def total_res
    self.registers.sum(:weight)
  end
end