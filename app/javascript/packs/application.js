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

  if ($('textarea').length > 0){
  var data = $('.ckeditor');
   $.each(data,function(i){
    CKEDITOR.replace(data[i].id)
   });
  }

  CKEDITOR.config.height= 800;

  CKEDITOR.editorConfig = function(config){
   config.toolbar = [
    {name: 'clipboard', items: ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFormWord', '–','Undo', 'Redo']},
    {name: 'editing', items: ['Scayt']},
    {name: 'links', items: ['Link', 'Unlink', 'Anchor']},
    {name: 'insert', items: ['Image', 'Table', 'HorizontaRule', 'SpecialChar']},
    {name: 'tool', items: ['Maximize']},
    {name: 'document', items: ['Source']}
   ];
  };
});
