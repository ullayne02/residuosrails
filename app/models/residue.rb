class Residue < ApplicationRecord
  belongs_to :laboratory
  belongs_to :collection
  has_many :registers, dependent: :destroy
  
  before_save { self.collection_id = (Collection.last == nil ? nil : Collection.last.id) }
  
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
  
  def number_registers
    num = 0
    self.registers.where(created_at: [Collection.last.created_at..Time.now]).each do |register|
      num += 1
    end
    return num
  end
end