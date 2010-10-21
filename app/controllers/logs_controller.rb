class LogsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    log = Log.new
    log.ip = request.remote_ip
    log.youtube_id = params["youtube_id"]
    log.timelog = params["timelog"]
    log.save
    render :nothing => true
  end
end