const selectedDateLists = [];
const schedules = gon.schedules;
$.each(schedules, (index, value) => {
  selectedDateLists.push(value.work_on);
})

// クリックした日付を選択状態にするか選択解除する処理
$(document).on('click', '.current-month', (e) => {
  const clickedDate = $(e.currentTarget)
  const classes = clickedDate.attr('class').split(' ');
  const selectedDate = classes[1];
  clickedDate.toggleClass('has-schedule');
  // セルの中に勤務体系の選択肢を追加 & hiddenフォームを追加
  if ($.inArray(selectedDate, selectedDateLists) == -1) {
    selectedDateLists.push(selectedDate);
    clickedDate.append(`<div class="shift-selector-wrapper"><select name="shedule[shift]" class="${selectedDate} shift-selector"><option value="0">隔勤</option><option value="1">日勤</option><option value="2">夜勤</option></select></div>`)
    $('.schedule-form').append(`<input type="hidden" class="${selectedDate} work-on" value="${selectedDate}" name="schedules[][work_on]">`)
    $('.schedule-form').append(`<input type="hidden" class="${selectedDate} shift" value="0" name="schedules[][shift]">`)
  } else {
    let index = selectedDateLists.indexOf(selectedDate);
    selectedDateLists.splice(index, 1);
    clickedDate.children('.shift-selector-wrapper').remove();
    $('.schedule-form').children(`.${selectedDate}`).remove()
  }
});

// 日付内のselect要素をクリックした時に、親のクリックイベントが発生しないようにする
$(document).on('click', '.shift-selector', (e) => {
  e.stopPropagation();
})

// セル内に追加されたselectを変更したときにフォーム内のvalue値を連動させる処理
$(document).on('change', '.shift-selector', (e) => {
  const value = $(e.currentTarget).val();
  const selectedDate = $(e.currentTarget).attr('class').split(' ')[0];
  $(`.${selectedDate}.shift`).val(value);
})
