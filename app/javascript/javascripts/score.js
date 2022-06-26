import { format } from 'date-fns'
$(function () {
  // ---------選んだ日付の売上詳細、又は売上追加フォームを表示するための処理----------

  // クリックした日付の日付を取得して、ajaxで送信
  $('.table td').click(function() {
    const startTime = getStartTime($(this));
    if ($('.js-searched-score').length) {
      $('.js-searched-score').remove()
    };

    $.ajax({
      type: 'GET',
      url: '/scores/searches/score.html',
      data: {
        start_time: startTime
        }
    })
    .done(function (data) {
      $(".js-searched-score-field").html(data)
    })
  });

  const getStartTime = (selector) => {
    const classes = $(selector).attr('class').split(" ");
    return classes[1];
  };

  // ----------月度ジャンプの開閉
  $(document).on("click", '.js-toggle-button, .calendar-title', function(){
    $('.js-month-jump').slideToggle(200, alertFunc);
  });
  function alertFunc() {
    if($(this).css('display') == 'block') {
      $('.js-toggle-button').removeClass('fas fa-caret-down');
      $('.js-toggle-button').addClass('fas fa-caret-up');
      $('.calendar-heading').css('box-shadow', '')
      $('.js-month-jump').css({'box-shadow': '0 1px 1px 0 rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.05)'});
    }else{
      $('.js-toggle-button').removeClass('fas fa-caret-up');
      $('.js-toggle-button').addClass('fas fa-caret-down');
      $('.js-month-jump').css('box-shadow', '')
      $('.calendar-heading').css({'box-shadow': '0 1px 1px 0 rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.05)'});
    }
  };
})