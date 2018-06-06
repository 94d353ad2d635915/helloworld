// %ul.menus
//   %li
//     %label.menu
//     %ul
//       %li
//       %li
//         %a{"href" => ""} *
//   %li
//     %a{"href" => ""} *
//   \...

// 命名空间
$(document).ready(function() {
  function createSelect(where,_options,group=1,defalut=0){ 
    var _select = document.createElement("select");  
    for ( i = 1; i <= _options.length/group; i++){  
        var _option = document.createElement("option");  
        _option.value = _options[(i-1)*group];  
        _option.text  = _options[i*group - 1];  
        if (defalut == _option.text){  
            _option.selected = "true";  
        }  
        _select.appendChild(_option);  
    }  
    //return _select;
    $(where).html(_select);
  };

  // ascii a-z: 97-122
  var keys = []
  for(var i=97;i<=122;i++){
    keys.push( 'filter-' + String.fromCharCode(i) );
    // filter-a ~ z
  };
  // 生成 下拉选择过滤器:action,controller,verb
  // keys = ['filter-a', 'filter-b', 'filter-c'];
  keys.forEach(function (item, index, array) { 
    //console.log(item, index, array); 
    var options=["*"];
    $('.' + item).text(function(key,value){
      if( !options.includes(value) ) options.push( value);
      //console.log(key + value);
    });
    createSelect('#'+item, options.sort(), 1, "*");
  });

  // 过滤显示，仅显示选中的
  $('.filter select').change(function(){
    // 获取select发生变化的 th 的id，并提取出为:action,controller,verb
    var id = $(this).parent().attr('id');
    // 获取select发生变化后的，选中的options的值
    var _keys = keys.slice();
    _keys.splice(keys.indexOf(id), 1);
    // 一般复制是浅copy，会修改原变量值，完全copy 使用slice
    // splice 删除指定位置的元素, 1删/0不删
    //console.log(_keys,keys);
    _keys.forEach(function (item, index, array) { 
      $('#' + item + ' select').val('*');
    });

    // 开始隐藏所有tr，显示过滤中的tr
    var _selected = $(this).val();
    $('.' + id).text(function(key,value){
      if( _selected == value) {
        $(this).parent().css({display: 'table-row'});
        //console.log(key,value);
      } else if ( _selected == "*") {
        $(this).parent().css({display: 'table-row'});
      } else {
        $(this).parent().css({display: 'none'});
      }
    });
    //console.log(id,$(this).val());
  });

  // 全选复选框，
  $('#checked-all input:checkbox').change(function(e){
    //console.log($(this).val());
    var a = $(this).parents('table').find(".filter-list tr input:checkbox");
    // var b = $(".filter-list tr input:checkbox:checked");
    // var c = $(".filter-list tr input:checkbox:not(:checked)");
    var _checked = $(this)[0].checked;
    a.each(function(e) {
      if ( $(this).parent().parent().css('display') != 'none' ) {
        $(this)[0].checked = _checked ? true : false;
      }
    });
    //console.log(a.length,b.length,c.length);
  });

  // 权限列表：未选择的 隐藏/显示，自动切换
  $(".filter-list tr input:checkbox:not(:checked)").parents('tr').css({'display': 'none'});
});