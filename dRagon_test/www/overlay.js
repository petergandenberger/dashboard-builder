$(function(){
  $('.dropdown-toggle').click(function (event){
    var pos = this.getBoundingClientRect();
    var width = $(this).outerWidth();
    var height = $(this).outerHeight();
    console.log(this.getBoundingClientRect());
    console.log(pos)
    
    $('.dropdown-menu').css({top: (pos.top + height) + "px", left: (pos.left + width) + "px"});
  });
});

$(document).on('click', '.dropdown-menu', function (e) {
  e.stopPropagation();
});
