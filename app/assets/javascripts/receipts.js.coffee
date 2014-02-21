# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  load_datatable = ->
    $('.dataTable').dataTable( {
       "iDisplayLength": 50
     })
 
  $(document).ready(load_datatable)
  $(document).on('page:load', load_datatable)
  # Will add this function once it is ready 
  #$(document).on('page:change', load_datatable)