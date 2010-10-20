# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    ary = []
    ary << 'VideoHeatMap'
    
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
  
  def toggle_link(name, id, options={})
    onclick = "$('##{id}').toggle(); "
    onclick << "$('##{options[:second_toggle]}').toggle(); " if options[:second_toggle]
    onclick << (options[:focus] ? "$('##{options[:focus]}').focus(); " : "this.blur(); ")
    onclick << "return false;"
    link_to(name, "#", :onclick => onclick)
  end

  def fancybox_link(name, id, title, cssclass, replace_below_id)
    onclick = "$('body').append('<span id=\"fancy_container\">' + $('##{id}').html().replace(/xxx/g,#{replace_below_id}) + '</span>');"
    # onclick = "$('##{id}').show();"
    onclick << "$.fancybox({'autoDimensions':true, 'width': '90%','height' : '95%','title' : '#{title}','content': $('#fancy_container')}); "
    onclick << "return false;"
    link_to(name, "#", :onclick => onclick, :class => cssclass)
  end

  
  
  def survey_link(bottom = false)
    css_class = 'meta'
    css_class << ' bottom' if bottom
    
    str = ""
    str << link_to("My surveys", dashboard_path)
    str << " &#187; "
    str << link_to(@survey.title, survey_path(@survey))
    
    if @section && @section.id
      str << " &#187; "
      str << link_to(@section.title, survey_section_path(@survey,@section))
    end
    
    if @question && @question.id
      str << " &#187; "
      str << link_to("Question ##{@question.id}", survey_section_question_path(@survey,@section,@question))
    end

    content_tag(:div, str, :class => css_class)
  end
  
end
