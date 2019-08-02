#' @export
extractOcclusionRegions <- function(object){
  if (!inherits(object, "inpaint"))
    stop("Provided object is not an 'inpaint' class object")
  
  verifyCimgObject(object$imgIn)
  verifyCimgObject(object$imgInOcc)
  verifyCimgObject(object$imgOut)

  pixelSet <- getOcclusionPixelSet(object$imgInOcc)
  
  occRegion <- getImageRegion(object$imgInOcc, pixelSet)
  imgInOccRegion <- getImageRegion(object$imgIn, pixelSet)
  imgOutOccRegion <- getImageRegion(object$imgOut, pixelSet)
  
  occlusionObject <- list(occRegion = occRegion, imgInRegion = imgInOccRegion, imgOutRegion = imgOutOccRegion)
  class(occlusionObject) <- "occlusion"
  occlusionObject
}

#' @export
plot.occlusion  <- function(x, ...){
  
  verifyCimgObject(x$occRegion)
  verifyCimgObject(x$imgInRegion)
  verifyCimgObject(x$imgOutRegion)
  
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
  
  plot(x$occRegion, main = "Occlusion region")
  plot(x$imgInRegion, main="Before inpainting")
  plot(x$imgOutRegion, main="After inpainting")
}

getOcclusionPixelSet <- function(occlusionImage){
  grays <- imager::grayscale(occlusionImage)
  whiteRegion <- grays > 0
  imager::bbox(whiteRegion)
}

getImageRegion <- function(img, pixelSet){
  region <- imager::crop.bbox(img, pixelSet)
}

verifyCimgObject <- function(x){
  xName <- deparse(substitute(x))
  if (is.null(x))
    stop(paste0(xName, " is null and not a valid cimg object"))
  if (!('cimg' %in% class(x)))
    stop(paste0(xName, " is not a valid cimg object"))
}