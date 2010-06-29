// On document ready!
jQuery(function($) {
  
  // from http://brandonaaron.net/blog/2009/02/24/jquery-rails-and-ajax
  
  // Always send the authenticity_token with ajax
  $(document).ajaxSend(function(event, request, settings) {
    if ( settings.type == 'post' ) {
      settings.data = (settings.data ? settings.data + "&" : "")
        + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
      request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }
  });

  // When I say html I really mean script for rails
  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
  
  // from http://codetunes.com/2008/12/08/rails-ajax-and-jquery/
  
  $('a.ajax.get').live('click', function() {
    var link = $(this);
    $.get(link.attr('href'), function(data) {
      if (link.attr('ajaxtarget'))
        $(link.attr('ajaxtarget')).replaceWith(data);
        autogrow();
    });
    return false;
  }).attr("rel", "nofollow");
  
  $('a.ajax.delete').live('click', function() {
    var link = $(this);
    $.ajax({
      type: 'POST',
      url: $(this).attr('href'),
      data: {_method: 'delete'},
      beforeSend: function(xhr) {
        if (link.attr('ajaxconfirm'))
          ajaxconfirm = confirm(link.attr('ajaxconfirm'));
          if (!ajaxconfirm) { return false; }
      },
      success: function(data) {
        if (link.attr('ajaxtarget'))
          $(link.attr('ajaxtarget')).fadeOut('normal');
      }
    });
    return false;
  }).attr("rel", "nofollow");
  
  $('form.ajax').live('submit', function() {
    var form = $(this);
    var submit_btn = form.find(':submit');
    var submit_btn_val = submit_btn.val();
    
    form.ajaxSubmit({
      beforeSubmit: function() {
        reset_submit_btn(submit_btn, submit_btn_val);
      },
      success: function(data, status) {
        $(form.attr('ajaxtarget')).replaceWith(data);
        reset_submit_btn(submit_btn, submit_btn_val);
      },
      error: function(xhr, status, error) {
        form.find('.errors').text(xhr.responseText);
        reset_submit_btn(submit_btn, submit_btn_val);
      }
    });
    return false;
  });
  
  function reset_submit_btn(submit_btn, original_val) {
    if (submit_btn.attr('loading_value')) {
      if (submit_btn.attr('disabled')) {
        submit_btn
          .removeAttr('disabled')
          .val(original_val);
      } else { 
        submit_btn
          .attr('disabled', 'disabled')
          .val(submit_btn.attr('loading_value')+'...');
      };
      submit_btn.blur();
    };
  };
    
  autogrow();
  
  $('.heading a.add.ajax').click(function() {
    var form = $('.new_ajax_form');
    form.show().find(':input:visible:first').focus();
    return false;
  });
  
  $('.new_ajax_form').find('a.cancel').click(function() {
    $(this).parents('.new_ajax_form').hide();
    return false;
  });
  
  var question_box = $('#questions_list').find('.boxxx');
  
  question_box.hover(
    function() {
      $(this).addClass('over');
    },
    function() {
      $(this).removeClass('over');
    }
  );
  
  question_box.click(function() {
    question_url = $(this).parent().
                                prev().
                                children('.show_id').
                                find('a').attr('href');
                                
    document.location = question_url;
    return false;
  });
  
  $('form#new_question').find('textarea#question_body').focus();
  $('form#new_user_session').find('input#user_session_username').focus();
  $('form#new_password_reset').find('input#email').focus();
});



function autogrow() {
  $('textarea').autogrow();
};