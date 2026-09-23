# Homebrew と Brewfile

## Brewfile とは

`Brewfile` は、Homebrew で入れるものの一覧。`brew bundle` がこの一覧どおりにインストールする。

| 書き方 | 意味 | 例 |
| --- | --- | --- |
| `brew "名前"` | コマンドラインツール（formula） | `brew "mise"` |
| `cask "名前"` | GUI アプリやフォント（cask） | `cask "ghostty"` |
| `mas "名前", id: 数字` | App Store のアプリ。`mas` コマンド経由で入れる | `mas "LINE", id: 539883307` |

どのアプリを入れているか、なぜ入れているかは [apps.md](apps.md) にまとめる。

## よく使うコマンド

```bash
brew bundle --file=Brewfile            # 一覧にあるものをすべて入れる（./install.sh bundle と同じ）
brew bundle check --file=Brewfile      # 一覧のものがすべて入っているか確認
brew bundle cleanup --file=Brewfile    # 一覧にないのに入っているものを表示（削除はしない）
brew bundle cleanup --file=Brewfile --force   # 一覧にないものを削除する。実行前に必ず上のコマンドで確認
```

## 運用ルール

1. 新しいアプリは、まず `brew install` で入れて試す
2. 使い続けると決めたら、`Brewfile` に 1 行と用途のコメントを追加し、[apps.md](apps.md) に理由を書く
3. やめるときは `brew uninstall` し、`Brewfile` から行を消し、apps.md に理由を残す
4. ときどき `brew bundle cleanup` で、一覧と実機がずれていないか確認する

## Homebrew の場所

Apple Silicon の Mac では `/opt/homebrew` に入る。PATH への追加は `home/zprofile` の
`brew shellenv` が行う（[zsh.md](zsh.md)）。Intel Mac 時代の `/usr/local` ではない。

## Homebrew で入れないもの

| アプリ | 入れ方 |
| --- | --- |
| e-Gov 電子申請、e-Tax、JPKI 利用者ソフト、ELPKI | 各公式サイトから手動でダウンロード |
| Adobe Illustrator / Photoshop | Creative Cloud アプリから |
| DevKinsta、ovice | 公式サイトから手動でダウンロード |

### 公式のインストーラで入れるコマンド

| コマンド | 入れ方 | 理由 |
| --- | --- | --- |
| Claude Code | `install.sh runtime` が公式インストーラで入れる | 自動で更新されるため（[claude.md](claude.md)） |
| pnpm | `install.sh runtime` が公式インストーラで入れる | standalone 版を使う方針のため（[mise.md](mise.md)） |
| Cursor の CLI（`cursor-agent`） | 必要なときに手動で `curl https://cursor.com/install -fsS \| bash` | ほとんど使わないため、`install.sh` には入れていない |
| Volta | 入れない（この Mac にだけ残っている） | 旧プロジェクト用。新しい Mac では使わない |
