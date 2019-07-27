#' @title Apply image inpainting to the input image.
#' @description An implementation of the "Image Inpainting" algorithm explained at <http://www.ipol.im/pub/art/2017/189/>. 
#' @param fileIn Input image path.
#' @param fileOcc Image path with the occlusion. 
#' @param fileOut Output image path after application of image inpainting. 
#' @param patchSizeX Size of X patch. 
#' @param patchSizeY Size of Y patch.
#' @param nLevels Number of levels.
#' @param useFeatures Use features.
#' @param verboseMode Verbose mode.
#' @return as list containing time taken and path of the output image.
#' @export

imageInpaint <- function(fileIn, fileInOcc, fileOut, patchSizeX = 7L, patchSizeY = 7L, nLevels = -1, useFeatures = 1, verboseMode = 0) {
  
  result <- image_inpaint(fileIn, fileInOcc, fileOut, patchSizeX, patchSizeY, nLevels, useFeatures, verboseMode)
  class(result) <- "inpainting"
  result
}

