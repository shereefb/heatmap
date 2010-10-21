class Video < ActiveRecord::Base
  belongs_to :user
  
  def logs
    Log.find(:all, :conditions => {:youtube_id => self.youtube_id})
  end
  
  #returns the heatmap as an array
  def heatmap_array
    self.heatmap.nil? ? nil : self.heatmap.split(",").collect(){|i| i.to_i}
  end
  
  def heatmap_array_as_percentage
    self.heatmap.nil? ? nil : self.heatmap.split(",").collect(){|i| i.to_f / self.total_views * 100}
  end
  
  def engagement_graph
    HighChart.new('graph') do |f|
        f.chart({:defaultSeriesType=>"spline" , :renderTo => "myRenderArea" , :zoomType=> 'x'})
        f.credits({:enabled => true, :href => "http://videoheatmaps.com", :text => "videoheatmaps.com"})
        f.title({:text => "Viewer Engagement"})
        f.subtitle({:text => "click and drag in the plot area to zoom in"})
        f.x_axis(:type=>'datetime', :maxZoom => self.duration, :title => {:text => "Time"})
        f.y_axis(:title => {:text => "Percentage of video viewed"}, :min => 0.6, :startOnTick => false, :showFirstLabel => false)
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
                                                                      :radius => 2
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
          f.series(:name=>'Viewer Engagement', 
                    :type=>'area',
                    :pointInterval=> 1000,
                    :data=> self.heatmap_array_as_percentage )
            
                      
      end
  end
end