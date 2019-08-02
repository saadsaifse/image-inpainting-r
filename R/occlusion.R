getOcclusionPixelSet <- function(occlusionImage){
  grays <- imager::grayscale(occlusionImage) #returns a cimg
  whiteRegion <- grays > 0 #returns a pixeset
  imager::bbox(whiteRegion) #pixelset of the bounding box
}

getImageRegion <- function(img, pixelSet){
  region <- imager::crop.bbox(img, pixelSet)
}

#' @export
extractOcclusionRegions <- function(object){
  if (!inherits(object, "inpaint"))
    stop("Provided object is not an 'inpaint' class object")
  
  # if (!object$imgIn | !object$imgInOcc | !object$imgOut)
  #   stop("Input, occlusion input and inpaint output images are required")
  
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
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
  
  plot(x$occRegion, main = "Occlusion region")
  plot(x$imgInRegion, main="Before inpainting")
  plot(x$imgOutRegion, main="After inpainting")
}


