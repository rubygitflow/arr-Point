$(document).on('turbolinks:load', function () {
  $('.rides').on('click', '.edit-ride-link', function (event) {
    event.preventDefault();
    $(this).hide();
    const rideId = $(this).data('rideId');
    
    $(`#edit-ride-${rideId}`).removeClass('hidden');
  })
})
