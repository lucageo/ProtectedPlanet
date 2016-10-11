//= require 'require'
//= require REM-unit-polyfill/js/rem.min.js
//= require jquery
//= require jquery_ujs
//= require 'jquery.tablesorter.min'
//= require 'async-img.min'
//= require 'underscore-min'
//= require 'modules/ui_state'
//= require 'modules/search/autocompletion'
//= require 'modules/search/query_control'
//= require 'modules/dropdown'
//= require 'modules/navbar'
//= require 'modules/modal'
//= require 'modules/modals/download_generation_modal'
//= require 'modules/downloads/base'
//= require 'modules/protected_areas/factsheet_handler'
//= require 'modules/expandable_section'
//= require 'modules/dismissable'
//= require_tree './modules/downloads/'
//= require 'map'
//= require common
//

// silly hack for mobile touch events
function touchHoverFix() {
    var el = this;
    var par = el.parentNode;
    var next = el.nextSibling;
    par.removeChild(el);
    setTimeout(function() {par.insertBefore(el, next);}, 10);
}
