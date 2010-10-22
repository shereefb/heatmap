class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
  end
  
  def create
    if @user = User.find_by_email(params[:email])
      @user.deliver_password_reset_instructions!
      flash[:success] = 'Password reset instructions have been emailed to you'
      redirect_to login_url
    else
      flash[:failure] = 'No user was found with that email address'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Password updated'
      redirect_to root_url
    else
      render :edit
    end
  end

  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    access_denied!('Password reset link is invalid') unless @user
  end
end
