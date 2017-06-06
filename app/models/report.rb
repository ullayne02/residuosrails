class Report < ApplicationRecord
  belongs_to :collection
  has_many :registers, dependent: :destroy
  has_many :reportcells, dependent: :destroy

  attr_accessor :list
end
