
# Introduction

This Tinderbox file supports creating a book, manuscript (beta), revealjs with [Quarto](https://quarto.org/).

[Tinderbox file for Quarto (Web version)](https://fryagbye.quarto.pub/tinderbox-file-for-quarto/)

You can easily make qmd files and _quarto.yml with it. 
Here is an example of books created with Quarto.


* [R for Data Science (2e)](https://r4ds.hadley.nz/)(@Wickham2016Data)

You can preview Rchunk and Graphs (Mermaid Flowchart and Graphviz)  in Tinderbox.

[![Tinderbox with Quarto part1](screenshots/youtube_opening.png)](https://youtu.be/4BEroHg-F8Y)

My Workflow is @fig-workflow-graphviz.
<br>


```dot
//| label: fig-workflow-graphviz
//| fig-cap: Tinderbox Work Flow with Quarto. ( Graphviz version )
//| fig-width: 5
digraph {
    layout=dot
    compound=true
    graph [charset = "UTF-8" splines = "spline" ];
subgraph cluster_A{
                                label="Applications"
                                spline="curved"
                                color="#000000"
                                penwidth="1"
                                style="filled"
                                fillcolor="#e7f3e7"
                                fontcolor="#000000"
                A B 

                subgraph cluster_B{
                                    label="Tinderbox"
                                    color="#000000"
                                    penwidth="1"
                                    style="filled"
                                    fillcolor="#f6e04d"
                                    fontcolor="#000000"
                                    URL="https://www.eastgate.com/Tinderbox/"


                subgraph cluster_C{
                                        label="Demo_TBX_for_Quarto.tbx"
                                        color="#000000"
                                        penwidth="1"
                                        style="filled"
                                        fillcolor="#ffffff"
                                        fontcolor="#000000"
                                        URL="https://github.com/fryagbye/tinderboxwithquarto"
                C D E 
}

}

}

subgraph cluster_D{
                                label="Quarto"
                                color="#000000"
                                penwidth="1"
                                style="filled"
                                fillcolor="#fff4e6"
                                fontcolor="#000000"
                F G H 
}

subgraph cluster_E{
                                label="Output"
                                color="#000000"
                                penwidth="1"
                                style="filled"
                                fillcolor="#ffffff"
                                fontcolor="#000000"
                I J K 
}


A [ style="filled"  label="Bookends" color="#000000", penwidth="1", fillcolor="#fcbd63", fontcolor="#000000", URL="https://www.sonnysoftware.com/bookends-for-mac"]
B [ style="filled"  label="Snippety" color="#990000", penwidth="1", fillcolor="#5c9dfe", fontcolor="#000000", URL="https://snippety.app/"]
C [ style="filled"  label="Mermaid" color="#000000", penwidth="1", fillcolor="#c735e9", fontcolor="#ffffff", URL="https://mermaid.js.org/"]
D [ style="filled"  label="Graphviz" color="#000000", penwidth="1", fillcolor="#30638d", fontcolor="#ffffff", URL="https://graphviz.org/"]
E [ style="filled"  label="Preview \nwith Rscript" ]
F [ style="filled"  label="R Studio" color="#000000", penwidth="1", fillcolor="#80a9d7", fontcolor="#000000", URL="https://posit.co/products/open-source/rstudio/"]
G [ style="filled"  label="RMarkdown ( .qmd )" color="#000000", penwidth="1", fillcolor="#74bbff", fontcolor="#000000"]
H [ style="filled"  label="quarto CLI" color="#000000", penwidth="1", fillcolor="#74bbff", fontcolor="#000000", URL="https://quarto.org/"]
I [ style="filled"  label="Book" color="#000000", penwidth="1", fillcolor="#93dd93", fontcolor="#000000"]
J [ style="filled"  label="Manuscript" color="#000000", penwidth="1", fillcolor="#93dd93", fontcolor="#000000"]
K [ style="filled"  label="revealjs" color="#d53f8c", penwidth="1", fillcolor="#f2e142", fontcolor="#000000"]

A -> C [fillcolor="#cbd9d7" fontcolor="#000000" lhead = "cluster_C" ltail = "cluster_A" ]
B -> E [fillcolor="#cbd9d7" fontcolor="#000000" lhead = "cluster_C" ]
D -> G [fillcolor="#cbd9d7" fontcolor="#000000" lhead = "cluster_D" ltail = "cluster_C" ]
F -> H [label = "Call" fillcolor="#cbd9d7" fontcolor="#000000" ]
G -> F [label = "Read qmd files" fillcolor="#cbd9d7" fontcolor="#000000" ]
G -> H [label = "Call" fillcolor="#cbd9d7" fontcolor="#000000" ]
H -> I [label = "Export" fillcolor="#cbd9d7" fontcolor="#000000" ]
H -> J [label = "Export" fillcolor="#cbd9d7" fontcolor="#000000" ]
H -> K [label = "Export" fillcolor="#cbd9d7" fontcolor="#000000" ]
}
```









# Usage environment

Please refer to the output results of `quato check`.


* Quarto is using the released version 1.7.13 (pre-release)[^noteinstallversion].



* R is version 4.4.2.



* I use luaLatex for output in Japanese. I have installed MacTex because TinyTex doesn't include it.



* It may be better to uninstall TinyTex.



* I have set it to use the `lightbox` extension ( included in Quarto v1.4+.).

*I have set it to use the `quarto-live` extension for revealjs. ([quarto live](https://github.com/r-wasm/quarto-live))

[^noteinstallversion]:~~Since the old headless mode has been removed from Chrome 132, Quarto v1.7.13 or later is required.~~

`quarto check` 
<details>

```{.zsh}
# Quarto check output
Quarto 1.7.13

[✓] Checking environment information...

      Quarto cache location: /Users/tk4o2ka/Library/Caches/quarto

[✓] Checking versions of quarto binary dependencies...

      Pandoc version 3.4.0: OK
      Dart Sass version 1.70.0: OK
      Deno version 1.46.3: OK
      Typst version 0.11.0: OK

[✓] Checking versions of quarto dependencies......OK


[✓] Checking Quarto installation......OK

      Version: 1.7.13
      Path: /Applications/quarto/bin

[✓] Checking tools....................OK

      Chromium: 869685
      TinyTeX: (not installed)

[✓] Checking LaTeX....................OK

      Using: Installation From Path
      Path: /usr/local/texlive/2024/bin/universal-darwin
      Version: 2024

[✓] Checking Chrome Headless....................OK

      Using: Chrome found on system
      Path: /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
      Source: MacOS known location

[✓] Checking basic markdown render....OK


[✓] Checking Python 3 installation....OK

      Version: 3.13.2
      Path: /opt/homebrew/opt/python@3.13/bin/python3.13
      Jupyter: (None)
      Jupyter is not available in this Python installation.
      Install with python3 -m pip install jupyter
      There is an unactivated Python environment in .venv. Did you forget to activate it?

[✓] Checking R installation...........OK

      Version: 4.4.2
      Path: /Library/Frameworks/R.framework/Resources
      LibPaths:
        - /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library
      knitr: 1.49
      rmarkdown: 2.29

[✓] Checking Knitr engine render......OK

```

</details>



















# Setting



1. Setting up with "TBXConfig" note


![User Attributes in TBXConfig](screenshots/TBXConfig01.png)

    You need to change the values of the following "TBXConfig" attributes for configuration.


* `$Indent_Charactor` → Set the symbol representing the depth of indentation. ( default value = ★ )



* ~~`$ExList` → List of notes excluded from cross-reference search ( default value = "List and Agent etc" )~~



* `$ProjectContainer`  →  Book Project Path for CrossRef Search and Label Lists 


![Project Contaier Example](screenshots/BookProjectContainerExample.png){#fig-projectcontaierexample fig-alt="Project Contaier Example" fig-align="left" width=80%}  



* `$ExportFolder` → Path of exported files.


![Export Folder Setting](screenshots/exportfoldersetting.png){#fig-exportfoldersetting fig-alt="Export Folder Setting" fig-align="left" width=50%}



* `$ToggleTOC` → Toggle for Generating TOC. ( default value = false ) You can use quarto option for TOC in _quarto.yml. 



* `$Q_TableOfContainsNote` → **$Name** of TOC note. ( default value = Table of Contents )



* `$Rename_in` → [`translate-shell`](https://github.com/soimort/translate-shell) option setting `[SOURCES]:[TAGETS]. ( default value = ja:en )



* `$Q_PDFEngine` → Setting for [pdf engine](https://quarto.org/docs/output-formats/pdf-engine.html) This file is tested only with lualatex. ( default value = lualatex )



* ~~`$OutlineBaseControl` → Adjustment of section levels in Markdown. ( default = 1 )~~

    `$OutlineBaseControl` is enabled in Manuscript and revealjs project. This attribute is used in pSubfolderManuscript and pSubfolderRevealjs note.
     e.g. 


    * $OutlineBaseControl = 1 → \#\# Title

    


    * $OutlineBaseControl = 1 → \# Title 



* `$RScriptLibraryPath` → R Library Resource Path ( default Value )

    ![Rscript Library Path](screenshots/RscriptLibPath.png){#fig-rscript-libpath fig-alt="Rscript Library Path" fig-align="left" width=80%}
	


2. Making a `_quarto.yml`

    You can change the values of attributes of the "_quarto" note to change quarto options. The quarto options are attributes that start with "Q" in this file. The initial setting specified in `_quarto.yml` is for Japanese output. Please refer to [Quarto Book Structure](https://quarto.org/docs/books/book-structure.html) and [PDF Basics](https://quarto.org/docs/output-formats/pdf-basics.html) in detail.
    If you use [Custom Translations](https://quarto.org/docs/authoring/language.html#custom-translations), you need to make `$Q_Has_Language_YML` `true` and set `$Q_Language_YML` for the filename.
The "_language" note in this file is for translating to Japanese.

![_quarto.yml 01](screenshots/quartoyml01.png)


![_quarto.yml 02](screenshots/quartoyml02.png)


![_quarto.yml 03](screenshots/quartoyml03.png)



3. Changing the `_common.R` file. ( optional )

    You can set up `knitr` package options for R chunk.  
    







# Book format





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


2. Index.qmd

    In the quarto book format, **only one index.qmd is required**,  `$IsIndexqmd` of the index.qmd is set to `true`.
You can make the note for index.qmd with the pIndexQmd Prototype.








# Chunks and Graphs



1. R chunk and Python chunk notes

You can create a pRChunk for an R chunk and a pPChunk for a Python chunk. The “Chunk & Graph: Make Chunk List” stamp generates a tag like ＜Lang:Tag Label➡️Figure Label＞.
These tags can be used to reference R chunks, Python chunks, Mermaid diagrams, or Graphviz code.
Please do not insert tags in the middle of a sentence.

![Chunk Tag Example](screenshots/ChunkLabel.png)

If tags called in your notes are changed or deleted, the warning is shown.
you can suppress the warning with  `$SuppresTagDetectWaring` in the project container note.


2. Rendered Preview in Text Pane(R chunks, Mermaid diagrams, and Graphviz only)

You can check the results of the code executed within an R chunk in the Preview screen. Similarly, the results of Mermaid and Graphviz code can also be displayed. However, this is not possible for Python.







# Rename HTMLExportFileName of a note with translation

There is a stamp **"Notes: Tranlate Section Labels"** that translates the Japanese title (`$Name`) into English and automatically sets `$HTMLExportFileName` [^translate-shell]. and you can set `$SectionLabel` with stamp "Set: Section Label". The labels of the section cannot be duplicated, so please modify them manually if necessary. In addition, you can change the language to be translated with `$Rename_in` in the TBX configuration note (**TBXConfig**). ( By default, from Japanese to English).

[^translate-shell]: [Translate-shell](https://github.com/soimort/translate-shell) installation required. 


```zsh
> brew install translate-shell
```






# Part in Book format

For Part, please refer to [Quarto's "Book Structure" reference](https://quarto.org/docs/books/book-structure.html).
pNote is compatible with quarto's **Part** or **Chapter**.
If pNote is at the bottom of pNote, the top pNote will be Part (Part ○), and the lower pNote will be Chapter (Chapter ○). You can place pNote at hierarchical level 2 only if you are under pNote of hierarchy level 1. 
In this case, the hierarchy level and header level are different, so the header level is set based on the user attribute `$OutlineDepthBase`.
pNote, which is treated as a Part, is turned on (`true`) for `$Is_Part_qmd`. The lower pNote contains the export file name (e.g. filename.qmd) of the pNote, which is Part, in `$Part_file`.
If a Part note is empty, only the title (`$Name`) of the note is reflected in _quarto.yml, as shown in the **"Dice"** in the example below. 
If the dice.qmd is not empty, the part title (as a level one header) as well as some introductory content for the part. 

```yml 
#_quarto.yml
chapters:
  - index.qmd
  - preface.qmd
  - part: "Dice" # if $Text("Dice").wordCount == 0 
  chapters: 
    - basics.qmd
    - packages.qmd
```


```yml
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

![Folder configuration at the time of output and _quarto.yml](screenshots/PartandChapter.png)



# Cross-Reference using Ziplink

In Quarto, labeled diagrams, tables, etc., can be mutually quoted. Label Lists are collected automatically (or manually). [^regrex]

![Label Lists and Working indicator(⏩ or ⏹️) for collecting automatically or not.](screenshots/WorkingIndicator.png)

Convert it to a quotable title (citation name starting with @) and create a note for the corresponding part. **Tinderbox**'s **Ziplink** function [^ziplink] is a function for easily pasting links to notebooks. It is diverted to make it easy to enter the quoted name. This makes it relatively easy to find and enter the quoted label even if the number increases.

[^regrex]: The diagrams and tables are extracted in regular expressions.


[^ziplink]: Please refer to "Text link creation via the Ziplinking method" in [A Tinderbox Reference File](https://acrobatfaq.com/atbref10/index/Automating_Tinderbox/Coding/Links/Text_Links/Text_link_creation_via_the_Ziplinking_method.html).(@Anderson2024Tinde)





# Export and Render



1. Export `_quarto.yml`

You can change the output format to "pdf" or "html"  with the stamp "Change quarto.yml template".
If you use a _language.yml, you export "_language" note (optional. See  @sec-setting Setting)


2. Export  `.qmd` files ( pNote notes only)

The pSubnote at the bottom of pNote at the time of output is all output as one qmd file in the state contained when pNote is exported. Therefore, it is OK to export by selecting only pNote to the "output" folder. In addition, pSubnote does not require output, but if you export, it is set to output as a text file (extension .txt).
If you select the pNote notes below "Export Agent" and output it, ~~then execute the "Move qmd files" stamp~~, you can overwrite the qmd file directly to `./output` (=`$HTMLExportFileName` of your project folder) ( @fig-after ). This method avoids considering the folder structure when referencing image files with a relative path.

::: {#fig-move-qmd layout-ncol=2}


![~~Before~~](screenshots/folder01.png){#fig-before}


![After](screenshots/folder02.png){#fig-after}

qmd files are moved to the project path by stamp

:::



3. Preview HTML output. 


```zsh
# preview for only html output
> quarto preview projectname
```



4. Render pdf or html.


```zsh
> quarto render
```

    You can use RStudio for preview and render.







# Example


[Example PDF](https://github.com/fryagbye/tinderboxwithquarto/blob/main/_bookpdf/Tinderbox-file-for-Quarto.pdf)








# Manuscript format








# Make sub-project folder

Make a note for the sub-project with **pSubfolderManuscript** like this ( _quarto_manuscript ).





# Export and Render



1. Export

    You have to export _quarto.yml ( _quarto_manuscript ) and one qmd ( main ) in the sub-project folder.


2. Activate a virtual environment

if you use a virtual environment, activate it.
e.g.

```zsh
> poetry shell
```



3. Render sub-project


```zsh
# quarto render "your project name"
> quarto render myproject
# For preview
> quarto preview myproject --to html 
```




# revealjs format





# Make sub-project folder

Make a note for the sub-project with **pSubfolderRevealjs** .






# Mermaid flowchart (optional)

This file can generate Mermaid flowchart from notes, links.


* Container notes -> Subgraphs ( pMFSubgraph )



* Non Container notes -> Nodes ( pMFNode)

Work Flow is a sample of Mermaid flowchart.  
Please check it in Map view.
You need to use pre-release version [^chromeheadlessmodeissue]

[^chromeheadlessmodeissue]:Since the old headless mode has been removed from Chrome 132, Quarto v1.7.13 or later is required.([Transition to Chrome new headless mode · Issue #10532 · quarto-dev/quarto-cli](https://github.com/quarto-dev/quarto-cli/issues/10532))












# Graphviz β version (optional)








# References


Anderson, Mark. 2024. “A Tinderbox Reference File.” 2024.
Wickham, Hadley, and Garrett Grolemund. 2016. R for Data Science: Import, Tidy, Transform, Visualize,
and Model Data. “O’Reilly Media, Inc.”	







# Restrictions

It seems that the section label customization function cannot be used in the latest release [ref. Cross-references on unnumbered pages fail (PDF) or are mislabeled (HTML)](https://github.com/quarto-dev/quarto-cli/issues/5946). 
If you turn on `$IsUnnumbered` and `$HasSectionLabel`, the display of the quote will be fixed to the number + title, so please turn off `$IsUnnumbered`.
Please do not use parentheses in note titles. The section label list is not being generated correctly.





