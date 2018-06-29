OPTIONS = {
    'CURRENCIES' => "{
      'USD' => {symbol: '$', name: '美元'},
      'CNY' => {symbol: '¥', name: '人民币'},
      'POINT' => {symbol: '', name: '积分'},
      'BTC' => {symbol: '₿', name: '比特币'},
    }",
   'Option.autoloads' => "{ no: 0, yes: 1 }",
   'currencies' => "{ POINT: 0, CNY: 1, BTC: 2, USD: 3 }",
   'Notification._types' => "{commented:1,metioned_at_comment:2,metioned_at_topic:3,thanksed:4,faverited:5,following:6}",
   'Posttext.textable_types' => '{Topic:1,Comment:2,Node:3,Message:4}'
}
Option.all.to_a.each{ |o| OPTIONS[o.name] = o.value }
# 当从数据库中获取的数据，不需要对原有的 Model 进行更改的，直接只是用，如果要如 Enum 更改的，如下操作
ActiveSupport::Dependencies.clear
