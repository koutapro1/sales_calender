$(() => {
  // ---------選んだ日付の売上詳細、又は売上追加フォームを表示するための処理----------

  // クリックした日付の日付を取得して、ajaxで送信
  const getStartTime = (selector) => {
    const classes = $(selector).attr('class').split(' ');
    return classes[1];
  };

  const getStartDate = () => {
    const classes = $('.start-date').attr('class').split(' ');
    return classes[1];
  };

  $('.table td').on('click', (e) => {
    const startTime = getStartTime($(e.currentTarget));
    const startDate = getStartDate();
    if ($('.js-searched-score').length) {
      $('.js-searched-score').remove();
    }

    $.ajax({
      type: 'GET',
      url: '/scores/searches/score.html',
      data: {
        start_time: startTime,
        start_date: startDate,
      },
    })
      .done((data) => {
        $('#modal1').modal('show')
        $('#modal1').html(data);
      });
  });

  // ----------月度ジャンプの開閉
  const toggleFunc = () => {
    if ($('.js-month-jump').css('display') === 'block') {
      $('.js-toggle-button').removeClass('fas fa-caret-down');
      $('.js-toggle-button').addClass('fas fa-caret-up');
      $('.calendar-heading').css('box-shadow', '');
      $('.js-month-jump').css({ 'box-shadow': '0 1px 1px 0 rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.05)' });
    } else {
      $('.js-toggle-button').removeClass('fas fa-caret-up');
      $('.js-toggle-button').addClass('fas fa-caret-down');
      $('.js-month-jump').css('box-shadow', '');
      $('.calendar-heading').css({ 'box-shadow': '0 1px 1px 0 rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.05)' });
    }
  };

  $(document).on('click', '.js-toggle-button, .calendar-title', () => {
    $('.js-month-jump').slideToggle(200, toggleFunc);
  });
});
