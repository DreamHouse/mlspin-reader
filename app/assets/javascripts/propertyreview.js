$(function() {
  $('#property-review-next-btn').click(function(){
    var server_url = $('.create-propertyreview #server_url').val();
    var addr = $('.create-propertyreview #addr').val();
    var town = $('.create-propertyreview #town').val();
    
    if (addr) {
      $.ajax({
        url: server_url + '/properties/1.json?addr=' + encodeURIComponent(addr) + '&town' + town
      }).success(function() {
        $('.create-propertyreview #search_result').text('找到了！');
      }).error(function() {
        $('.create-propertyreview #search_result').text('抱歉，没有找到啊。');
      });
    }
    
    return false;
  });
})