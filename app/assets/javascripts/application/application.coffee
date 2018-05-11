window.closeLightbox = ->
  $('.lightbox').remove()
  return


window.toggleMenu = ->
  # $('.full-screen-menu').toggleClass 'hide'
  $('.full-screen-menu').animate {
  height: 'toggle'
  opacity: 'toggle'
  }, 140
  return

$(window).load ->
  $('.container:has(div.lightbox)').css 'padding-top', '0'
  $(document).on 'click', '.clickable-row', (event) ->
    if $(this).attr('data-href') != undefined
      window.location = $(this).data('href')
    return

$('form').on 'keypress', (e) ->
  alert 'Test keypress'
  if e.keyCode == 13
    return false
  return



