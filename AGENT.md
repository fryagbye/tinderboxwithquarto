# AGENT.md — プロジェクト技術仕様 ＆ 開発ガイドライン

このドキュメントは、本プロジェクトの具体的な技術スタック、構造、命名規則、および制約事項をまとめたものです。開発用サブエージェントを立ち上げる際、コンテキストとして最優先で読み込ませてください。

## 1. プロジェクト概要
- **プロジェクト名**: tinderboxwithquarto
- **主要目的**: Quarto と Tinderbox を用いた研究開発・情報管理プロジェクト。

## 2. 技術スタック ＆ ツールチェーン
- **言語**: Python, Tinderbox ActionCode, Tinderbox ExportCode, AppleScript
- **主要フレームワーク / ライブラリ**: Vite/Vanilla HTML5
- **データベース / ストレージ**: Not specified
- **パッケージマネージャー**: uv
- **ビルド・デプロイ環境**: GitHub Actions
- **プロジェクト種別**: General Software Project
- **能力ヒント**: None detected yet

## 2.1 能力棚卸し
**能力インベントリ**:
- Nanobanana skill: Not detected in global skills. If image generation is required, install or expose the Nanobanana skill/plugin before asset production.
- Second-opinion skill: Generated locally by this setup. Global second-opinion skill was not detected.
- Capability hints: None detected yet
**CLIインベントリ**:
- Claude CLI: not detected
- Codex CLI: not detected
- Antigravity/Gemini CLI: /Users/tk4o2ka/.local/bin/agy
- 不足能力の導入判断は `.agents/plugins/project-agent-kit/skills/capability-discovery-skill/SKILL.md` に従い、公式ドキュメント確認、固定バージョン、pnpm/uv 置換、導入しない理由を残してください。
- 画像、OGP、アイコン、スプライト、透過処理は `.agents/plugins/project-agent-kit/skills/asset-pipeline-skill/SKILL.md` を使い、Nanobanana が利用可能か確認してから実施してください。
- Webサービス提供に必要な OGP/SEO/DB/Auth/Deploy/Smoke Test は `.agents/plugins/project-agent-kit/skills/web-service-readiness-skill/SKILL.md` を参照してください。
- DB/Storage の採否やマイグレーションは `.agents/plugins/project-agent-kit/skills/db-setup-skill/SKILL.md` で判断と検証を記録してください。
- 運用品質は `.agents/plugins/project-agent-kit/agents/quality-systems-specialist.md` と、Security/Privacy、Observability、Test Strategy、Environment/Secrets、Release/Store、Accessibility の各 Skill を使って確認してください。

## 3. ディレクトリ構造
```text
.
├── Chunk List/
├── Document Commons/
├── Export Agent/
├── Graphviz/
├── Hints/
├── Mermaid Flowchart/
├── Prototypes/
├── References DB/
├── Rscript/
├── Templates/
├── _extensions/
├── antigravity-project-setup/
├── citation/
├── myproject/
├── myrevealjs/
├── myrevealjs2/
├── output/
├── output_files/
├── renv/
└── test/
```

## 4. コーディング規約 ＆ 命名規則
- **ファイル命名**: snake_case (e.g. main_handler.py)
- **変数・関数命名**: snake_case for variables, PascalCase for classes
- **アーキテクチャパターン**: Feature-based modular architecture
- **状態管理・データフロー**: Context APIs or local hooks, minimizing global state pollution

## 5. 依存関係 ＆ 禁止事項
- **禁止されているライブラリ/パッケージ**: Any package without explicitly specified fixed versions in package.json/lockfile
- **その他の技術的制約**:
  - `No specific custom constraints.`
  - 外部APIへの直接呼び出しは避け、必ず定義されたラッパーモジュールを経由すること。
  - テストコードは本番環境や外部接続に依存せず、冪等性を担保してモックやインメモリDB等で動作するように設計すること。

## 6. セカンドオピニオンレビュー方針
- 状態遷移、非同期の排他制御、認証、データ暗号化など、潜在バグや脆弱性が深刻な影響を及ぼす箇所を変更した場合、または実装方針の確信度が 99% 未満の場合は、自律的に `.agents/plugins/project-agent-kit/skills/second-opinion-skill/SKILL.md` を読み込んで実行してください。
- 外部 CLI（Claude CLI, Codex CLI）を活用して独立レビューを取得し、結果を `git diff` 等と照らし合わせて、[CRITICAL / WARNING / INFO] の重要度ごとに修正などの PDCA サイクルを回してください。

この仕様書に基づき、一貫性のある高品質なアーキテクチャを維持してください。
