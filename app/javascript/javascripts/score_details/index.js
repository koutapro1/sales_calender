function initMap() {
  const timeStamps = [];
  const coordinates = [];
  const scoreId = gon.score.id
  const pickupTiming = "pickup"
  const dropoffTiming = "dropoff"
  const geocoder = new google.maps.Geocoder();

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
    GeocodingFunc(pickupLatLng, pickupTiming, GeocodingFunc);
  })

  function success (data) {
    setTimestamp(data);
    timeStamps.push(timeStr);
    coordinates.push(data.coords.latitude, data.coords.longitude);
    pickupLatLng = new google.maps.LatLng(coordinates[0], coordinates[1]);
    dropoffLatLng = new google.maps.LatLng(coordinates[coordinates.length - 2], coordinates[coordinates.length - 1]);
    pickupTime = timeStamps[0];
    dropoffTime = timeStamps[timeStamps.length - 1];
    console.log(data);
    console.log(coordinates);
    console.log(timeStamps);
    console.log(pickupTime);
    console.log(dropoffTime);
  }

  function setTimestamp (data) {
    var time = data.timestamp;
    var dateObj = new Date(time);
    var Y = dateObj.getFullYear();
    var M = dateObj.getMonth() + 1;
    var D = dateObj.getDate();
    var HH = dateObj.getHours();
    var MM = dateObj.getMinutes();
    var SS = dateObj.getSeconds();
    var MS = dateObj.getMilliseconds();
    timeStr = `${Y}-${M}-${D} ${HH}:${MM}:${SS}.${MS}`
  }

  function GeocodingFunc(latlng, timing, callback) {
    geocoder.geocode(
      {
        'latLng': latlng
      },
      function(results, status){
        if(status==google.maps.GeocoderStatus.OK) {
          console.log(results);
          for (var i = 0; i < results[0].address_components.length; i++) {
            for (var j = 0; j < results[0].address_components[i].types.length; j++) {
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
          dropoff_time: dropoffTime
        }
      },
      dataType: "json"
    })
    .done(function(data) {
      $('.lists').append(
        `<li><a href="/scores/${scoreId}/score_details/${data.id}"> ${data.pickup_address} ~ ${data.dropoff_address}</a> </li>`
        )
    })
    .fail(function() {
      alert("error");
    });
  }
}
window.initMap = initMap;