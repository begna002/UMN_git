var map;
var myLatLong;

function initMap(){
  myLatLong = {lat:44.9727, lng:-93.23540000000003};

  map = new google.maps.Map(document.getElementById('map2'), {zoom: 13.2, center: myLatLong});
  var autoAddress = document.getElementById('address');
  var autocomplete = new google.maps.places.Autocomplete(autoAddress);
  var clickHandler = new ClickEventHandler(map, origin);
}

var ClickEventHandler = function(map, origin) {
  this.origin = origin;
  this.map = map;
  this.placesService = new google.maps.places.PlacesService(map);


  // Listen for clicks on the map.
  this.map.addListener('click', this.handleClick.bind(this));
};

ClickEventHandler.prototype.handleClick = function(event) {
  if (event.placeId) {
    event.stop();
    this.getPlaceInformation(event.placeId);
  }
};

ClickEventHandler.prototype.getPlaceInformation = function(placeId) {
  var me = this;
  this.placesService.getDetails({placeId: placeId}, function(place, status) {
    if (status === 'OK') {
      document.getElementById('address').value = place.formatted_address;

    }
  });
}
