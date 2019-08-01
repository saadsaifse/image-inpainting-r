#' @export
getOcclusionPixelSet = function(occlusionImage){
  grays <- grayscale(occlusionImage) #returns a cimg
  whiteRegion <- grays > 0 #returns a pixeset
  boundingBox <- bbox(whiteRegion) #pixelset of the bounding box
}

#' @export
getImageRegion = function(img, pixelSet){
  region <- crop.bbox(img, pixelSet)
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


