import { format } from 'date-fns'
$(function () {
  // ---------選んだ日付の売上詳細、又は売上追加フォームを表示するための処理----------

  // クリックした日付の日付を取得して、ajaxで送信
  $('.table td').click(function() {
    let selectedDate = getSurfaceText($(this));
    let startDate = getStartDate();
    if ($('.js-searched-score').length) {
      $('.js-searched-score').remove()
    };

    $.ajax({
      type: 'GET',
      url: '/scores/searches/score.html',
      data: {
        selected_date: selectedDate,
        start_date: startDate
        }
    })
    .done(function (data) {
      $(".js-searched-score-field").html(data)
    })
  });

  // 子要素を含まないtextを取得
  function getSurfaceText(selector) {
    let elem = $(selector[0].outerHTML);
    elem.children().empty();
    elem = $.trim(elem.text());
    return elem;
  }

  // URLから特定のパラメーターを取得
  function getParam(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    let regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }

  // 今日の日付を取得
  function getToday() {
    let now = new Date();
    let today = format(now, 'yyyy/MM/dd');
    return today;
  };

  // start_dateをパラメーターから取得。無ければ今日の日付を返す
  function getStartDate() {
    let startDate = getParam('start_date');
    if(startDate) {
      return startDate;
    } else {
      let startDate = getToday();
      return startDate;
    }
  };

  // ----------月度ジャンプの開閉
  $(document).off("click", '.js-toggle-button');
  $(document).on("click", '.js-toggle-button', function(){
    $('.js-month-jump').slideToggle(200, alertFunc);
  });
  function alertFunc() {
    if($(this).css('display') == 'block') {
      $('.js-toggle-button').text("▲");
    }else{
      $('.js-toggle-button').text("▼");
    }
  };
})