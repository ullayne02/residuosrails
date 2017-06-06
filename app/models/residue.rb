class Residue < ApplicationRecord
  belongs_to :laboratory
  belongs_to :collection
  has_many :registers, dependent: :destroy
  
  def total_res
    self.registers.sum(:weight)
  end
  
  def compare_report_att(res, filter)
    if filter.kind and self.kind != res.kind then
      return false
    elsif filter.onu and self.onu != res.onu then
      return false
    elsif filter.code and self.code != res.code then
      return false
    elsif filter.blend and self.blend != res.blend then
      return false
    end
    true
  end
  
end


