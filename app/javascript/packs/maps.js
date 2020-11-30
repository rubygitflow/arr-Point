$(document).on('turbolinks:load', function () {
  if (document.location.pathname == '/') {
    DG.then(function() {
      var map;
      var location_detection_disabled = gon.location_detection_disabled;
      var lang = "#{ I18n.locale }";

      map = DG.map('map', {
        center: [55.7508, 37.6177],
        fullscreenControl: false,
        zoom: 13
      });

      DG.control.scale({position: 'topright'}).addTo(map);
      DG.control.ruler({position: 'topright'}).addTo(map);
      DG.control.traffic({position: 'topright'}).addTo(map);  
      DG.control.location({position: 'topleft'}).addTo(map);

      map.locate({setView: true, watch: true})
      .on('locationfound', function(e) {
          DG.marker([e.latitude, e.longitude]).addTo(map);
      })
      .on('locationerror', function(e) {
          DG.popup()
            .setLatLng(map.getCenter())
            .setContent( location_detection_disabled )
            .openOn(map);
      })  
      map.setLang(lang);

      if (gon.drivers) { // удостоверяемся, что данные подгружены извне
        gon.drivers.forEach(function(driver) {  
          var car = driver.cars.filter(function(car){
            return car.workhorse == true;
          }); // извлекаем объект с координатами для отображения
          if (car[0].coordinates) { // извлекаем координаты для отображени
            DG.marker([car[0].coordinates[0],car[0].coordinates[1]]).addTo(map)
              .bindPopup('License plate number:'+car[0].license_plate); 
          }
        });
      }
    })
  }
});
