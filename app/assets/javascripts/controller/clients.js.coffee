# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# This one is the default '.display' class options, add id to future tables to modify

###
jQuery ->
  $('#ajaxTable').dataTable
    sPaginationType: "full_numbers"
    bJqueryUI: true
    bServerSide: true 
    sAjaxSource: $('#ajaxTable').data('source')
###
