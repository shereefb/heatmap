# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    ary = []
    ary << 'Surveydoo'
    
    if @survey and not
       @survey.new_record? and not
       @survey.title == @page_title
      
      ary << @survey.title
    end
    
    ary << @page_title
    
    ary.reverse.join(' &ndash; ')
  end
  
  def markdown
    link = link_to 'Formatting Help',
                    'http://effectif.com/nesta/markdown-cheat-sheet',
                    :popup => true
                    
    content_tag :div, link, :class => 'formatting'
  end
  
  def no_items(text = nil, &block)
    text = if block_given?
      capture_haml(&block).chomp
    else
      text
    end
    
    content_tag(:div, text, :class => 'no_items')
  end
  
  def ajax_dom_id(record)
    '#' + dom_id(record)
  end  
end
