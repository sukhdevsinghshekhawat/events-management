class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Please login first."
      redirect_to login_path
    end
  end

  def require_teacher
    unless logged_in? && current_user.role == "teacher"
      flash[:alert] = "Access denied."
      redirect_to root_path
    end
  end

  def require_admin
    unless logged_in? && current_user.role == "admin"
      flash[:alert] = "Admin only."
      redirect_to root_path
    end
  end

 
end