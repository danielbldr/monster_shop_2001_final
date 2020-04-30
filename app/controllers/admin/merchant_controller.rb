class Admin::MerchantController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def disable
    merchant = Merchant.find(params[:merchant_id])
    merchant.update(active?: false)
    merchant.deactivate_items
    flash[:notice] = "#{merchant.name}'s account is now disabled"
    redirect_to '/admin/merchants'
  end

  def enable
    merchant = Merchant.find(params[:merchant_id])
    merchant.update(active?: true)
    merchant.activate_items
    flash[:notice] = "#{merchant.name}'s account is now enabled"
    redirect_to '/admin/merchants'
  end
end
