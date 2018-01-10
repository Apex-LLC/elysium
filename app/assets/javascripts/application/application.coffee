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
  $('.container:has(div.my-auto)').css 'padding-top', '0'