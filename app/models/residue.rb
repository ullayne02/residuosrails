class Residue < ApplicationRecord
  belongs_to :laboratory
  belongs_to :collection
  has_many :registers, dependent: :destroy
  
  def weight
    total = 0.0
    if Collection.all.empty? then
      total = self.registers.sum(:weight)
    else
      self.registers.where(created_at: [Collection.last.created_at..Time.now]).each do |register|
        total += register.weight
      end
    end
    return total
  end

end