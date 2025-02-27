

{{< include ./_extensions/r-wasm/live/_knitr.qmd >}}


```{r, echo=FALSE}
#| include: false
out_type <- knitr::opts_knit$get("rmarkdown.pandoc.to")
source("_common.R")
```


```{webr}
library(ggplot2)
ggplot(airquality, aes(Temp, Ozone)) + 
  geom_point() + 
  geom_smooth(method = "loess")

```
