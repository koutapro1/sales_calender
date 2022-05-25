const getHaversineDistance = require('get-haversine-distance')

function initMap() {
  const scoreId = gon.score.id;
  const pickupTiming = "pickup";
  const dropoffTiming = "dropoff";
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
    watchId = navigator.geolocation.watchPosition(
      $.throttle(5000, success),
        error => console.log(error),
        {
          enableHighAccuracy: true
        }
    );
  });

  $("#dropoff").click( () => {
    navigator.geolocation.clearWatch(watchId);
    pickupLatLng = new google.maps.LatLng(coordinates[0], coordinates[1]);
    dropoffLatLng = new google.maps.LatLng(coordinates[coordinates.length - 2], coordinates[coordinates.length - 1]);
    pickupTime = timeStamps[0];
    dropoffTime = timeStamps[timeStamps.length - 1];
    GeocodingFunc(pickupLatLng, pickupTiming, GeocodingFunc);
  })

  function success (data) {
    setTimestamp(data);
    coordinates.push(data.coords.latitude, data.coords.longitude);
    calcFare();
    // console.log(data);
    // console.log(coordinates);
    // console.log(timeStamps);
  }

  function setTimestamp (data) {
    let time = data.timestamp;
    let dateObj = new Date(time);
    timeStamps.push(dateObj);
  }

  function calcFare () {
    if (coordinates.length > 3) {
      let a = { lat: coordinates[coordinates.length - 4], lng: coordinates[coordinates.length - 3] }
      let b = { lat: coordinates[coordinates.length - 2], lng: coordinates[coordinates.length - 1] }
      let distance = getHaversineDistance(a,b) * 1000     //メートル
      let duration = (timeStamps[timeStamps.length - 1] - timeStamps[timeStamps.length - 2]) / 1000   //秒
      let speed = (distance / duration) * 60 * 60 / 1000    //毎時キロ

      if (speed <= 10) {
        meterDistance += duration * (233 / 85);               // 時間メーター
      } else if (speed >= 10) {
        meterDistance += getHaversineDistance(a,b) * 1000;    // 距離メーター
      }
      if(meterDistance > 1052) {                              // ワンメーター超えたときの処理
        fare += 80;
        meterDistance -= 1052;
        oneMeter = false;
      }
      if (oneMeter ==false && meterDistance > 233) {          // ワンメーター以降の計算
        let counter = Math.floor(meterDistance / 233)
        fare += counter * 80;
        meterDistance = meterDistance % 233;
      }
      console.log("時間:" + duration + "秒");
      console.log("距離:" + distance + "m");
      console.log("時速" + speed + "km")
    }
    console.log("メーター距離:" + meterDistance + "m");
    console.log(fare + "円");
    $('#meter').html(`<div>${fare} 円</div>`);
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
          console.log(results);
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
            callback(dropoffLatLng, dropoffTiming);
          } else if(timing == "dropoff") {
            dropoffAddress = `${city} ${area} ${block}`
            ajaxScoreDetail();
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
    $('#meter').html("<div>0 円</div>");
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
      $('.lists').append(
        `<li><a href="/scores/${scoreId}/score_details/${data.id}"> ${data.pickup_address} ~ ${data.dropoff_address}</a> </li>`
        )
      resetMeter();
    })
    .fail(function() {
      alert("error");
    });
  }
}
window.initMap = initMap;
