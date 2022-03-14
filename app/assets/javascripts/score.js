document.addEventListener("turbolinks:load", function() {
  // 売上追加フォームの開閉
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

  // ---------選んだ日付の売上詳細をajaxで表示するための処理----------
  // 子要素を含まないtextを取得
  function getSurfaceText(selector){
    var elem = $(selector[0].outerHTML);
    elem.children().empty();
    return $.trim(elem.text());
  }

  // 今日の日付を取得
  function getToday() {
    var now = new Date();
    var y = now.getFullYear();
    var m = now.getMonth();
    var d = now.getDate();
    var w = now.getDay();
    var wd = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    var today = `${wd[w]}, ${d} ${m} ${y}`
    return today
  };

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

  // start_dateがURLになかったら、今日の日付をstart_dateに入れる
  function setStartDate() {
    var start_date = getParam('start_date')
    if(start_date){
      return start_date
    }else{
      var start_date = getToday()
      return start_date
    }
  };

  // クリックした日付の日付を取得して、ajaxで送信
  $('.table td').click(function(e){
    var date = getSurfaceText($(this));
    var start_date = setStartDate();

    $.ajax({
      type: 'GET',
      url: '/scores/searches',
      data: {
        date: date,
        start_date: start_date
        },
      dataType: 'json'
    })

    .done(function (data) {
      if ($('.js-searched-score').length) {
        $('.js-searched-score').remove()
      };

      $(data).each(function(i, score) {
        $('.js-searched-score-field').append(
          `<div class="js-searched-score">
            <p>
              日付: ${date}
              <a data-confirm="売上を削除しますか？" class="delete-button far fa-trash-alt" rel="nofollow" data-method="delete" href="/scores/${score.id}"></a>
            </p>
            <p>売上: ${score.score} 円</p>
            <p>メモ: ${score.memo}</p>
          </div>`
        )
      })
    })
  });
});