## ----wrap-hook, echo=FALSE-----------------------------------------------
library(knitr)
hook_output = knit_hooks$get('output')
knit_hooks$set(output = function(x, options) {
  # this hook is used only when the linewidth option is not NULL
  if (!is.null(n <- options$linewidth)) {
    x = knitr:::split_lines(x)
    # any lines wider than n should be wrapped
    if (any(nchar(x) > n)) x = strwrap(x, width = n)
    x = paste(x, collapse = '\n')
  }
  hook_output(x, options)
})

## ------------------------------------------------------------------------
library(imageInpainting)

inputFile = system.file("extdata", "got.png", package = "imageInpainting")
inputOccFile = system.file("extdata", "got_occlusion.png", package = "imageInpainting")
outputFilePath = file.path(getwd(), "got_inpainted.png")

inpaintResult = imageInpaint(inputFile, inputOccFile, outputFilePath)

## ------------------------------------------------------------------------
print(inpaintResult)

## ----linewidth=60--------------------------------------------------------
summary(inpaintResult)

## ----fig.height=8, fig.width=6-------------------------------------------
plot(inpaintResult)

## ----fig.height=8, fig.width=6-------------------------------------------
regions <- extractOcclusionRegions(inpaintResult)
plot(regions)

## ----eval=FALSE----------------------------------------------------------
#  inputFile = system.file("extdata", "barbara.png", package = "imageInpainting")
#  inputOccFile = system.file("extdata", "barbara_occlusion.png", package = "imageInpainting")

## ----eval=FALSE----------------------------------------------------------
#  inputFile = system.file("extdata", "car.png", package = "imageInpainting")
#  inputOccFile = system.file("extdata", "car_occlusion.png", package = "imageInpainting")

## ----eval=FALSE----------------------------------------------------------
#  inputFile = system.file("extdata", "golf.png", package = "imageInpainting")
#  inputOccFile = system.file("extdata", "golf_occlusion.png", package = "imageInpainting")

## ----eval=FALSE----------------------------------------------------------
#  inputFile = system.file("extdata", "house.png", package = "imageInpainting")
#  inputOccFile = system.file("extdata", "house_occlusion.png", package = "imageInpainting")

