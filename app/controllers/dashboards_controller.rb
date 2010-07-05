class DashboardsController < ApplicationController
  before_filter :render_home_page
  
  def show
    @your_surveys = current_user.surveys
  end
  
  private
  
  def render_home_page
    unless current_user
      # render home_path('about')
       render :template => 'pages/home' and return
    end
  end
end
