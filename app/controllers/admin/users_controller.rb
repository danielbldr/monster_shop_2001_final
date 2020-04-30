class Admin::UsersController < Admin::BaseController
  def user_names
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def disable
    user = User.find(params[:user_id])
    user.update(active?: false)
    flash[:notice] = "#{user.name}'s account has now been disabled"
    redirect_to '/admin/users'
  end

  def enable
    user = User.find(params[:user_id])
    user.update(active?: true)
    flash[:notice] = "#{user.name}'s account has now been enabled"
    redirect_to '/admin/users'
  end
end
