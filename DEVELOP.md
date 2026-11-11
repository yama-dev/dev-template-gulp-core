# 保守と配布

## テンプレート生成

`.env`の`VERSION`を更新し、次を実行します。

```sh
make build
```

`make transform`はルートとテンプレートのバージョン、Gulpの入口、core参照とテンプレートlockfileのメタデータを同期します。
依存パッケージ自体の更新は行いません。
依存更新時は別途lockfileを更新し、auditと動作確認を実施してください。
`template/files.json`の`corefile`にはlockfileも含みます。
`template/master.zip`には更新済みのテンプレートとlockfileを同梱します。

元プロジェクトの1.16.0（`aa39b0a`）から標準ESM対応と依存解決結果を移植しています。
元作業ツリーには未追跡の`.dev/concat/`等があるため、`make rsync`による全面同期ではなく、コミット済み差分を確認して取り込んでください。

## 公開前後の確認

公開前は`npm pack`したcoreを一時プロジェクトにインストールし、テンプレートのGulp起動コマンドからBasic／EJS／Webpack／設定ファイル指定のビルドを確認します。
開発サーバーの応答とwatchによる再生成も確認します。

同梱lockfileのcore参照は、バージョン別ブランチ（現在は`v1.16.1`）を指定します。
`master`の`versions.json`で配布一覧を管理し、GitHub ReleaseとGitタグは作成しません。
他の依存は元lockfileの解決済みバージョンとintegrityを引き継いでいます。
ブランチ公開前のローカルパッケージによる検証は、リモートブランチからのインストール成功を保証しません。
ブランチ公開後は新しい作業ディレクトリでZIPを展開し、`package.json`と`package-lock.json`をコピーして次を確認してください。

```sh
npm ci
npm audit
npm run build -- --source basic/src/ --sourceBuild dist/
```

タグ作成、push、リリース公開は、明示的な依頼があった場合に実施します。

## 1.16.0の検証結果

2026年11月10日、Node.js 24.22.1とnpm 11.19.1で以下を確認しました。

- `make build`によるZIP生成と、ZIP内ファイルとテンプレートの一致。
- 全タスクと入口の`node --check`、`git diff --check`。
- `make transform`を再実行してもメタデータが変わらないこと。
- `npm pack`したcoreを一時プロジェクトへ配置した`npm ci --ignore-scripts --no-audit --no-fund`。
- `npm run build:basic`、`npm run build:ejs`、`npm run build:webpack`、`npm run build:webpack:config`。
- 配布用`basic/src/`を指定したビルド。
- BasicとWebpack構成のHTTP応答、およびSassとBabelのwatchによる再生成。
- `npm audit --json`の残件33件（High 14、Moderate 14、Low 5、Critical 0）。auditは残件があるため終了コード1です。

一時プロジェクトでは、core参照だけをローカルのtarballへ置き換えました。
依存のインストール時にはライフサイクルスクリプトを無効化しています。
開発サーバーの検証では、自動ブラウザー起動と通知を無効化し、127.0.0.1で動作確認しました。
ブラウザー画面、PHP、Twig、deploy、Webpackエントリー自体のwatchは未検証です。
ビルド時には既存依存に由来するSassのdefault importと`fs.Stats`の非推奨警告が残っています。


## 1.16.1の検証結果

2026年11月11日、Node.js 24.22.1とnpm 11.19.1で元プロジェクトの`edce963`を移植しました。
依存の追加や置換はなく、lockfileはバージョンとcore参照のみ更新しています。

- `make build`、ZIP内容の一致、`make transform`の冪等性、変更タスクの構文を確認しました。
- ローカルの`npm pack`を参照する一時プロジェクトで`npm ci --no-audit --no-fund`を実行しました。
- Basic／EJS／Webpack／設定ファイル指定と、配布用Basicのビルドが成功しました。
- Sassのdefault importに関する非推奨警告が出ないことを確認しました。
- PNG、JPEG相当、PDF相当、WOFF2相当、gzip、ZIP、全256バイト値を含む検証データで、コピー前後の完全一致を確認しました。
- ビルド済み出力をデプロイし、同じ7種類の完全一致を確認しました。出力先の入力だけを検証用に自動化しています。

画像やフォントとしてのデコードは検証していません。
PHP、Twig、開発サーバー、watchは今回の修正では再検証していません。
