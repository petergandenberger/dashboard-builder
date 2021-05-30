function initGridstackeR(opts, ncols) {
  var grid = GridStack.init(opts);
  grid.column(ncols);

  grid.on('resizestop', function(event, el) {
    $(window).trigger('resize');
    id = el.firstElementChild.getAttribute('id');
    if(id != null) {
      Shiny.onInputChange(id + '_height', el.offsetHeight);
      Shiny.onInputChange(id + '_width', el.offsetWidth);
    }
  });

  grid.on('added', function(event, items) {
    items.forEach(function(item) {console.log(item)});
  });
}
