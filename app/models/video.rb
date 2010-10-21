class Video < ActiveRecord::Base
  belongs_to :user
  
  def logs
    Log.find(:all, :conditions => {:youtube_id => self.youtube_id})
  end
  
  #returns the heatmap as an array
  def heatmap_array
    self.heatmap.nil? ? nil : self.heatmap.split(",").collect(){|i| i.to_i}
  end
end