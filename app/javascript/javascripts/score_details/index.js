const getHaversineDistance = require('get-haversine-distance')
import { format } from 'date-fns'

function initMap() {
  const scoreId = gon.score.id;
  const pickupTiming = "pickup";
  const dropoffTiming = "dropoff";
  let status;
  let timeStamps = [];
  let coordinates = [];
  let watchId;
  let pickupLatLng;
  let dropoffLatLng;
  let pickupTime;
  let dropoffTime;
  let pickupAddress;
  let dropoffAddress;
  let fare = 420;
  let meterDistance = 0;
  let oneMeter = true;

  $('#pickup').click( () => {
    status = "occupied"
    watchId = navigator.geolocation.watchPosition(
    $.throttle(5000, success),
      error => console.log(error),
      {
        enableHighAccuracy: true
      }
    );
  });

  $("#dropoff").click( () => {
    status = "vacant"
    navigator.geolocation.clearWatch(watchId);
    dropoffLatLng = new google.maps.LatLng(coordinates[coordinates.length - 2], coordinates[coordinates.length - 1]);
    dropoffTime = timeStamps[timeStamps.length - 1];
    if (fare >= 9000) {
      fare = Math.floor((fare - (fare - 9000) * 0.1) / 10) * 10
    };
    GeocodingFunc(dropoffLatLng, dropoffTiming, ajaxScoreDetail);
  })

  function success (data) {
    if (status == "occupied") {
      console.log(watchId);
      setTimestamp(data);
      coordinates.push(data.coords.latitude, data.coords.longitude);
      if (coordinates.length <= 4 && coordinates.length >= 3) {
        pickupLatLng = new google.maps.LatLng(coordinates[2], coordinates[3]);
        GeocodingFunc(pickupLatLng, pickupTiming);
      }
      calcFare();
    }
  }

  function setTimestamp (data) {
    let time = data.timestamp;
    let dateObj = new Date(time);
    timeStamps.push(dateObj);
  }

  function calcFare () {
    if (coordinates.length < 3) {
      $('.lists').append(
        `<tr class="js-addedList">
          <td></td>
          <td class="js-added-pickup-time pickup-time"></td>
          <td class="js-added-dropoff-time dropoff-time"></td>
          <td class="js-added-pickup-address pickup-address">場所取得中</td>
          <td class="js-added-dropoff-address dropoff-address"></td>
          <td class="js-added-fare fare"></td>
          <td class="js-added-delete-button delete-button"></td>
        </tr>`
      )
    }
    let hour = timeStamps[timeStamps.length - 1].getHours()
    if (coordinates.length > 5) {
      let lastPosition = { lat: coordinates[coordinates.length - 4], lng: coordinates[coordinates.length - 3] }
      let currentPosition = { lat: coordinates[coordinates.length - 2], lng: coordinates[coordinates.length - 1] }
      let distance = getHaversineDistance(lastPosition, currentPosition) * 1000     //メートル
      let duration = (timeStamps[timeStamps.length - 1] - timeStamps[timeStamps.length - 2]) / 1000   //秒
      let speed = (distance / duration) * 60 * 60 / 1000      //毎時キロ
      let oneMeterLimit = 1052;
      let distanceLimit = 233;
      let timeLimit = 85;
      if (hour >= 22 || hour < 5) {
        oneMeterLimit = oneMeterLimit / 1.2;
        distanceLimit = distanceLimit / 1.2;
        timeLimit = timeLimit / 1.2;
      }
      if (speed <= 10) {
        meterDistance += duration * (distanceLimit / timeLimit);      // 時間メーター
      } else if (speed > 10) {
        meterDistance += distance;                                     // 距離メーター
      }
      if(meterDistance > oneMeterLimit) {                              // ワンメーター超えたときの処理
        fare += 80;
        meterDistance -= oneMeterLimit;
        oneMeter = false;
      }
      if (oneMeter == false && meterDistance > distanceLimit) {          // ワンメーター以降の計算
        let counter = Math.floor(meterDistance / distanceLimit)
        fare += counter * 80;
        meterDistance = meterDistance % distanceLimit;
      }
      console.log("時間:" + duration + "秒");
      console.log("距離:" + distance + "m");
      console.log("時速" + speed + "km");
    }
    console.log(timeStamps[timeStamps.length - 1]);
    console.log("メーター距離:" + meterDistance + "m");
    console.log(fare + "円");
    $('.meter').html(`<p class="meter-fare">${fare}</p><p class="meter-yen">円</p>`);
    if (hour >= 22 || hour < 5) {
      $('.meter').prepend(`<p class="extra-fee">割増</p>`);
    }
  }

  function GeocodingFunc(latlng, timing, callback) {
    const geocoder = new google.maps.Geocoder();
    let city;
    let area;
    let block;
    geocoder.geocode(
      {
        'latLng': latlng
      },
      function(results, status){
        if(status==google.maps.GeocoderStatus.OK) {
          for (let i = 0; i < results[0].address_components.length; i++) {
            for (let j = 0; j < results[0].address_components[i].types.length; j++) {
              if (results[0].address_components[i].types[j] == "locality") {
                city = results[0].address_components[i].long_name
              } else if (results[0].address_components[i].types[j] == "sublocality_level_2") {
                area = results[0].address_components[i].long_name
              } else if (results[0].address_components[i].types[j] == "sublocality_level_3") {
                block = results[0].address_components[i].long_name
              }
            }
          }
          if (timing == "pickup") {
            pickupTime = timeStamps[1];
            pickupAddress = `${city} ${area} ${block}`
            $('.js-added-pickup-time').replaceWith(
              `<td class="js-added-pickup-time">${format(pickupTime, 'HH:mm')}</td>`
            );
            $('.js-added-pickup-address').replaceWith(
              `<td class="js-added-pickup-address">${pickupAddress}</td>`
            );
          } else if(timing == "dropoff") {
            dropoffAddress = `${city} ${area} ${block}`
            callback();
          }
        }
      }
    )
  }

  function resetMeter () {
    timeStamps = [];
    coordinates = [];
    fare = 420;
    meterDistance = 0;
    oneMeter = true;
    $('.meter').html(
      '<p class="meter-fare">0</p><p class="meter-yen">円</p>'
    );
  }

  function ajaxScoreDetail () {
    $.ajax({
      url: `/scores/${scoreId}/score_details`,
      async: false,
      type: "POST",
      data: {
        score_detail: {
          coords: coordinates,
          pickup_address: pickupAddress,
          dropoff_address: dropoffAddress,
          pickup_time: pickupTime,
          dropoff_time: dropoffTime,
          fare: fare
        }
      }
    })
    .done(function(responce) {
      $('.js-addedList').replaceWith(responce);
      resetMeter();
    })
    .fail(function() {
      alert("通信に失敗しました。");
    });
  }
}
window.initMap = initMap;






// 割増ワンメーター:
// 1052 / 1.2 = 876.66m
// 割増後続距離:
// 233 / 1.2 = 194.16m
// 割増時間メーター:
// 70.86秒
