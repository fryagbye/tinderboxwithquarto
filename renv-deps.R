# Packages required by Quarto renders but not detectable by renv's
# static scan (e.g. knitr's python engine -> reticulate inside
# myproject/*.qmd chunks). Kept so renv::status() stays synchronized.
library(reticulate)
