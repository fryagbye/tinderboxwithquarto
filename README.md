# Tinderbox file for Quarto Book Creation

This project provides a structure for creating books in **Quarto** with **Tinderbox**. Using this setup, you can easily generate `.qmd` files and a `_quarto.yml` configuration file.

## Table of Contents

1. [Introduction](#introduction)
2. [Usage Environment](#usage-environment)
3. [Configuration and Setup](#configuration-and-setup)
4. [Creating Notes](#creating-notes)
5. [Cross-Referencing with Ziplink](#cross-referencing-with-ziplink)
6. [Exporting the Project](#exporting-the-project)
7. [Restrictions](#restrictions)
8. [Example](#example)
9. [References](#references)

## Introduction

This template aids in the creation of Quarto books, inspired by resources like **["私たちのR"](https://github.com/JaehyunSong/RBook/)** and **["R for Data Science"](https://github.com/hadley/r4ds/)**. It allows for the creation of `.qmd` files, exporting configurations, and includes cross-referencing support.

## Usage Environment

- [**Tinderbox**](https://www.eastgate.com/Tinderbox/updates/Tinderbox10.html) version: 10.0.2
- [**Quarto**](https://quarto.org/) version: 1.5.57
- **R** version: 4.4.0
- **LaTeX**: `luaLatex` for Japanese support (requires **MacTeX**)
- [**translate-shell**](https://github.com/soimort/translate-shell) version: 0.9.7.1 (optional)

## Configuration and Setup

1. **TBXConfig Note**: Configure indentation, excluded notes, export paths, and table of contents.
2. **\_quarto.yml Configuration**: Adjust options directly within the `_quarto` note.
3. **Optional**: Modify `_common.R` for custom **knitr** options.

## Creating Notes

- **pNote** and **pSubnote** are templates for creating chapters, sections and subsections notes.
- To structure a note, label it with `#pNote` or `#pSubnote` in the title.
- **Index**: Only one `index.qmd` file is needed in Quarto book format.

## Cross-Referencing with Ziplink

- **Ziplink** enables easy insertion of cross-references for figures, tables, and sections.
- **Labeling**: For diagrams and tables, set labels in R chunks or as markdown links (e.g., `![image](path){#label}`).
- **Quoting**: Use `[[label]]` to insert cross-references in the document.

## Exporting the Project

1. **\_quarto.yml Export**: Change templates for `pdf` or `html` output with stamp,
2. **.qmd Files**: `pNote` are output as `.qmd` files that contain `pSubnote` below. Optional: export `pSubnote` sections as `.txt`.
3. **Moving Files**: Use the `Move qmd files` stamp to place files in the project root directory, helping with relative paths.
4. **Preview and Render**:
   - **Preview**: `quarto preview index.qmd --to html` (html only)
   - **Render**: `quarto render`

## Restrictions

- Limitations on customizing section labels for cross-references.([quarto-cli:issue 5946](https://github.com/quarto-dev/quarto-cli/issues/5946))
- Issues may arise with cross-referencing unnumbered sections.

## Example
[Example PDF](_bookpdf/How-to-use-this-file.pdf)

## References

- [R for Data Science](https://r4ds.hadley.nz/)
- [私たちのR](https://www.jaysong.net/RBook/)
- [Quarto Documentation](https://quarto.org/docs/reference/)
- [A Tinderbox Reference File](https://acrobatfaq.com/atbref10/)
