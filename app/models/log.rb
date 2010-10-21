class Log < ActiveRecord::Base
  
  # Takes the raw data, turns it into an array. Each cell representing a second. Each cell showing the number of times that second was viewed. This data is then added to the array in the video
  def process
    return unless processed_at == nil
    process_log
    process_video_heatmap
    
  end
  
  #processes the heatmap for the log
  def process_log
    large_array = Array.new;
    ta = timelog.split(",")#timelog array
    
    last_start = -1

    ta.each do |pair|
      split = pair.split("-")
      if split.length == 1 && last_start == -1
        starting = 0
        ending = split[0].to_i
      elsif split.length == 1 && last_start > -1
        starting = split[0].to_i
        ending = duration
      elsif split.length == 2
        starting = split[0].to_i
        ending = split[1].to_i
      end
      
      next if last_start == starting #skipping buffering. later we can use this for more reporting

      suba = Array.new(duration){|i| ((i < starting) || (i > ending)) ? 0 : 1 }
      large_array.push suba
      
      last_start = starting
      puts "#{starting} #{ending} #{suba}"
    end
    
    self.processed_at = DateTime.now
    heatmap_arr = large_array.transpose.map {|x| x.sum}
    self.heatmap = heatmap_arr.join(",")
    self.save!
    puts "#{heatmap.inspect}"
    return heatmap_arr
  end
  
  #adds the logs heatmap to the video
  def process_video_heatmap
    vid = Video.find_by_youtube_id(self.youtube_id)
    return false unless vid
    large_array = Array.new
    vid_heatmap = vid.heatmap_array
    vid_heatmap = Array.new(self.duration){0} if vid_heatmap.nil?
    puts ("vid heatmap #{vid_heatmap.inspect} self #{self.heatmap_array.inspect}")
    large_array.push self.heatmap_array
    large_array.push vid_heatmap
    puts ("large array #{large_array.inspect}")
    result = large_array.transpose.map {|x| x.sum}
    vid.heatmap = result.join(",")
    vid.duration = self.duration
    vid.total_views ||= 0
    vid.total_views = vid.total_views + 1
    vid.save
    return result
  end
  
  #returns the heatmap as an array
  def heatmap_array
    self.heatmap.split(",").collect(){|i| i.to_i}
  end
  
  def self.process_all
    Log.find(:all, :conditions => {:processed_at => nil}).each do |log|
      log.process
    end
  end
end