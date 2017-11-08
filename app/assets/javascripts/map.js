var map;

function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 40.7831, lng: -73.9712},
        zoom: 11
    });
   	var myLatLng = {lat: -25.363, lng: 131.044};
   	var marker = new google.maps.Marker({
    	position: myLatLng,
   		map: map,
    	title: 'Hello World!'
  	});

}

setTimeout(initMap, 10);


