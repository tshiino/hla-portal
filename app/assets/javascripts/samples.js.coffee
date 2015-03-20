# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('#CD4LDL').click ->
    $('#sample_cd4_count').val('0.1')
  $('#CD4UDL').click ->
    $('#sample_cd4_count').val('9999')
  $('#VLLDL').click ->
    $('#sample_viral_load').val('0.1')
  $('#VLUDL').click ->
    $('#sample_viral_load').val('999999999')
