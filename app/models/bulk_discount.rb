class BulkDiscount < ApplicationRecord
  validates_presence_of :minimum_items, :percentage_off, :description
  validates_numericality_of :minimum_items, greater_than_or_equal_to: 0
  validates_inclusion_of :percentage_off, :in => 1..100, :message => "must be a number between 1 and 100"

  belongs_to :merchant
end
