require("jquery")
require("jquery-ui")
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

require("channels")
import toastr from 'toastr'
import "bootstrap"
import "bootstrap-datepicker"
require("bootstrap-datepicker")
import "chartkick/chart.js"

toastr.options = {
  "closeButton": false,
  "debug": false,
  "newestOnTop": false,
  "progressBar": false,
  "positionClass": "toast-top-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}

window.jQuery = $;
window.$ = $;
global.toastr = toastr

$(document).on('turbolinks:load ready', function() {
  $('#booking_tour_start_date').datepicker({
    dateFormat: 'dd/mm/yy',
    minDate: +5,
  });
});
