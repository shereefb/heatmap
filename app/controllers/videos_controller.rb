class VideosController < ApplicationController
  before_filter :require_user, :find_video, :check_permissions
  
  def show
    @logs = @video.logs
    
    @h = HighChart.new('graph') do |f|
        f.chart({:defaultSeriesType=>"spline" , :renderTo => "myRenderArea" , :zoomType=> 'x'})
        f.title({:text => "Engagement Graph"})
        f.subtitle({:text => "Click and drag in the plot area to zoom in"})
        f.x_axis(:type=>'datetime', :maxZoom => @video.duration, :title => {:text => "Time"})
        f.y_axis(:title => {:text => "Engagement"}, :min => 0.6, :startOnTick => false, :showFirstLabel => false)
        f.legend(:enabled => false)
        f.plotOptions( :area => {
                                  :fillColor => {
                                                 :linearGradient => [0, 0, 0, 300],
                                                 :stops => [
                                                    [0, 'rgba(2,0,0,0)'],
                                                    [1, 'rgba(2,0,0,0)']
                                                 ]
                                                 },
                                  :lineWidth => 1,
                                  :marker => {
                                                 :enabled => false,
                                                 :states => {
                                                            :hover => {
                                                                      :enabled => true,
                                                                      :radius => 5
                                                                      }
                                                           }
                                              },
                                    :shadow => false,
                                    :states => {
                                                 :hover => {
                                                              :lineWidth => 1                  
                                                            }
                                                }
                                  }
                      )
          f.series(:name=>'Engagement', 
                    :type=>'area',
                    :pointInterval=> 1000,
                    :data=> @video.heatmap_array )
            
                      
      end
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
