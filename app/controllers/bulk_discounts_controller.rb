class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @bulk_discounts = BulkDiscount.where("merchant_id = ?", current_user.merchant_id)
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end
