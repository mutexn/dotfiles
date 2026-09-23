# エディタ（VS Code・Cursor）の設定

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `config/vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` | VS Code の設定 |
| `config/vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` | VS Code のキー割り当て |
| `config/vscode/extensions.txt` | なし（`./install.sh editor` が読む） | VS Code の拡張機能の一覧 |
| `config/cursor/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` | Cursor の設定 |
| `config/cursor/keybindings.json` | `~/Library/Application Support/Cursor/User/keybindings.json` | Cursor のキー割り当て |
| `config/cursor/extensions.txt` | なし（`./install.sh editor` が読む） | Cursor の拡張機能の一覧 |
| リポジトリに入れない | `~/Library/Application Support/Code/User/mcp.json` | AI ツールの接続設定。サービスのプロジェクト ID や認証情報を含むことがあるため |

エディタの設定画面で変更すると、リポジトリのファイルが書き換わる。コミット前に `git diff config/vscode config/cursor` で確認する。

各エディタに付いている設定の同期機能（VS Code の Settings Sync など）は使わない。この dotfiles で一元管理する。

## 設定の意味

### VS Code

| 設定 | 意味 |
| --- | --- |
| `claudeCode.preferredLocation: panel` | Claude Code の画面を、下のパネルに開く |
| `git.enableSmartCommit: true` | ステージしていない状態でコミットしたとき、変更をすべてコミットする |
| `git.autofetch: true` | GitHub の変更を定期的に取得する |
| キー割り当て `shift+enter`（ターミナル） | ターミナルで shift+enter を押すと改行を送る。Claude Code で複数行を入力するため |

### Cursor

| 設定 | 意味 |
| --- | --- |
| `git.autofetch: true` | GitHub の変更を定期的に取得する |
| `*.format.insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces` | JSX の `{ }` の内側に空白を入れて整形する |
| `editor.formatOnSave: true` | 保存時に整形する |
| `window.autoDetectColorScheme: false` と `workbench.preferred*ColorTheme` | macOS の外観に合わせてテーマを切り替えず、Cursor Dark を使う |
| キー割り当て `cmd+i` / `cmd+k` | AI の Agent モード / Chat モードを開く |

## 拡張機能

`extensions.txt` に、1 行に 1 つ拡張機能の ID を書く。`#` から始まる行は無視する。

```bash
./install.sh editor     # 一覧にあって入っていないものだけを入れる
./install.sh check      # 一覧どおりに入っているかを確かめる
```

拡張機能を追加・削除したら、一覧を書き直す。今入っているものは次で確認できる。

```bash
code --list-extensions
cursor --list-extensions
```

一覧にない拡張機能が入っていても、`install.sh` は消さない。
