$(document).on('turbolinks:load', function () {
  $('.cars').on('click', '.edit-car-link', function (event) {
    event.preventDefault();
    $(this).hide();
    const carId = $(this).data('carId');
    
    $(`#edit-car-${carId}`).removeClass('hidden');
  })
})
