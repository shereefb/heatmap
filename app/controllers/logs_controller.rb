class LogsController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def create
    log = Log.new
    log.ip = request.remote_ip
    log.youtube_id = params["youtube_id"]
    log.timelog = params["timelog"]
    log.duration = params["duration"]
    log.user_id = params["uid"]
    log.save
    log.process
    render :nothing => true
  end
end