// On document ready!
jQuery(function($) {
  
  $('.heading a.add').click(function() {
    var form = $('.new_ajax_form');
    form.show().find(':input:visible:first').focus();
    return false;
  });
  
  $('.new_ajax_form').find('a.cancel').click(function() {
    $(this).parents('.new_ajax_form').hide();
    return false;
  });
});