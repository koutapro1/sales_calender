$(document).on('click', '.score-detail-tr', function () {
  window.location = $(this).data("href");
});

$(document).on('click', '.menus', function (e) {
  e.stopPropagation();
  $(this).find('.dropdown-menu').toggleClass('show');
  $('.menus').not($(this)).find('.dropdown-menu').removeClass('show');
})

$(document).on('click', function(e) {
  if(!$(e.target).parents('.dropdown').length) {
    $('.dropdown-menu').removeClass('show');
  }
})
