class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:rpx_token] # RPX does not pass Rails form tokens...
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :find_user, :only => :show
  

  # user_data
  # found: {:name=>'John Doe', :username => 'john', :email=>'john@doe.com', :identifier=>'blug.google.com/openid/dsdfsdfs3f3'}
  # not found: nil (can happen with e.g. invalid tokens)
  def rpx_token
    raise "hackers?" unless data = RPXNow.user_data(params[:token])
     # = User.find_by_identifier(data[:identifier]) || User.create!(data)
    
      @user = User.find_by_identifier(data[:identifier])
      if !@user
        @user = User.find_by_email(data[:email])

        if @user
          @user.identifier = data[:identifier]
          @user.save
        else
          name = data[:name] || data[:username]
          newdata = {:firstname => name, :email => data[:email], :identifier => data[:identifier]}
          @user = User.new(newdata)

          #try and find a good login
          if !User.find_by_login(data[:username])
            @user.login = data[:username]
          elsif !User.find_by_login(name)
            @user.login = name
          else
            @user.login = data[:email]
          end

          raise "Couldn't create new account" unless @user.save
        end
      end

    self.current_user = @user
    redirect_to '/'
  end

  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome! Glad you made it"
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