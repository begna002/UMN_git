var iconImg;
var int;
var pictures = ["Moti.png", "Brandon.png", "Benny.png", "Yassin.png"];
var descriptions = ["1", "2", "3", "4"];
var index = 0;
function showImage(){
  iconImg.setAttribute("src", pictures[index]);
  iconImg.setAttribute("alt", descriptions[index]);
  index = (index + 1)%pictures.length;
}
function startImg(){
  iconImg = document.getElementById( "imageSet" );
  int = setInterval(function(){showImage()},2000);
}

function clearImg() {
  iconImg.setAttribute("src", "gophers-mascot.png");
  iconImg.setAttribute("alt", "Go Gophers");
}

var isOtherOption = false;
var map;
var myLatLong;
var service;
var directionsService;
var directionsRenderer;
var markerContacts = [];
var infoContacts = [];
function initMap(){
  myLatLong = {lat:44.9727, lng:-93.23540000000003};

  map = new google.maps.Map(document.getElementById('map'), {zoom: 13.2, center: myLatLong});
  service = new google.maps.places.PlacesService(map);
  directionsService = new google.maps.DirectionsService();
  directionsRenderer = new google.maps.DirectionsRenderer();
  directionsRenderer.setMap(map);
  directionsRenderer.setPanel(document.getElementById('directionsPanel'));
  var inputFrom = document.getElementById('from');
  var inputTo = document.getElementById('to');
  var autocomplete1 = new google.maps.places.Autocomplete(inputFrom);
  var autocomplete2 = new google.maps.places.Autocomplete(inputTo);




  var Place = function(address, name, disc) {
    this.address = address;
    this.name = name;
    this.disc = disc;
  };
  var allPlaces = new Array;
  var infowindow = new google.maps.InfoWindow();

  //Add Location information to allPlaces
  var names = ['<p><b>Moti</b></p>', '<p><b>Benny and Yassin</b></p>', '<p><b>Benny and Yassin</b></p>', '<p><b>Brandon</b></p>'];
  var discs = ['<p>The Radius at 15th</p>', '<p>Classic City Apt.</p>', '<p>Classic City Apt.</p>', '<p>The Quad on Delaware</p>']
  for(var i = 1; i<5;i++){
    var address = document.getElementById('contactTable').rows[i].cells[2].innerHTML;
    var name = names[i-1];
    var disc = discs[i-1]

    allPlaces.push(new Place(address, name, disc));
  }

  //Loop over allPlaces, derived from https://developers.google.com/maps/documentation/javascript/geocoding

  for(var i = 0; i< allPlaces.length; i++){
    createMarker(i, allPlaces, map, infowindow);
  }
}
function createMarker(i, allPlaces, map, infowindow){
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({ 'address': allPlaces[i].address}, function(results, status) {
    if (status == 'OK') {
        var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
          icon: {url: "icon.png", scaledSize: new google.maps.Size(50, 50)}
    });
    google.maps.event.addListener(marker, 'click', function(info) {
        infowindow.setContent(allPlaces[i].name + "\n" + allPlaces[i].disc);
        infowindow.open(map, this);
      });
    google.maps.event.addListener(map, "click", function(event) {
        infowindow.close();
      });
      markerContacts.push(marker);
      infoContacts.push(infowindow);
    } else {
      alert('Geocode was not successful: ' + status);
    }
   });

}
function PlaceOption(val){
  var element = document.getElementById("otherOption");
  if(val=='other'){
     element.disabled=false;
     isOtherOption=true;
   } else{
     element.disabled=true;
     isOtherOption=false;
   }
}


function findNearby(){
  var place;
  var request;
  var radius = parseInt(document.getElementById("radius").value);
  if(isOtherOption) {
    place = document.getElementById("otherOption").value;
    place = place.toLowerCase();
  } else {
    place = document.getElementById("myList").value;
  }
  service = new google.maps.places.PlacesService(map);
  request =  {location: myLatLong, radius: radius, type: [place]};
 // Perform a nearby search.
 service.nearbySearch({location: myLatLong, radius: radius, type: [place]}, function(results, status) {
if (status !== 'OK'){
    return;
  }
  createMarkers(results);
});
for (var i = 0; i < markerContacts.length; i++){
  markerContacts[i].setMap(null);
  infoContacts[i].close();
}
}



 function createMarkers(places) {
   var bounds = new google.maps.LatLngBounds();
   var infowindow = new google.maps.InfoWindow();

   for (var i = 0, place; place = places[i]; i++) {
     var str = "<p><b>" + place.name + "</p></b>" + "<p>" + place.geometry.location + "</p>";

     var marker = new google.maps.Marker({
       map: map,
       title: place.name,
       html: str,
       icon: {url: place.icon, primaryColor: "#0000FF", scaledSize: new google.maps.Size(30, 30)},
       position: place.geometry.location,
       address: place.address_component,
     });
     google.maps.event.addListener(marker, 'mouseover', function(info) {
         infowindow.setContent(this.html);
         infowindow.open(map, this);
      });
      google.maps.event.addListener(map, "mouseout", function(event) {
          infowindow.close();
      });
     markerContacts.push(marker);
     infoContacts.push(infowindow);
   }
 }
 function directions() {
   var from = document.getElementById('from').value;
   var to = document.getElementById('to').value;
   var elem = document.getElementsByName('dirType');
   var travelMode;

   for(i = 0; i < elem.length; i++) {
      if(elem[i].checked) {
        travelMode = elem[i].value;
      }
    }
    for (var i = 0; i < markerContacts.length; i++){
      markerContacts[i].setMap(null);
      infoContacts[i].close();
    }
    var request = {
      origin: from,
      destination: to,
      travelMode: travelMode
    };
    directionsService.route(request, function(result, status) {
      if (status == 'OK') {
        directionsRenderer.setDirections(result);
      }
    });
  }
