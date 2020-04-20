class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @bulk_discounts = BulkDiscount.where("merchant_id = ?", current_user.merchant_id)
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    @bulk_discount = merchant.bulk_discounts.new(discount_params)
    if @bulk_discount.save
      flash[:success] = "You successfully added the #{@bulk_discount.description} discount"
      redirect_to bulk_discounts_path
    else
      flash[:error] = @bulk_discount.errors.full_messages.to_sentence
      redirect_to new_bulk_discount_path
    end
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(discount_params)
    if @bulk_discount.save
      flash[:success] = "Your discount has been updated"
      redirect_to bulk_discount_path(@bulk_discount)
    else
      flash[:error] = @bulk_discount.errors.full_messages.to_sentence
      redirect_to edit_bulk_discount_path(@bulk_discount)
    end
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:description, :minimum_items, :percentage_off, :id)
  end
end
