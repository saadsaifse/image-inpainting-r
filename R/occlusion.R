#' @export
getOcclusionPixelSet = function(occlusionImage){
  grays <- imager::grayscale(occlusionImage) #returns a cimg
  whiteRegion <- grays > 0 #returns a pixeset
  boundingBox <- imager::bbox(whiteRegion) #pixelset of the bounding box
}

#' @export
getImageRegion = function(img, pixelSet){
  region <- imager::crop.bbox(img, pixelSet)
}

#' @export
plotOcclusionRegions = function(img, occImg, inpaintImg){
  pixelSet <- getOcclusionPixelSet(occImg)
  occlusionRegion <- getImageRegion(occImg, pixelSet)
  beforeInpaintRegion <- getImageRegion(img, pixelSet)
  afterInpaintRegion <- getImageRegion(inpaintImg, pixelSet)
  
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
  
  plot(occlusionRegion, main = "Occlusion region")
  plot(beforeInpaintRegion, main="Before inpainting")
  plot(afterInpaintRegion, main="After inpainting")
}


