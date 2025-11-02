class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:index, :edit, :update, :destroy]
  before_action :require_admin, only: [:index, :destroy] # optional

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Account created!"
      redirect_to @user
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
  end

  def edit
    redirect_to root_path unless current_user == @user || current_user.role == "admin"
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Profile updated."
      redirect_to @user
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "User deleted."
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
