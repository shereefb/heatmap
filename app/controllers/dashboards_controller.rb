class DashboardsController < ApplicationController
  before_filter :render_home_page
  
  def show
  end
  
  private
  
  def render_home_page
    unless current_user
      redirect_to login_url
       # render :template => "home/index", :layout => false and return
       # render :template => 'pages/home' and return
    end
  end
end
