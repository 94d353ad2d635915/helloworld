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
  $('.tree a').each(function(e) {
    if( $(this)[0].pathname == window.location.pathname.replace(/(\/[0-9]+)?$/i, '') ){
      $(this).addClass('active');
      $(this).parents('ul').css({display: 'block'});
      //console.log('ok');
    }
  });

  $(".tree label").on({
    click: function(e) { 
      $(".tree label").next().css({display: 'none'});
      $(this).next().css({display: 'block'});
      $(this).parents('ul').css({display: 'block'});
    }
  });

  $(".tree tr").on({
    click: function(e) { 
      var _treeId = $(this).data('self');
      if ($(this).hasClass('tree-active')){
        $(this).removeClass('tree-active');
        $(" .tree tr[data-father=" + _treeId + "]").css({display: 'none'});
      } else {
        $(this).addClass('tree-active');
        $(".tree tr[data-father=" + _treeId + "]").css({display: 'table-row'});
      }
    }
  });
});