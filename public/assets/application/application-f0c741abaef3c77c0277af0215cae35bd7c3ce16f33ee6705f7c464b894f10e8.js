(function() {
  window.closeLightbox = function() {
    $('.lightbox').remove();
  };

  window.toggleMenu = function() {
    $('.full-screen-menu').animate({
      height: 'toggle',
      opacity: 'toggle'
    }, 140);
  };

  $(window).load(function() {
    return $('.container:has(div.lightbox)').css('padding-top', '0');
  });

}).call(this);
