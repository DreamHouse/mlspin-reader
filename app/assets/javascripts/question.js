$(function() {
  $('#submit-question').click(function(){
    var foundOne = false
    $('.question-tag-checkbox').each(function() { 
      if ($(this).prop('checked')) foundOne = true 
    });
    
    if (foundOne == false) {
      alert('请至少选择一个类别');
      return false;
    }
  });
})