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

同梱lockfileのcore参照には、まだ公開していないコミットSHAを捏造せず、公開予定タグ`v1.16.0`を指定しています。
タグは公開後に付け替えないでください。
他の依存は元lockfileの解決済みバージョンとintegrityを引き継いでいます。
タグ公開前のローカルパッケージによる検証は、リモートタグからのインストール成功を保証しません。
タグ公開後は新しい作業ディレクトリでZIPを展開し、`package.json`と`package-lock.json`をコピーして次を確認してください。

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
