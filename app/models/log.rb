class Log < ActiveRecord::Base
  
  COLOR_ARRAY = ["#f1fddc", "#c6fc66", "#edfb4c", "#fd9c43", "#ff0b08", "#980402", "#510100", "#140000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000"]
  
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

  #returns the heatmap as series data for google charts
  #each element of the return array show the count, and then the duration of that count
  def heatmap_array_as_gchart
    ar = self.heatmap_array
    last_amount = ar[0]
    count = -1
    gchart = []
    
    ar.each do |i|
      count = count + 1
      if i != last_amount
        gchart.push Array[last_amount,count]
        count = 0
        last_amount = i
      end
    end
    
    gchart.push Array[last_amount,count + 1]
    gchart
  end
  
  
  def gchart
    
    chart = GoogleVisualr::BarChart.new
    chart.add_column('string', 'Year')
    chart.add_rows(1)
    chart.set_value(0, 0, "")
    colors = []
    
    colcount = 1
    self.heatmap_array_as_gchart.each do |pair|
      chart.add_column('number', '')
      chart.set_value(0, colcount, pair[1]) #color will be pair[0]
      colcount = colcount + 1
      colors.push COLOR_ARRAY[pair[0]]
    end
    logger.info { "chart #{chart.inspect}" }
    # chart.hAxis.baseline = 40;
    
    #http://code.google.com/apis/visualization/documentation/gallery/barchart.html#Configuration_Options
    
    options = { :width => 600, :height => 60, :isStacked => true, :colors => colors, :legend => "none"}
    options.each_pair do | key, value |
      chart.send "#{key}=", value
    end
    chart
    
  end
  
  def self.process_all
    Log.find(:all, :conditions => {:processed_at => nil}).each do |log|
      log.process
    end
  end
end