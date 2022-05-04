document.addEventListener("turbolinks:load", function() {
  // ---------選んだ日付の売上詳細、又は売上追加フォームを表示するための処理----------

  // クリックした日付の日付を取得して、ajaxで送信
  $('.table td').click(function(e){
    var date = getSurfaceText($(this));
    var start_date = setStartDate();
    if ($('.js-searched-score').length) {
      $('.js-searched-score').remove()
    };

    $.ajax({
      type: 'GET',
      url: '/scores/searches/score.html',
      data: {
        date: date,
        start_date: start_date
        }
    })
    .done(function (data) {
      $(".js-searched-score-field").html(data)
    })
  });

  // 子要素を含まないtextを取得
  function getSurfaceText(selector){
    var elem = $(selector[0].outerHTML);
    elem.children().empty();
    return $.trim(elem.text());
  }

  // URLから特定のパラメーターを取得
  function getParam(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }

  // 今日の日付を取得
  function getToday() {
    var now = new Date();
    var y = now.getFullYear();
    var m = now.getMonth();
    var d = now.getDate();
    var today = `${y}-${m}-${d}`
    return today
  };

  // start_dateをパラメーターから取得。無ければ今日の日付を返す
  function setStartDate() {
    var start_date = getParam('start_date')
    if(start_date){
      return start_date
    }else{
      var start_date = getToday()
      return start_date
    }
  };
});