var grid;

function initGridstackeR(opts, ncols) {
  grid = GridStack.init(opts);
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

$(function(){
  $('.grid_stack_item_delete').click(function(event){
    grid.removeWidget(this.closest(".grid-stack-item"))
  });
});

function deleteGridStackItem(that) {
  grid.removeWidget(that.closest(".grid-stack-item"))
}

function addGridStackItem(grid_stack_item) {
  grid.addWidget({w: 2, content: grid_stack_item})
}
