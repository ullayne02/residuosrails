class Report < ApplicationRecord
  belongs_to :collection
  has_many :reportregs, dependent: :destroy
  has_many :reportcells, dependent: :destroy

  attr_accessor :list
  before_save { self.collection_id = (Collection.last == nil ? nil : Collection.last.id) }
end
