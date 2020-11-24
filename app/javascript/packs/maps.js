$(document).on('turbolinks:load', function () {
  var map,
      marker;

  map = DG.map('map', {
      center: [55.7508, 37.6177],
      zoom: 13
  });

  if (gon.drivers) { // удостоверяемся, что данные подгружены извне


    gon.drivers.forEach(function(driver) {  
      var car = driver.cars.filter(function(car){
        return car.workhorse == true;
      }); // извлекаем объект с координатами для отображения
      if (car[0].coordinates) { // извлекаем объект с координатами для отображени
        DG.marker([car[0].coordinates[0],car[0].coordinates[1]]).addTo(map).bindPopup(car[0].license_plate); // - никогда не видим его

      }
    });

  }
});

function dropFunction() {
  var elem = document.getElementById("menuDropup");
  if (elem.style.display=="block") {
    elem.style.display = "none";
  } else {
    elem.style.display = "block";
  }        
}
