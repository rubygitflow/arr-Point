// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
// https://www.botreetechnologies.com/blog/introducing-jquery-in-rails-6-using-webpacker
require("jquery")
require("packs/cars")
require("packs/rides")
require("packs/maps")
require("packs/devise_authy")

import "@fortawesome/fontawesome-free/css/all.css"
import "spectre.css"
import "2gis-maps"
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

window.addEventListener('load', function() {
  let flash = "#{flash.inspect}"; 
  let is_flash = ("#{flash.any?}" == "true"); 
  if (is_flash) {
    document.getElementById("up_container").style.display = "block";
  } else {
    document.getElementById("up_container").style.display = "none";
  };
});
