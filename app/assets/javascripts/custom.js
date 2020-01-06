$(document).on('turbolinks:load', function(){
  $('#q_tour_category_id_eq').addClass('form-control');
  $('#q_status_eq').addClass('form-control');
});

$(document).on('turbolinks:load', function() {
  $("div.reply-form").hide();
  $("a.showhide").click(function() {
    $(this).next().toggle();
  });
});

$(document).on('turbolinks:load', function() {
  $("div.comment-section").hide();
  $("button.cmt").click(function() {
    $(this).next().toggle();
  });
});

$(document).on('turbolinks:load', function() {
  // Configure/customize these variables.
  var showChar = 100;  // How many characters are shown by default
  var showChar_review = 800;
  var ellipsestext = "...";
  var moretext = "Read more";
  var lesstext = "Read less"; 

  $('.description').each(function() {
      var content = $(this).html();

      if(content.length > showChar) {

          var c = content.substr(0, showChar);
          var h = content.substr(showChar, content.length - showChar);

          var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span class="morecontent"><span>' + h + '</span>&nbsp;&nbsp;<a href="" class="morelink">' + moretext + '</a></span>';

          $(this).html(html);
      }
  });

  $('.review-content').each(function() {
    var content = $(this).html();

    if(content.length > showChar_review) {

        var c = content.substr(0, showChar_review);
        var h = content.substr(showChar_review, content.length - showChar_review);

        var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span class="morecontent"><span>' + h + '</span>&nbsp;&nbsp;<a href="" class="morelink">' + moretext + '</a></span>';

        $(this).html(html);
    }
  });

  $(".morelink").click(function(){
      if($(this).hasClass("less")) {
          $(this).removeClass("less");
          $(this).html(moretext);
      } else {
          $(this).addClass("less");
          $(this).html(lesstext);
      }
      $(this).parent().prev().toggle();
      $(this).prev().toggle();
      return false;
    });
});
