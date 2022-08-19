const selectedDateLists = [];
const schedules = gon.schedules;
$.each(schedules, (index, value) => {
  selectedDateLists.push(value.work_on);
})

$(document).on('click', '.current-month', (e) => {
  const clickedDate = $(e.currentTarget)
  const classes = clickedDate.attr('class').split(' ');
  const selectedDate = classes[1];
  clickedDate.toggleClass('has-schedule');
  if ($.inArray(selectedDate, selectedDateLists) == -1) {
    selectedDateLists.push(selectedDate);
    clickedDate.append('<div class="shift-selector-wrapper"><select name="shift" class="shift-selector"><option value="0">隔勤</option><option value="1">日勤</option><option value="2">夜勤</option></select></div>')
    $('.schedule-form').append(`<input type="hidden" class="${selectedDate}" value="${selectedDate}" name="schedules[][work_on]">`)
    $('.schedule-form').append(`<input type="hidden" class="${selectedDate}" value="0" name="schedules[][shift]">`)
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

$(document).on('change', '.shift-selector', (e) => {
  console.log($(e.currentTarget).val())
})
