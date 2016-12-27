# Repository Incremental Search program  

工夫したポイント

  - autolayout
    - autolayoutの調整でiPhone6以上のデバイスなら全て対応できるようにした
  - 検索結果画面のincrement update(一回の更新で12個の記録のみ増やす)
    - 一気に検索結果全てを表示するのではなく、毎回12個ずつ増やして表示するようにした　　　　
  - ユーザーアバータイメージの非同期処理　
    - イメージを一気にダウンロードすると時間かかるのと、全てを一気に表示した場合、tableviewの速度も落ちるため、非同期通信でどんどんダウンロードできるようにした
  - 検索option機能の追加
  - UserDefaultsに置ける自作クラスデータの保存 

#demo

## インクリメント検索 / 検索回数制限エラー

![search](http://ganbaruyo.net/gif/search.gif)

## オプションを加えた検索

![optionsearch](http://ganbaruyo.net/gif/option1.gif)

![optionsearch](http://ganbaruyo.net/gif/option2.gif)

## 気に入りボダーンとレポジトリの閲覧

![favorite](http://ganbaruyo.net/gif/favorite1.gif)

![favorite](http://ganbaruyo.net/gif/favorite2.gif)
