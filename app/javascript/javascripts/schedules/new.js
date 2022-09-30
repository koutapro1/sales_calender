const schedules = gon.schedules;
const selectedDateLists = [];
let workCount = parseFloat($('.work-count').text());

$.each(schedules, (index, val) => {
  let date = val.work_on;
  let shift = parseInt($('.schedule-form').children(`.${date}.shift`).val());
  let hash = {work_on: date, shift: shift};
  selectedDateLists.push(hash);
})

const appendForm = (selector, date) => {
  selector.append(`<div class="shift-selector-wrapper"><select name="shedule[shift]" class="${date} shift-selector"><option value="0">隔勤</option><option value="1">日勤</option><option value="2">夜勤</option></select></div>`);
  $('.schedule-form').append(`<input type="hidden" class="${date} work-on" value="${date}" name="schedules[][work_on]">`);
  $('.schedule-form').append(`<input type="hidden" class="${date} shift" value="0" name="schedules[][shift]">`);
}

const addHash = (date) => {
  const shift = parseInt($('.schedule-form').children(`.${date}.shift`).val());
  const hash = {work_on: date, shift: shift};
  selectedDateLists.push(hash);
}

const countWorkDays = () => {
  var wDays = 0;
  $.each(selectedDateLists, (index, value) => {
    if(value.shift == 0) {
      wDays += 1;
    } else if(value.shift == 1 || value.shift == 2) {
      wDays += 0.5;
    }
  })
  $('.work-count').html(`${wDays} 出番を選択中...`);
}

// クリックした日付を選択状態にするか選択解除する処理
$(document).on('click', '.current-month', (e) => {
  const clickedDate = $(e.currentTarget)
  const classes = clickedDate.attr('class').split(' ');
  const selectedDate = classes[1];
  const index = selectedDateLists.findIndex(({work_on}) => work_on === `${selectedDate}`);
  clickedDate.toggleClass('has-schedule');
  // セルの中に勤務体系の選択肢を追加 & hiddenフォームを追加
  if (index === -1) {
    appendForm(clickedDate, selectedDate);
    addHash(selectedDate);
  } else {
    selectedDateLists.splice(index, 1);
    clickedDate.children('.shift-selector-wrapper').remove();
    $('.schedule-form').children(`.${selectedDate}`).remove();
  }
  countWorkDays();
});

// 日付内のselect要素をクリックした時に、親のクリックイベントが発生しないようにする
$(document).on('click', '.shift-selector', (e) => {
  e.stopPropagation();
})

// セル内に追加されたselectを変更したときにフォーム内のvalue値を連動させる処理
$(document).on('change', '.shift-selector', (e) => {
  const value = parseInt($(e.currentTarget).val());
  const selectedDate = $(e.currentTarget).attr('class').split(' ')[0];
  const index = selectedDateLists.findIndex(({work_on}) => work_on == `${selectedDate}`);
  $(`.${selectedDate}.shift`).val(value);
  selectedDateLists[index].shift = value;
  countWorkDays();
})
