# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#coffeescript.org/


###
$(window).scroll (e) ->
  scroller_anchor = $(".scroller_anchor").offset().top
  if $(this).scrollTop() >= scroller_anchor and $(".scroller").css("position") isnt "fixed"
    $(".scroller").css
      position: "fixed"
      top: "0px"


    $(".scroller_anchor").css "height", "50px"
  else if $(this).scrollTop() < scroller_anchor and $(".scroller").css("position") isnt "relative"
    $(".scroller_anchor").css "height", "0px"
    $(".scroller").css
      position: "relative"
  return
###

