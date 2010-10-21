class Log < ActiveRecord::Base
  
  # Takes the raw data, turns it into an array. Each cell representing a second. Each cell showing the number of times that second was viewed. This data is then added to the array in the video
  def process
  end
  
  def self.process_all
  end
end