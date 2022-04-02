document.addEventListener("turbolinks:load", function() {
  // ---------選んだ日付の売上詳細をajaxで表示するための処理----------

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

  // start_dateをパラメーターから取得
  function setStartDate() {
    var start_date = getParam('start_date')
  };

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

  // ---------売上追加フォームの開閉----------
  // $(document).off("click", '#js-toggle-button');
  // $(document).on("click", '#js-toggle-button', function(){
  //   $('.js-new-score-form').slideToggle(200, alertFunc);
  // });

  // function alertFunc() {
  //   if($(this).css('display') == 'block') {
  //     $('#js-toggle-button').text("▲ 閉じる");
  //   }else{
  //     $('#js-toggle-button').text("▼ 売上追加");
  //   }
  // };
});