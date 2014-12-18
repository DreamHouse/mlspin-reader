$(function() {
  $('#new_house_carousel').carousel({
    'interval': 3000
  });

  $('#apt_carousel').carousel({
    'interval': 5000
  });

  $('#sell_carousel').carousel({
    'interval': 4000
  });
  
  $('#town-lists').carousel({ visible: 3, itemMinWidth: 100, itemMargin: 10, autoRotate: 5000 });
})