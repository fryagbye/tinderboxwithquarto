# Introduction

This tinderbox file supports creating a book with [Quarto](https://quarto.org/).

You can make qmd files and _quarto.yml easily with it. 
Here is an example of books created with Quarto.

* [R for Data Science (2e)](https://r4ds.hadley.nz/)(@Wickham2016Data)

# Usage environment

Please refer to the output results of `quato check`.

* quarto is using the released version 1.5.57.
* R is version 4.4.0
* I use luaLatex for output in Japanese. I have installed MacTex because TinyTex doesn't include it.
* It may be better to uninstall TinyTex.
* I have set it to use `lightbox` extension ( included in Quarto v1.4+.)


```{.sh}
# Quarto check output
Quarto 1.5.57
[✓] Checking versions of quarto binary dependencies...
      Pandoc version 3.2.0: OK
      Dart Sass version 1.70.0: OK
      Deno version 1.41.0: OK
      Typst version 0.11.0: OK
[✓] Checking versions of quarto dependencies......OK
[✓] Checking Quarto installation......OK
      Version: 1.5.57
      Path: /Applications/quarto/bin

[✓] Checking tools....................OK
      TinyTeX: (not installed)
      Chromium: (not installed)

[✓] Checking LaTeX....................OK
      Using: Installation From Path
      Path: /usr/local/texlive/2024/bin/universal-darwin
      Version: 2024

[✓] Checking basic markdown render....OK

[✓] Checking Python 3 installation....OK
      Version: 3.12.7
      Path: /Users/tk4o2ka/github/tinderboxwithquarto/.venv/bin/python3
      Jupyter: 5.7.2
      Kernels: python3

[✓] Checking Jupyter engine render....OK

[✓] Checking R installation...........OK
      Version: 4.4.0
      Path: /Library/Frameworks/R.framework/Resources
      LibPaths:
        - /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library
      knitr: 1.46
      rmarkdown: 2.26

[✓] Checking Knitr engine render......OK
```


## RStudio Session information

```{.r}
#| echo: false
sessionInfo()
```

Platform: aarch64-apple-darwin20
Running under: macOS 15.1.1

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: Asia/Tokyo
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
[1] compiler_4.4.0 tools_4.4.0   

## Installed packages

```{.r}
#| echo: false
#| message: false
pacman::p_load(tidyverse, gt)
installed.packages() |> 
  as_tibble() |> 
  select(Package, Version, Built) |> 
  gt::gt()
```

|Name|Version|Built|
|----|-------|-----|
|askpass|1.2.0|4.4.0|
|backports|1.4.1|4.4.0|
|base|4.4.0|4.4.0|
|base64enc|0.1-3|4.4.0|
|bigD|0.2.0|4.4.0|
|bit|4.0.5|4.4.0|
|bit64|4.0.5|4.4.0|
|bitops|1.0-7|4.4.0|
|blob|1.2.4|4.4.0|
|boot|1.3-30|4.4.0|



# Setting

1. Setting up with "TBXConfig" note

    You need to change values of the following "TBXConfig" attributes for configuration.

* `$Indent_Charactor` -> Set the symbol that represents the depth of indentation. (default value = ★)
* `$ExList` -> List of notes excluded from cross-reference search ( default value = "List and Agent etc")
* `$ExportFolder` -> path of exported files. ( for Stamp "Move qmd files")
* `$Q_TableOfContainsNoteName` -> **$Path** of TOC note. ( default value = /Table of Contents)

2. Making a `_quarto.yml`

    You can change values of  attributes of  "_quarto" note to change quarto options. The quarto options are attributes that starts with "Q" in this file.
The initial setting specified in `_quarto.yml` is for Japanese output.

    Please refer [Quarto Book Structure](https://quarto.org/docs/books/book-structure.html) and [PDF Basics](https://quarto.org/docs/output-formats/pdf-basics.html) in detail.

    If you use [Custom Translations](https://quarto.org/docs/authoring/language.html#custom-translations), you need to make `$Q_Has_Language_YML` `true` and set `$Q_Language_YML` for the filename.
"_language" note in this file is for translating to japanese.

3. Changing `_common.R` file. ( optional )

    You can set up `knitr` package options for R chunk.  
    

# Make notes

1. Make notes with Prototype pNote and pSubnote

    pNote is for Sections and pSubnote is for Subsections.
Please set the Prototype of pNote to level 1 and pSubnote below level.
 * When creating a note, please enter "#pNote" or "#pSubnote" following the title. (or apply the pNote Prototype or pSubnote to notes you make )

    e.g. Note title -> わが輩は猫である#pSubnote

     * The note title (`$Name`) is the header for pNote or pSubnote.
 * Depending on the hierarchy level, the level of the header also changes.

     e.g. If the title of pSubnote in level 2 depth is "わが輩は猫である", it will be output as follows when exporting.

     > \#\# わが輩は猫である

2. Index file settings

    In the quarto book format, **only one index.qmd is required**,  `$IsIndexqmd` of index.qmd is set to `true`.




# Rename HTMLExportFileName of a note with translation (Optional)

There is  a stamp **"Rename in English"** that translates the Japanese title (`$Name`) into English and automatically sets `$HTMLExportFileName` [^translate-shell]. and you can sets `$SectionLabel` with stamp "Set: Section Label". The labels of the section cannot be duplicated, so please modify them manually if necessary. In addition, you can change the language to be translated with `$Rename_in` in the TBX configuration note (**TBXConfig**). ( By default, from Japanese to English).

[^translate-shell]: [Translate-shell](https://github.com/soimort/translate-shell) installation required. 
```{.sh}
>brew install translate-shell
```

# Part in Book format

For Part, please refer to [Quarto's "Book Structure" reference](https://quarto.org/docs/books/book-structure.html).

pNote is compatible with quarto's **Part** or **Chapter**.

If pNote is at the bottom of pNote, the top pNote will be Part (Part ○), and the lower pNote will be Chapter (Chapter ○). You can place pNote at hierarchical level 2 only if you are under pNote of hierarchy level 1. In this case, the hierarchy level and header level are one different, so the header level is set based on the user attribute `$OutlineDepthBase`.

pNote, which is treated as a Part, is turned on (`true`) for `$Is_Part_qmd`. The lower pNote contains the export file name (e.g. filename.qmd) of the pNote, which is Part, in `$Part_file`.
If a Part note is empty, only the title (`$Name`) of the note is reflected in _quarto.yml, as shown in the **"Dice"** in the example below. 
If the dice.qmd is not empty, the part title (as a level one header) as well as some introductory content for the part. 

```{.yml} 
#_quarto.yml
chapters:
  - index.qmd
  - preface.qmd
  - part: "Dice" # if $Text("Dice").wordCount == 0 
  chapters: 
    - basics.qmd
    - packages.qmd
```


```{.yml}
#_quarto.yml
chapters:
  - index.qmd
  - preface.qmd
  - part: dice.qmd # if $Text("Dice").wordCount >0 
    chapters: 
      - basics.qmd
      - packages.qmd
```

The figure below shows the export example when Part is supported and the output result of _quarto.yml.

![Folder configuration at the time of output and _quarto.yml](./screenshots/tree01.png)



# Cross-Reference using Ziplink

In Quarto, labeled diagrams, tables, etc. can be mutually quoted. Automatically (or manually) collect some labels in the **Tinderbox** file at the bottom of the **Reference List** note.[^regrex]
Convert it to a quoteable title (citation name starting with @) and create a note for the corresponding part. **Tinderbox**'s **Ziplink** function [^ziplink] is a function for easily pasting links to notebooks. It is diverted to make it easy to enter the quoted name. This makes it relatively easy to find and enter the quoted label even if the number increases.。

[^regrex]: The diagrams and tables are extracted in regular expressions.

[^ziplink]: Please refer to "Text link creation via the Ziplinking method" in [A Tinderbox Reference File](https://acrobatfaq.com/atbref10/index/Automating_Tinderbox/Coding/Links/Text_Links/Text_link_creation_via_the_Ziplinking_method.html).(@Anderson2024Tinde)

## How to set the label of the diagram



### R chunk

Automatically recognize and collect R chunk labels in the following format (#| labe: fig-xxx-ooo, etc.). The method of specifying a label in the curly bracket ({r fig-xxx-ooo}) is not supported. In the following example, you can quote **\@fig-airquality**.

```{.r}
#| label: fig-airquality 
#| fig-cap: "Temperature and ozone level."
#| warning: false

library(ggplot2)

ggplot(airquality, aes(Temp, Ozone)) + 
  geom_point() + 
  geom_smooth(method = "loess")
```

![label: \@fig-airquality](./_bookhtml/cross-reference-using-ziplink_files/figure-html/fig-airquality-1.png)


### Image link in markdown format

Recognize and collect labels in format that extend the markdown.

\!\[Test image](screenshots/toolbar.png){#fig-test fig-alt="test" fig-align="left" width=100%}

![label:@fig-test](screenshots/toolbar.png){#fig-test fig-alt="test" fig-align="left" width=100%}


## How to set the label of the table

There are multiple ways to specify labels, but they are only supported if it is a table in markdown format and the label name is above, as shown in the example below.[^table-cross-ref]

[^table-cross-ref]: For other formats, please refer to [quarto cross-reference](https://quarto.org/docs/authoring/cross-references.html#tables).

```{.txt}
:明度・彩度の修飾子(label:@tbl-brightness ) {#tbl-brightness-saturation}
 
|項目|効果|
|----|------------|
|dark|暗くする|
|darker|より暗くする|
|darkest|最も暗くする|
|light| 明るくする|
```


## How to quote

If you enter two square brackets "[[", the list will be displayed, so please enter a part of the label name. As the candidates are narrowed down, select the citation label you want to enter.


|Types of quotations  |Lable  |Quote|
|---|---|---|
|Chapter, Section etc.   |#sec-   |\@sec-|
|Figure   |#\| label:    |\@fig-|
|Chart　|#tbl-|\@tbl-|

## Restrictions on quoted labels

* The label before change or deletion remains because it cannot be detected even if the quoted label name is changed or deleted.
* Cross-ref detection is carried out by regular execution. If it is executed in the middle of input, it will be duplicated with a short label.

In this case, if necessary, delete the quoted label name in Stamp and perform the detection manually by following the steps below.

1. Make: Clear Cross-Reference List（Delete all citation labels under the Reference List.）
2. Make: Cross-Reference List（Re-detect the quoted label.）




## Dummy links for cross-reference (optional)

You can create dummy links showing where each cross-reference, starting with the @ symbol in the section, figure, and table label lists, is cited.

1. execute "Make: Dummy Link Data For Cross-Reference" stamp
2. select cross-ref label notes ( start with "@" ) and  execute "Make: Dummy Link between Reference and Selected notes" stamp.

# Export

1. Export `_quarto.yml`

    You can change output format "pdf" or "html"  with the stamp "Change quarto.yml template".
If you use a _language.yml, you export "_language" note (optional. See  @sec-setting Setting)


2. Export  `.qmd` files ( pNote notes only)

    The pSubnote at the bottom of pNote at the time of output is all output as one qmd file in the state contained when pNote is exported. Therefore, it is OK to export by selecting only pNote to output. In addition, pSubnote does not require output, but if you export, it is set to output as a text file (extension .txt).

    If you select the pNote notes below "For Export" and output it ( @fig-before ), then execute the "Move qmd files" stamp, you can move (or overwrite) the qmd file directly to the export(project) folder ( @fig-after ) . This is a method to avoid having to consider the folder structure when referencing image files with a relative path.

::: {#fig-move-qmd layout-ncol=2}

![Before](screenshots/folder01.png){#fig-before}

![After](screenshots/folder02.png){#fig-after}

qmd files are moved to project path by stamp
:::

3. preview html output.( optional )

    ```{.sh}
# preview for only html output
> quarto preview index.qmd --to html --no-watch-inputs --no-browse
```

4. render pdf or html.

    ```{.sh}
> quarto render
```

    you can use RStudio for preview and render.

# Example

[Example PDF](https://github.com/fryagbye/tinderboxwithquarto/blob/main/_bookpdf/Tinderbox-file-for-Quarto.pdf)

# References

::: {#refs}
:::

# Restrictions

It seems that the section label customization function cannot be used in the latest release [ref. Cross-references on unnumbered pages fail (PDF) or are mislabeled (HTML)](https://github.com/quarto-dev/quarto-cli/issues/5946). 

If you turn on `$IsUnnumbered` and `$HasSectionLabel`, the display of the quote will be fixed to the number + title, so please turn off `$IsUnnumbered`.

