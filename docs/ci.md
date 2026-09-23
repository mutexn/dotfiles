# CI（GitHub Actions）

master への push と、すべてのプルリクエストで自動的に動く。設定は `.github/workflows/ci.yml`。
結果はプルリクエストの画面と、リポジトリの Actions タブで見られる。

## 確かめていること

| ジョブ | 動く環境 | 内容 |
| --- | --- | --- |
| 文法・書式の検査 | Ubuntu | `install.sh` と `macos/defaults.sh` を shellcheck で検査（警告以上）。ステータスラインのスクリプトは文法エラーだけ。Karabiner と Claude Code の設定（JSON）、starship・mise・uv の設定（TOML）の書式 |
| 秘密情報の検査 | Ubuntu | gitleaks で、追加されたコミットにトークンや鍵などが含まれていないかを調べる |
| macOS での動作確認 | macOS | zsh の設定の文法、macOS 標準の bash 3.2 での `install.sh` の文法、Brewfile を Homebrew が読めるか、空のホームで `install.sh link` を 2 回実行して 2 回目に変更が起きないか、全ステップの dry-run |

## 確かめていないこと

- **実際のインストール。** `brew bundle` でアプリを入れる処理は時間がかかり、App Store アプリは Apple アカウントが必要なため行わない
- **`install.sh check`。** 実機の状態（入っているアプリ、ログイン状態など）を見る検査なので、手元で実行する
- **macOS の設定（`macos/defaults.sh`）の実行。** CI の Mac の設定を変えても意味がないため、dry-run だけ

## 安全のための設定

- **権限は読み取りだけ。** ワークフローはリポジトリに書き込めない（`permissions: contents: read`）
- **外部の部品はコミットの ID で固定。** `actions/checkout` と `gitleaks/gitleaks-action` は、バージョン名ではなく中身を特定する ID で指定している。
  部品の配布元が乗っ取られても、知らないうちに中身が差し替わらない。更新するときは、新しいリリースの ID に書き換える
- **認証情報を残さない。** checkout の `persist-credentials: false` で、GitHub のトークンを作業フォルダに残さない

## 失敗したとき

| ジョブ | よくある原因 | 対応 |
| --- | --- | --- |
| 文法・書式の検査 | シェルスクリプトの書き方、JSON・TOML の書き間違い | ログに出た行を直す。手元では `uvx --from shellcheck-py shellcheck --severity=warning install.sh` で同じ検査ができる |
| 秘密情報の検査 | トークンなどをコミットした | **そのトークンは失効させる**。コミットから消すだけでは不十分 |
| macOS での動作確認 | リンクの一覧に存在しないファイルを書いた、2 回目の link で変更が起きた | `install.sh` の `LINKS` と、リポジトリ内のファイルを見比べる |
