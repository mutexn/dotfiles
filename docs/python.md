# Python の管理方針（uv）

2026-09-23 決定。**Python は uv だけで管理する。mise は Node 専用にする。**

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `config/uv/uv.toml` | `~/.config/uv/uv.toml` | uv の全体設定 |
| なし | `~/.local/share/uv/python/` | uv が入れた Python 本体 |
| なし | `~/.local/bin/python`、`python3` | 既定の Python。uv が作るリンク |

### config/uv/uv.toml の意味

| 設定 | 意味 |
| --- | --- |
| `python-preference = "only-managed"` | uv は自分で入れた Python だけを使い、Homebrew や macOS 標準の Python を使わない。Homebrew の Python は `brew upgrade` で勝手に上がり、その上に作った仮想環境が壊れるため |

## 役割分担

| 対象 | 管理するもの | 固定する場所 |
| --- | --- | --- |
| Python 本体のバージョン | uv | `.python-version` と `pyproject.toml` の `requires-python` |
| 仮想環境（`.venv`） | uv | 自動で作られる。コミットしない |
| パッケージ | uv | `pyproject.toml` と `uv.lock`（コミットする） |
| 単発で使う Python 製コマンド | uv | `uvx ruff` のように都度実行。常用するものは `uv tool install` |
| Node | mise | `mise.toml`（[mise.md](mise.md)） |

Homebrew の `python@3.14` は、mlx・ollama・ranger が依存しているため残る。
これは Homebrew のツール専用とし、プロジェクトでは使わない。

## mise と uv を組み合わせる方法との比較

「Python 本体は mise で入れ、パッケージは uv で管理する」という組み合わせも広く紹介されている。
mise には、フォルダに入ると uv の仮想環境を自動で作って有効にする機能もある。
それでも uv 単独を選んだ理由は次のとおり。

| 観点 | uv 単独（採用） | mise + uv |
| --- | --- | --- |
| Python のバージョン指定 | `.python-version` と `requires-python` だけ | `mise.toml` にも書くため、指定が 2 か所になりずれやすい |
| 入る Python 本体 | python-build-standalone | 同じ python-build-standalone。品質の差はない |
| チームメンバー・CI・Docker | uv だけ入れれば同じ手順で動く。公式の GitHub Action や Docker イメージもある | mise も入れる必要がある |
| 仮想環境の有効化 | `uv run` で実行すれば有効化は不要 | cd するだけで有効になる |
| 覚えること | uv のコマンドだけ | mise と uv の両方の設定 |

mise + uv の利点は「cd するだけで仮想環境が有効になる」ことにほぼ尽きる。
この利点は `uv run` を使う習慣か、既に入っている direnv で代わりが効く。
一方で、バージョン指定が 2 か所に分かれる欠点は、2026-07 の pnpm 障害と同じ種類の問題
（複数の道具が同じものを管理して食い違う）を招きやすい。そのため 1 つの道具に任せる。

### 仮想環境を自動で有効にしたいとき

プロジェクトに `.envrc` を置き、`direnv allow` する。

```bash
# .envrc
source .venv/bin/activate
```

## よく使うコマンド

```bash
# 新しいプロジェクト
uv init myproject && cd myproject
uv python pin 3.14          # .python-version を作る
uv add requests             # パッケージを追加（pyproject.toml と uv.lock を更新）
uv run python main.py       # 仮想環境で実行（有効化は不要）

# 既存プロジェクトを clone したとき
uv sync                     # uv.lock どおりに .venv を作る

# requirements.txt だけのプロジェクト
uv venv                     # .venv を作る（.python-version があればそのバージョン）
uv pip install -r requirements.txt

# requirements.txt から pyproject.toml へ移す
uv init --bare
uv add -r requirements.txt

# Python 本体
uv python list --only-installed   # 入っている Python
uv python install 3.13            # 別のバージョンを追加
uv python install 3.14 --default  # 既定の python / python3 を切り替える
```

`--default` は uv ではまだ試験的な機能。実行すると警告が出るが、動作に問題はない。

## この Mac の状態（2026-09-23 時点）

| Python | 状態 |
| --- | --- |
| uv の 3.14.2 | 既定の `python` と `python3` |
| uv の 3.13.5、3.11.14 | 入っている。プロジェクトの指定に応じて使われる |
| Homebrew の python@3.14 | Homebrew のツール専用。`/opt/homebrew/bin/python3` にあるが、PATH で uv の方が先に使われる |
| Homebrew の python@3.13 | 2026-09-23 に削除 |
| mise | Python は管理しない |

### 対応が残っているもの

- **gini-slides の `.venv`**：Homebrew の Python 3.14 で作られている。上の「requirements.txt だけのプロジェクト」の手順で作り直す
- **uv 本体が古い**：Homebrew の uv は 0.9.18（2025-12）。そのため Python も 3.14.2 までしか入らない。`brew upgrade uv` のあと `uv python install 3.14 --default` で最新にできる

## 確認コマンド

```bash
which -a python3     # 先頭が ~/.local/bin/python3 なら正常
python3 --version
uv python find       # uv が使う Python
```
