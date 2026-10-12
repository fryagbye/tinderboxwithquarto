# 未使用ユーザー属性 削除マニフェスト

対象: `Demo_TBX_for_Quarto.tbx`（`TinderboxWithQuarto-0.5.2.tbx` は未変更）

証拠スキャン: `scripts/attr_audit/audit_attributes.py` → `evidence-*.json`

## 削除: 153 属性 + 153 Attribute Note（付随ノート）

### QR_* (revealjs 未配線オプション)（121件）
- `QR_Ascii`
- `QR_AuthorMeta`
- `QR_AutoAnimateDuration`
- `QR_AutoAnimateEasing`
- `QR_AutoAnimateUnmatched`
- `QR_AutoPlayMedia`
- `QR_AutoSlide`
- `QR_AutoSlideStoppable`
- `QR_AutoStretch`
- `QR_Brand`
- `QR_Cache`
- `QR_CapLocation`
- `QR_Citeproc`
- `QR_CodeAnnotations`
- `QR_CodeBlockHeight`
- `QR_CodeCopy`
- `QR_CodeFold`
- `QR_CodeOverflow`
- `QR_CodeSummary`
- `QR_ControlsBackArrows`
- `QR_ControlsLayout`
- `QR_ControlsTutorial`
- `QR_CrossrefsHover`
- `QR_Date`
- `QR_DateMeta`
- `QR_DefaultTiming`
- `QR_DescriptionMeta`
- `QR_DisableLayout`
- `QR_Dpi`
- `QR_EmailObfuscation`
- `QR_EmbedResources`
- `QR_Error`
- `QR_Eval`
- `QR_ExtractMedia`
- `QR_FigAlign`
- `QR_FigCapLocation`
- `QR_FigDpi`
- `QR_FigFormat`
- `QR_FigResponsive`
- `QR_FigWidth`
- `QR_Filters`
- `QR_FragmentInUrl`
- `QR_Freeze`
- `QR_From`
- `QR_Grid`
- `QR_HashOneBasedIndex`
- `QR_HashType`
- `QR_Help`
- `QR_HideCursorTime`
- `QR_HideInactiveCursor`
- `QR_HtmlQTags`
- `QR_HtmlTableProcessing`
- `QR_Include`
- `QR_IncludeInHeader`
- `QR_Institute`
- `QR_IpynbFilters`
- `QR_IpynbShellInteractivity`
- `QR_JumpToSlide`
- `QR_KeepIpynb`
- `QR_KeepMd`
- `QR_Keyboard`
- `QR_Lang`
- `QR_LinkExternalIcon`
- `QR_Loop`
- `QR_MarginBottom`
- `QR_MarginLeft`
- `QR_MarginRight`
- `QR_MarginTop`
- `QR_MaxScale`
- `QR_MaxWidth`
- `QR_MetadataFiles`
- `QR_MinScale`
- `QR_MobileViewDistance`
- `QR_MouseWheel`
- `QR_Multiplex`
- `QR_NavigationMode`
- `QR_NumberDepth`
- `QR_NumberOffset`
- `QR_NumberSections`
- `QR_Output`
- `QR_OutputExt`
- `QR_OutputFile`
- `QR_Overview`
- `QR_Pagetitle`
- `QR_ParallaxBackgroundHorizontal`
- `QR_ParallaxBackgroundImage`
- `QR_ParallaxBackgroundSize`
- `QR_ParallaxBackgroundVertical`
- `QR_Pause`
- `QR_PdfMaxPagesPerSlide`
- `QR_PdfPageHeightOffset`
- `QR_PdfSeparateFragments`
- `QR_PlotlyConnected`
- `QR_PreloadIframes`
- `QR_PreviewLinks`
- `QR_QuartoRequired`
- `QR_ReferenceLocation`
- `QR_ResourcePath`
- `QR_Resources`
- `QR_RespondToHashChanges`
- `QR_RevealjsUrl`
- `QR_ScrollView`
- `QR_Scrollable`
- `QR_SelfContainedMath`
- `QR_Shortcodes`
- `QR_ShowSlideNumber`
- `QR_SlideLevel`
- `QR_SlideTitle`
- `QR_SlideTone`
- `QR_Smaller`
- `QR_StripComments`
- `QR_Subtitle`
- `QR_TblCapLocation`
- `QR_Template`
- `QR_TemplatePartials`
- `QR_Toc`
- `QR_TocDepth`
- `QR_TocTitle`
- `QR_Touch`
- `QR_ViewDistance`
- `QR_Warning`

### Q_* (旧Quarto属性)（8件）
- `Q_Bibliography_file`
- `Q_ChunkLangPrefix`
- `Q_DocumentClass_HTML`
- `Q_OnWorkingFolder`
- `Q_WebRAutoRun`
- `Q_WebRFigHeight`
- `Q_WebRFigWidth`
- `Q_WorkingFolder`

### GFM_* (markdownメタ)（3件）
- `GFM_author`
- `GFM_date`
- `GFM_title`

### Graphviz 残骸（2件）
- `GG_K`
- `G_BrewerColorSchemes`

### 値のみ保持されていた属性（4件）
- `MinDepth`
- `Mode`
- `TranslateOption`
- `UseWezterm`

### その他レガシー（15件）
- `Built`
- `ClassOption`
- `DocumentClass`
- `Editor`
- `IP_Address`
- `Jupyter`
- `Lang`
- `MAC_Addr`
- `MaxDepth`
- `PDF_Engine`
- `Package`
- `R_EditorType`
- `StockDisplayedAttribute`
- `SuffixForAttribute`
- `session_labels`

## 保持（削除対象外とした候補）

- `ColorExplain`, `GS_HasOutputStyle` — リリース版 .tbx の DisplayedAttributes/値に出現
- `QR_Fragments`, `QR_Attributes` — DisplayedAttributes 登録のみ・読み手なし（UI 項目として保持、要検討）

## 新たに配線した revealjs オプション（tFrontmatter_revealjs）

以下は削除せず frontmatter 出力に接続: `QR_AutoAnimate`; `QR_Center`; `QR_Chalkboard`; `QR_CodeLineNumbers`; `QR_Controls`; `QR_Echo`; `QR_Hash`; `QR_Height`; `QR_History`; `QR_Incremental`; `QR_Margin`; `QR_Menu`; `QR_Progress`; `QR_Theme`; `QR_Width`

併せて `pFrontmatterRevealjs` / `tFrontmatter_revealjs` の DisplayedAttributes に追加（QR_MermaidFormat も補完）。

## 残存参照（既知・無害）

- `MyList`/`MyDictionary`/`MyString`: デバッグ用スナップショット内に削除済み属性名が残る（再生成される情報、実害なし）
- `NLOrganizations`: NLP 抽出エンティティに1件

## 実行方法

1. `.tbx` バックアップ → Tinderbox 側でドキュメントを閉じる
2. XML 直接編集: `<attrib>` 定義153件削除、ノート上の `<attribute>` 値5件削除、孤児 Attribute Note 153アイテム削除（Edict による再生成防止のため必須）
3. `tFrontmatter_revealjs` の `<text>`/`<html>` に15オプション追加、DisplayedAttributes 更新
4. XML 整形式検証 + 属性数確認（473→320, アイテム1182→1029）

※ `deleteAttribute()` は Tinderbox 11.8 で未実装（呼び出しても属性が残存）。AppleScript `delete attribute` も無効のため XML 編集を採用。
※ Tinderbox 11.8.0 (b808) で `save` がアイテムを書き出さない事象を確認。復旧はバックアップから実施。