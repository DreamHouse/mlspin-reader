$(function() {
  // $('#new_house_carousel').carousel({
  //   'interval': 3000
  // });
  //
  // $('#apt_carousel').carousel({
  //   'interval': 5000
  // });
  //
  // $('#sell_carousel').carousel({
  //   'interval': 4000
  // });
  
  // $('#town-lists').carousel({
  //   'interval': 4000
  // });
  
  // $('#town-lists .item').each(function(){
  //   var next = $(this).next();
  //   if (!next.length) {
  //     next = $(this).siblings(':first');
  //   }
  //   next.children(':first-child').clone().appendTo($(this));
  //
  //   for (var i=0;i<2;i++) {
  //     next=next.next();
  //     if (!next.length) {
  //       next = $(this).siblings(':first');
  //     }
  //
  //     next.children(':first-child').clone().appendTo($(this));
  //   }
  //});
  
  $('#town-lists').carousel({ visible: 3, itemMinWidth: 100, itemMargin: 10, autoRotate: 5000 });
})