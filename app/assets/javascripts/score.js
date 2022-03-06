document.addEventListener("turbolinks:load", function() {
  // $('#js-toggle-button').click(function(){
  //   $('.js-new-score-form').toggle();
  // });
  $('#js-toggle-button').on("click", function(){
    $('.js-new-score-form').slideToggle(200, alertFunc);
  });

  function alertFunc() {
    if($(this).css('display') == 'block') {
      $('#js-toggle-button').text("▲ 閉じる");
    }else{
      $('#js-toggle-button').text("▼ 売上追加");
    }
  }
});