class VideosController < ApplicationController
  before_filter :require_user, :find_video, :check_permissions
  
  def show
    @logs = @video.logs
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
