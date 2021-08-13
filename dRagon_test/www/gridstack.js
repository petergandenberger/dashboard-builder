var grid = GridStack.init({cellHeight: 70});
grid.column(12);
$(function(){
  $('.trigger_delete').click(function(event){
    grid.removeWidget(this.parentNode.parentNode)
  });
  
  $('.trigger_add').click(function(event){
    grid.addWidget({w: 2, content: '<div class="dR-box" style="background:blue">item</div>'})
  });
});


