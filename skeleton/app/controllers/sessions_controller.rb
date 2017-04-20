class SessionsController < ApplicationController
  before_action :is_logged_in?

  def new
    render :login
  end

  def create
    user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    unless user.nil?
      login_user!(user)
    else
      render text: "Wrong username or password!"
    end
  end

  def destroy
    unless current_user.nil?
      current_user.reset_session_token!
      session[:session_token] = nil
      redirect_to cats_url
    end
  end

  private

  def session_params
    params.require(:user).permit(:user_name, :password, :authenticity_token)
  end

  def is_logged_in?
    if !current_user.nil?
      redirect_to cats_url
    end
  end

end
