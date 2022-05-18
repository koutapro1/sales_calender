function initMap() {
  // マップを描画
  const mapOptions = {
    zoom: 17,
    center: {lat: 35.859683, lng: 139.909924,}
  };
  map = new google.maps.Map(document.getElementById('map'), mapOptions);

  const snappedCoordinates = [];    //修正された緯度経度を格納しておく配列
  const coordinates = gon.translated_coordinates

  // coordinatesが100個以上か以下を判定
  const beforeRequestSnapToRoads = (originalPath) => {
    if (originalPath.split("|").length > 100) {
      moreThanOneHundred(originalPath)
    } else {
      requestSnapToRoads(originalPath, processResponse)
    }
  }

  // Roads API にリクエストを送信
  const requestSnapToRoads = (originalPath, callback) => {
    $.get("https://roads.googleapis.com/v1/snapToRoads", {
      interpolate: true,
      key: gon.google_map_api_key,
      path: originalPath
    }, function(data) {
      callback(data);
    });
  }

  // coordinates を 100個ずつに分割してリクエストを送信
  const moreThanOneHundred = (originalPath) => {
    sourcePath = originalPath.split("|")
    let pathes = sourcePath.splice(0, 100)
    pathes = pathes.join("|")
    requestSnapToRoads(pathes, function(data) {
      pushCoords(data);
      if (sourcePath.length >= 100) {
        beforeRequestSnapToRoads(sourcePath.join("|"));
      } else if (sourcePath.length < 100) {
        requestSnapToRoads(sourcePath.join("|"), processResponse)
      }
    })
  }

  // 修正された緯度経度を取得後、配列 SnappedCoordinates に格納
  const pushCoords = (data) => {
    for(let i = 0; i < data.snappedPoints.length; i++) {
			// スナップされた地点の取得
			const position = new google.maps.LatLng(
				data.snappedPoints[i].location.latitude,
				data.snappedPoints[i].location.longitude);
			snappedCoordinates.push(position);
		}
  }

  // 取得したデータをもとに、地図上にルートやマーカーを表示
  const processResponse = (data) => {
		pushCoords(data)
    // スナップされた地点をもとにPolylineを表示
		const polyline = new google.maps.Polyline({
			path: snappedCoordinates,
			strokeColor: "red",
			strokeWeight: 3
		});
		polyline.setMap(map);
		// スタート地点とゴール地点にマーカーを設置し、クリックで住所を表示
		const pickupPosition = snappedCoordinates[0];
		const dropoffPosition = snappedCoordinates[snappedCoordinates.length - 1]
    const marker = []
    const InfoWindow = []
    const markerData = [
      {
        position: pickupPosition,
        address: gon.score_detail.pickup_address
      }, {
        position: dropoffPosition,
        address: gon.score_detail.dropoff_address
      }
    ];
    for ( let i = 0; i < markerData.length; i++) {
      marker[i] = new google.maps.Marker({
        position: markerData[i].position,
        map: map
      });
      InfoWindow[i] = new google.maps.InfoWindow({
        content: markerData[i].address
      });
      marker[i].addListener('click', function() {
        InfoWindow[i].open(map, marker[i])
      });
    }
    // スタート地点とゴール地点が収まるようにマップの縮尺を調節
    const bounds = new google.maps.LatLngBounds();
    bounds.extend(pickupPosition)
    bounds.extend(dropoffPosition)
    map.fitBounds(bounds)
	}
  beforeRequestSnapToRoads(coordinates)
}
window.initMap = initMap;