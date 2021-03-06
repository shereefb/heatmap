class Log < ActiveRecord::Base
  
  COLOR_ARRAY = ["f1fddc", "c6fc66", "edfb4c", "fd9c43", "ff0b08", "980402", "510100", "140000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000"]
  
  # Takes the raw data, turns it into an array. Each cell representing a second. Each cell showing the number of times that second was viewed. This data is then added to the array in the video
  def process
    return unless processed_at == nil
    
    #TODO: check for video, if it doesn't exist create it for this user
    
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
      
      # next if last_start == starting #skipping buffering. later we can use this for more reporting

      suba = Array.new(duration){|i| ((i < starting) || (i > ending)) ? 0 : 1 }
      large_array.push suba
      
      last_start = starting
    end
    
    self.processed_at = DateTime.now
    
    if large_array == []
      heatmap_arr = Array.new(duration){1} 
    else
      heatmap_arr = large_array.transpose.map {|x| x.sum}
    end
    
    puts "heatmap arr #{heatmap_arr.inspect}"
    self.heatmap = heatmap_arr.join(",")
    self.save!
    return heatmap_arr
  end
  
  #adds the logs heatmap to the video
  def process_video_heatmap
    vid = Video.find(:first, :conditions => {:youtube_id => self.youtube_id, :user_id => self.user_id})
    
    #create the record if we can't find one
    unless vid
      vid = Video.create(:user_id => self.user_id, :youtube_id => self.youtube_id, :duration => self.duration, :total_views => 0)
    end
    
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
  
  def percentage_viewed
    sum = heatmap_array.inject(0) { |s,v| s += v }
    (sum.to_f / duration * 100).round
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
  
  def simple_gchart
    
    colors = []
    values = []
    chds=[]
    
    self.heatmap_array_as_gchart.each do |pair|
      colors.push COLOR_ARRAY[pair[0]]
      values.push pair[1]
      chds.push 0
      chds.push self.duration
    end
    
    chart = "http://chart.apis.google.com/chart?chbh=a&chs=600x30&cht=bhs&chco=#{colors.join(",")}&chds=#{chds.join(",")}&chd=t:#{values.join("|")}"
    img = '<img src="' + chart + '"  width="600" height="30" alt="" />'
    # imtg = '<img src="http://chart.apis.google.com/chart?chxr=0,0,160&chxt=x&chbh=a&chs=440x220&cht=bhs&chco=4D89F9,C6D9FD&chds=0,160,0,160&chd=t:10,50,60,80,40,60,30|50,60,100,40,30,40,30&chtt=Horizontal+bar+chart" width="440" height="220" alt="Horizontal bar chart" />'
  end
  
  def self.process_all
    Log.find(:all, :conditions => {:processed_at => nil}).each do |log|
      log.process
    end
  end
end