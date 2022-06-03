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
    GeocodingFunc(dropoffLatLng, dropoffTiming, ajaxScoreDetail);
  })

  function success (data) {
    if (status == "occupied") {
      console.log(watchId);
      setTimestamp(data);
      coordinates.push(data.coords.latitude, data.coords.longitude);
      if (coordinates.length <= 4 && coordinates.length >= 3) {
        pickupLatLng = new google.maps.LatLng(coordinates[2], coordinates[3]);
        pickupTime = timeStamps[1];
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
        `<li id="js-addedList">場所取得中</li>`
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
      if (oneMeter ==false && meterDistance > oneMeterLimit) {          // ワンメーター以降の計算
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
    $('.meter').html(`<div>メーター料金: ${fare}円</div>`);
    if (hour >= 22 || hour < 5) {
      $('.extra-fee').html(`<div>割増</div>`);
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
            pickupAddress = `${city} ${area} ${block}`
            $('#js-addedList').remove();
            $('.lists').append(
              `<li id="js-addedList">${pickupAddress}</li>`
              )
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
    $('.meter').html("<div>メーター料金: 0円</div>");
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
      },
      dataType: "json"
    })
    .done(function(data) {
      let pickupDateData = format(new Date(data.pickup_time), 'HH:mm:ss')
      let dropoffDateData = format(new Date(data.dropoff_time), 'HH:mm:ss')
      $('#js-addedList').remove();
      $('ol').append(
        `<li><a href="/scores/${scoreId}/score_details/${data.id}"> ${data.pickup_address} ~ ${data.dropoff_address} ${pickupDateData} ${dropoffDateData} ${data.fare}円</a> </li>`
        )
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
