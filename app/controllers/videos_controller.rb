class VideosController < ApplicationController
  before_filter :require_user
  before_filter :find_video, :except => :new
  before_filter :check_permissions, :only => :show
  
  def new
    @video = Video.new
  end
  
  def show
    # @logs = @video.logs
    @logs = Log.paginate_by_youtube_id @video.youtube_id, :page => params[:page], :per_page => 10, :order => "created_at DESC"
    
    @h = @video.engagement_graph
      
  end
  
  private
  
  def check_permissions
    render_403 unless @video.user == current_user
  end
  
  def find_video
    if (params[:youtube_id])
      @video = Video.find_by_youtube_id(params[:youtube_id])
    else
      @video = Video.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
end
