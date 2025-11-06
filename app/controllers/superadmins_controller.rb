class SuperadminsController < ApplicationController
  before_action :require_super_admin, except: [:sign_in, :login]

  def sign_in
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password]) && user.super_admin?
      session[:super_admin_id] = user.id
      redirect_to superadmin_dashboard_path, notice: "Welcome Super Admin!"
    else
      flash.now[:alert] = "Invalid Access Denied."
      render :sign_in, status: :unprocessable_content
    end
  end

  def dashboard
    @users = User.all
    @events = Event.all
    @messages = Message.all
    @announcements = Announcement.all
  end

  # CRUD Power Actions
  def destroy_user
    user = User.find(params[:id])
    if user.super_admin?
      redirect_to superadmin_dashboard_path, alert: "Cannot delete another super admin!"
    else
      user.destroy
      redirect_to superadmin_dashboard_path, notice: "User deleted successfully!"
    end
  end

  def destroy_event
    Event.find(params[:id]).destroy
    redirect_to superadmin_dashboard_path, notice: "Event deleted successfully!"
  end

  def destroy_message
    Message.find(params[:id]).destroy
    redirect_to superadmin_dashboard_path, notice: "Message deleted successfully!"
  end

  def destroy_announcement
    Announcement.find(params[:id]).destroy
    redirect_to superadmin_dashboard_path, notice: "Announcement deleted successfully!"
  end

  def new_admin
    @user = User.new
  end

  def create_admin
    @user = User.new(user_params)
    @user.role = "admin"
    if @user.save
    	UserMailer.verification_email(@user).deliver_now
      redirect_to superadmin_dashboard_path, notice: "Admin created successfully!"
    else
      render :new_admin, status: :unprocessable_content
    end
  end

  private

  def require_super_admin
    unless current_super_admin
      redirect_to superadmin_sign_in_path, alert: "Access denied!"
    end
  end

  def current_super_admin
    @current_super_admin ||= User.find_by(id: session[:super_admin_id], role: "super_admin")
  end
  helper_method :current_super_admin

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  
  def verify_email
    user = User.find_by(verification_token: params[:token])
    if user.present?
      user.update(email_verified: true, verification_token: nil)
      flash[:notice] = "Your email has been verified successfully!"
      redirect_to login_path
    else
      flash[:alert] = "Invalid or expired verification link."
      redirect_to root_path
    end
  end
end
