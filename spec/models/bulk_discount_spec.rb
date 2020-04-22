require 'rails_helper'

describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :minimum_items }
    it { should validate_presence_of :percentage_off }
    it { should validate_presence_of :description }
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end
