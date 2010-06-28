class HomeController < ApplicationController
  layout 'static'
  def index
    # render the landing page
  end

  def show
    render :action => params[:page]
  end
end

#link_to 'About', home_path('about')