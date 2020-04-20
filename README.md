# create-gitlab-issues

Gitlab の issue を複数まとめて作るツールです。

CSV ファイルを読み込んで API を使って issue を登録します。

Gitlab の API バージョン v4 でのみ動作を確認しています。

## 事前準備

Haskell のビルドツールである [Stack][stack] をインストールする必要があります。

## 使い方

issue に登録する CSV ファイルを用意して以下のコマンドを実行します。

```shell
$ ACCESS_TOKEN=xxxx stack exec create-gitlab-issues-exe
```

※ xxxx には Gitlab のユーザ設定で発行した Private Access Token を設定してください

### CSV ファイルの書式

CSV ファイルは以下の書式で、issues.csv という名前でルートディレクトリに置いてください。

実際は Excel などで作ると楽だと思います。

1 行目のヘッダは必須です。

```csv
url,project,title,body
"https://gitlab.com","namespace/project_name","issue のタイトル","issue の本文"
"http://10.2.2.84","aoki/some_project","issue のタイトル","本文に
改行を入れたい場合は
そのまま改行を書く"
```

※ namespace にはユーザ名やグループ名などが入ります。

[stack]: https://docs.haskellstack.org/en/stable/README/
