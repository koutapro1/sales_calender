import { format } from 'date-fns';

import { throttle } from 'throttle-debounce';

const getHaversineDistance = require('get-haversine-distance');

const initMap = () => {
  const scoreId = gon.score.id;
  const geocoder = new google.maps.Geocoder();
  let availability;
  let timeStamps = [];
  let coordinates = [];
  let watchId;
  let pickupLatLng;
  let dropoffLatLng;
  let pickupTime;
  let dropoffTime;
  let pickupAddress;
  let dropoffAddress;
  let city;
  let area;
  let block;
  let fare = 420;
  let meterDistance = 0;
  let oneMeter = true;

  const setTimestamp = (data) => {
    const time = data.timestamp;
    const dateObj = new Date(time);
    timeStamps.push(dateObj);
  };

  const calcFare = () => {
    if (coordinates.length < 3) {
      $('.lists').append(
        `<tr class="js-added-list">
          <td></td>
          <td class="js-added-time">
            <div class="js-added-pickup-time"></div>
            <div class="js-added-dropoff-time"></div>
          </td>
          <td class="js-added-pickup-address pickup-address">場所取得中</td>
          <td class="js-added-dropoff-address dropoff-address"></td>
          <td class="js-added-fare fare"></td>
          <td class="js-added-delete-button delete-button"></td>
        </tr>`,
      );
    }
    const hour = timeStamps[timeStamps.length - 1].getHours();
    if (coordinates.length > 5) {
      const lastPosition = { lat: coordinates[coordinates.length - 4], lng: coordinates[coordinates.length - 3] };
      const currentPosition = { lat: coordinates[coordinates.length - 2], lng: coordinates[coordinates.length - 1] };
      const distance = getHaversineDistance(lastPosition, currentPosition) * 1000; // メートル
      const duration = (timeStamps[timeStamps.length - 1] - timeStamps[timeStamps.length - 2]) / 1000; // 秒
      const speed = (distance / duration) * 60 * 60 / 1000; // 毎時キロ
      let oneMeterLimit = 1052;
      let distanceLimit = 233;
      let timeLimit = 85;
      if (hour >= 22 || hour < 5) {
        oneMeterLimit /= 1.2;
        distanceLimit /= 1.2;
        timeLimit /= 1.2;
      }
      if (speed <= 10) {
        meterDistance += duration * (distanceLimit / timeLimit); // 時間メーター
      } else if (speed > 10) {
        meterDistance += distance; // 距離メーター
      }
      if (meterDistance > oneMeterLimit) { // ワンメーター超えたときの処理
        fare += 80;
        meterDistance -= oneMeterLimit;
        oneMeter = false;
      }
      if (oneMeter === false && meterDistance > distanceLimit) { // ワンメーター以降の計算
        const counter = Math.floor(meterDistance / distanceLimit);
        fare += counter * 80;
        meterDistance %= distanceLimit;
      }
    }
    $('.meter-display').html(`<p class="meter-fare">${fare}</p><p class="meter-yen">円</p>`);
    if (hour >= 22 || hour < 5) {
      $('.meter-display').prepend('<p class="extra-fee">割増</p>');
    }
  };

  const geocodingFunc = (latlng) => new Promise((resolve) => {
    geocoder.geocode({ latLng: latlng }, (results, status) => {
      if (status === google.maps.GeocoderStatus.OK) {
        for (let i = 0; i < results[0].address_components.length; i += 1) {
          for (let j = 0; j < results[0].address_components[i].types.length; j += 1) {
            if (results[0].address_components[i].types[j] === 'locality') {
              city = results[0].address_components[i].long_name;
            } else if (results[0].address_components[i].types[j] === 'sublocality_level_2') {
              area = results[0].address_components[i].long_name;
            } else if (results[0].address_components[i].types[j] === 'sublocality_level_3') {
              block = results[0].address_components[i].long_name;
            }
          }
        }
        resolve();
      }
    });
  });

  const pickupGeocoding = async (latlng) => {
    await geocodingFunc(latlng);
    pickupTime = timeStamps[1];
    pickupAddress = `${city} ${area} ${block}`;
    $('.js-added-pickup-time').replaceWith(
      `<div class="js-added-pickup-time">${format(pickupTime, 'HH:mm')}</div>`,
    );
    $('.js-added-pickup-address').replaceWith(
      `<td class="js-added-pickup-address">${pickupAddress}</td>`,
    );
  };

  const setDropoffData = () => {
    dropoffAddress = `${city} ${area} ${block}`;
    dropoffTime = timeStamps[timeStamps.length - 1];
  };

  const successWatchPosition = (data) => {
    if (availability === false) {
      setTimestamp(data);
      coordinates.push(data.coords.latitude, data.coords.longitude);
      if (coordinates.length === 4) {
        pickupLatLng = new google.maps.LatLng(coordinates[2], coordinates[3]);
        pickupGeocoding(pickupLatLng);
      }
      calcFare();
    }
  };

  const failWatchPosition = (error) => {
    const errorType = {
      0: '不明なエラー',
      1: '位置情報の利用が許可されていません',
      2: '位置情報を取得できませんでした',
      3: 'タイムアウトしました',
    };
    let errMsg = errorType[error.code];
    if (error.code === 0 || error.code === 2) {
      errMsg = `${errMsg} ${error.message}`;
    }
    alert(errMsg);
    $('.meter-button').html(
      '<button id="pickup" class="btn pickup-button">実車</button>',
    );
  };

  const resetMeter = () => {
    timeStamps = [];
    coordinates = [];
    fare = 420;
    meterDistance = 0;
    oneMeter = true;
    $('.meter-display').html(
      '<p class="meter-fare">0</p><p class="meter-yen">円</p>',
    );
    $('.meter-button').html(
      '<button id="pickup" class="btn pickup-button">実車</button>',
    );
  };

  const ajaxScoreDetail = () => {
    $.ajax({
      url: `/scores/${scoreId}/score_details`,
      async: false,
      type: 'POST',
      data: {
        score_detail: {
          coords: coordinates,
          pickup_address: pickupAddress,
          dropoff_address: dropoffAddress,
          pickup_time: pickupTime,
          dropoff_time: dropoffTime,
          fare,
        },
      },
    })
      .done((responce) => {
        $('.js-added-list').replaceWith(responce);
        resetMeter();
      })
      .fail(() => {
        alert('通信に失敗しました');
      });
  };

  $(document).on('click', '#pickup', () => {
    availability = false;
    $('.meter-button').html(
      '<button id="dropoff" class="btn dropoff-button">支払い</button>',
    );
    watchId = navigator.geolocation.watchPosition(
      throttle(5000, successWatchPosition),
      failWatchPosition,
      {
        enableHighAccuracy: true,
      },
    );
  });

  $(document).on('click', '#dropoff', async () => {
    availability = true;
    navigator.geolocation.clearWatch(watchId);
    dropoffLatLng = new google.maps.LatLng(
      coordinates[coordinates.length - 2],
      coordinates[coordinates.length - 1],
    );
    if (fare >= 9000) {
      fare = Math.floor((fare - (fare - 9000) * 0.1) / 10) * 10;
    }
    await geocodingFunc(dropoffLatLng);
    setDropoffData();
    ajaxScoreDetail();
  });
};
window.initMap = initMap;

// 割増ワンメーター:
// 1052 / 1.2 = 876.66m
// 割増後続距離:
// 233 / 1.2 = 194.16m
// 割増時間メーター:
// 70.86秒
