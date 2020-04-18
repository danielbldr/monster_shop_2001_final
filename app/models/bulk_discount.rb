class BulkDiscount < ApplicationRecord
  validates_presence_of :minimum_items, :percentage_off, :description

  belongs_to :merchant
end
