class UsersController < ApplicationController
  before_action :is_logged_in?

  def new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      login_user!(user)

    else
      render text: user.errors.full_messages, status: 401
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def is_logged_in?
    if !current_user.nil?
      redirect_to cats_url
    end
  end

end
