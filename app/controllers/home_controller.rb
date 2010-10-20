class HomeController < ApplicationController
  layout 'static'
  def index
    # render the landing page
    if current_user
      redirect_to dashboard_path
    end
  end

  def show
    logger.info { "params #{params.inspect}" }
    if params[:page] = "test.html"
      render :action => params[:page], :layout => "test"
    else
      render :action => params[:page]
    end
    
    
  end
end

#link_to 'About', home_path('about')