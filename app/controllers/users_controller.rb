class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :find_user, :only => :show
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'Welcome to VideoHeatMap!'
      redirect_back_or_default root_url
    else
      flash[:error] = 'There was a problem with your form'
      render :new
    end
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:success] = 'Account updated'
      redirect_to account_url
    else
      render :edit
    end
  end
  
  def destroy
    @current_user.destroy
    redirect_to root_url
  end
  
  private
  
  def find_user
    @user = User.find_by_username(params[:username])
    
    unless @user
      render :text => 'User not found.', :status => 404
    end
  end
end