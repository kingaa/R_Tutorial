stopifnot(getRversion()>="4.1")

library(knitr)
if (!exists("prefix")) prefix <- NULL
opts_chunk$set(
  cache=TRUE,
  cache.path=paste("tmp",as.character(prefix),"cache",sep="/"),
  comment=NA,
  echo=TRUE,
  eval=TRUE,
  dev='CairoPNG',
  dev.args=list(bg='transparent'),
  dpi=300,
  error=FALSE,
  fig.align='center',
  fig.dim=c(6.83,4),
  fig.lp="fig:",
  fig.path=paste("tmp",as.character(prefix),"figure",sep="/"),
  fig.pos="h!",
  fig.show='asis',
  highlight=TRUE,
  include=TRUE,
  message=FALSE,
  progress=TRUE,
  prompt=FALSE,
  purl=TRUE,
  results="markup",
  size='small',
  strip.white=TRUE,
  tidy=FALSE,
  warning=FALSE
  )

options(
  width=60, # number of characters in R output before wrapping
  keep.source=TRUE,
  encoding="UTF-8",
  pomp_archive_dir="results"
)

hooks <- knitr::knit_hooks$get()

hook_foldable <- function (type) {
  force(type)
  function(x, options) {
    res <- hooks[[type]](x, options)
    if (isFALSE(options[[paste0("fold.", type)]])) return(res)
    paste0(
      "<details><summary class=\"folder\">", type, "</summary>\n\n",
      res,
      "\n\n</details>"
    )
  }
}

knitr::knit_hooks$set(
  output = hook_foldable("output"),
  plot = hook_foldable("plot")
)

registerS3method(
  "knit_print",
  "data.frame",
  function (x, ...) {
    print(x,row.names=FALSE)
  }
)

myround <- function (x, digits = 1) {
  # adapted from the broman package
  # solves the bug that round() kills significant trailing zeros
  if (length(digits) > 1) {
    digits <- digits[1]
    warning("Using only digits[1]")
  }
  if (digits < 1) {
    as.character(round(x,digits))
  } else {
    tmp <- sprintf(paste("%.", digits, "f", sep = ""), x)
    zero <- paste0("0.", paste(rep("0", digits), collapse = ""))
    tmp[tmp == paste0("-", zero)] <- zero
    tmp
  }
}

mysignif <- function (x, digits = 1) {
  myround(x, digits - ceiling(log10(abs(x))))
}
