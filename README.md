# dev-template-gulp-core

Webサイト制作用のGulpタスクと配布テンプレートです。

## 1.16.0

- Node.js 24.22.1以上の24系を対象にします。テンプレートのVolta指定は24.22.2です。
- Gulpの入口を`gulpfile.esm.js`から`gulpfile.mjs`へ変更しました。
- 外部`esm`パッケージを削除し、`.dev/`をNode標準ESMで実行します。
- CommonJS形式のWebpack設定は`createRequire`で読み込みます。
- テンプレートに`package-lock.json`を同梱し、元プロジェクト1.16.0の依存解決結果を引き継ぎます。

## 利用先の更新

1. Node.jsを対応する24系へ更新します。
2. core参照を`yama-dev/dev-template-gulp-core.git#v1.16.0`へ変更します。
3. 各npm scriptの`--gulpfile`を`node_modules/@yama-dev/dev-template-gulp-core/gulpfile.mjs`へ変更します。
4. `esm`を依存宣言から削除し、`npm install`で利用先のlockfileを更新します。
5. ビルド、開発サーバー、watchを確認します。

新規作成時は、配布テンプレートの`package.json`と`package-lock.json`を両方コピーし、タグ公開後に`npm ci`でインストールします。
既存プロジェクトでは独自の依存を維持し、同梱lockfileで上書きせず、更新結果を確認してください。
本対応は脆弱性の全解消を保証するものではありません。
利用先の依存構成で`npm audit`を確認してください。

保守と配布の手順は[DEVELOP.md](DEVELOP.md)を参照してください。
