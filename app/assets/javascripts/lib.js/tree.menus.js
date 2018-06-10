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

  // $('.treeIndex li').hover(function() {
  //       $(this).has("ul").children("ul").fadeIn();
  //   },
  //   function() {
  //       $(this).has("ul").children("ul").hide();
  //   });

  $(".treeIndex li").on({
    click: function(e) { 
      // console.log($(this));
      var _tree = $(this).has("ul").children('ul');
      ( _tree.css('display') == 'block' ) ? _tree.hide() : _tree.show();
      e.stopPropagation();
    },
    contextmenu: function(e) {
      e.preventDefault();
      var _tree = $(this).has("ul").find('ul');
      var _display = 'none';
      _tree.each(function(e) {
        if ( $(this).css('display') == 'none' ) {
          _display = 'block';
        }
      });
      _tree.css({'display': _display});
      e.stopPropagation();
    }
  });
});