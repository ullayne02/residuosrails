class Reportreg < ApplicationRecord
  belongs_to :report
  validates :weight, presence: true
end
