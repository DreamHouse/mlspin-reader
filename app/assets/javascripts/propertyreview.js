$(function() {
  $('#property-review-next-btn').click(function(){
    var server_url = $('.create-propertyreview #server_url').val();
    var addr = $('.create-propertyreview #addr').val();
    var town = $('.create-propertyreview #town').val();
    
    if (addr) {
      $.ajax({
        url: server_url + '/properties/1.json?addr=' + encodeURIComponent(addr) + '&town' + town
      }).success(function(data) {
        var review_show_path = server_url + '/propertyreviews/' + data._id;
        $('.create-propertyreview #search_result').text('找到您要讨论的房子，请点击这里').append('<a href="' + review_show_path + '">这里</a>');        
      }).error(function() {
        $('.create-propertyreview #search_result').text('抱歉，没有找到您要讨论的房子，请提供该房子的基本信息，越多越好，多多益善。');
      });
    }
    return false;
  });
})