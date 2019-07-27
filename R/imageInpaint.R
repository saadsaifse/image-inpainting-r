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

#' @export
print.inpainting <- function(x, ...){
  cat(sep = "\n")
  cat("Image inpainting result", sep = "\n")
  cat(sprintf("  Result : %s", x$result), sep = "\n")
  cat(sprintf("  Total time taken (sec) : %s", x$timeTaken), sep = "\n")
  cat(sprintf("  Output image path : %s", x$outputFilePath), sep = "\n")
}

#' @export
plot.inpainting <- function(x, ...){
  
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
  
  outputImage <- load.image(x$outputFilePath)
  inputImage <- load.image(x$inputFilePath)
  occlusionImage <- load.image(x$occlusionFilePath)
  
  plot(outputImage, main = "Inpainted image")
  plot(inputImage, main = "Input image")
  plot(occlusionImage, main = "Occlusion input image")
}
