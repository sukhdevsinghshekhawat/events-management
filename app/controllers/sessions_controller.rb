class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.email_verified?
        session[:user_id] = user.id
        flash[:notice] = "Logged in!"
        redirect_to root_path
      else
        flash.now[:alert] = "Please verify your email before logging in."
        render :new
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "Logged out"
    redirect_to login_path
  end
end
