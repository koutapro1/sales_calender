document.addEventListener("turbolinks:load", function() {
  // ---------選んだ日付の売上詳細、又は売上追加フォームを表示するための処理----------

  // クリックした日付の日付を取得して、ajaxで送信
  $('.table td').click(function(e){
    if ($('.js-searched-score').length) {
      $('.js-searched-score').remove();
    };

    clickedElem = $(this);
    var start_time = setStartTime();

    $.ajax({
      type: 'GET',
      url: '/scores/searches/score.html',
      data: {
        start_time: start_time
        }
    })
    .done(function (data) {
      $(".js-searched-score-field").html(data);
    })
  });

  // 子要素を含まないtextを取得し、/ を - に変換
  function getSurfaceText(selector) {
    var elem = $(selector[0].outerHTML);
    elem.children().empty();
    var elem = $.trim(elem.text());
    return elem.replace("/", "-");
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
    var today = `${y}-${m}-${d}`;
    return today;
  };

  // start_dateをパラメーターから取得。無ければ今日の日付を返す
  function setStartDate() {
    var start_date = getParam('start_date');
    if(start_date) {
      return start_date;
    } else {
      var start_date = getToday();
      return start_date;
    }
  };

  // ajaxで送信するstart_timeを取得
  function setStartTime () {
    var date = getSurfaceText(clickedElem);
    var date = new Date(date);
    var dateMonth = date.getMonth();
    var dateDate = date.getDate();
    var startDate = new Date(setStartDate());
    var startDateYear = startDate.getFullYear();
    const decFirst = new Date(startDateYear, 11, 18);
    const decLast = new Date(startDateYear, 11, 31);
    const janFirst = new Date(startDateYear, 0, 1);
    const janLast = new Date(startDateYear, 0, 16);
    var startTimeParts = setStartTimeParts();
    var startTimeYaer = startTimeParts.getFullYear();
    var startTimeMonth = startTimeParts.getMonth() + 1;
    var startTimeDate = startTimeParts.getDate();
    return `${startTimeYaer}-${startTimeMonth}-${startTimeDate}`;

    // start_timeを、start_dateの月やクリックされた日付によって設定
    function setStartTimeParts () {
      if (startDate >= decFirst && startDate <= decLast && dateMonth == 11) {
        return new Date(startDateYear, dateMonth, dateDate);
      } else if (startDate >= decFirst && startDate <= decLast && dateMonth == 0) {
        return new Date(startDateYear + 1, dateMonth, dateDate);
      } else if (startDate >= janFirst && startDate <= janLast && dateMonth == 0) {
        return new Date(startDateYear, dateMonth, dateDate);
      } else if (startDate >= janFirst && startDate <= janLast && dateMonth == 11) {
        return new Date(startDateYear -1, dateMonth, dateDate);
      } else {
        return new Date(startDateYear, dateMonth, dateDate);
      };
    };
  };
});