class HomeController < ApplicationController
  layout 'static'
  def index
    # render the landing page
    if current_user
      redirect_to dashboard_path
    end
  end

  def show
    render :action => params[:page]
  end
end

#link_to 'About', home_path('about')