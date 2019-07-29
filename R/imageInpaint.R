#' @title Apply image inpainting algorithm to the input images.
#' @description An implementation of the "Image Inpainting" algorithm explained at <http://www.ipol.im/pub/art/2017/189/>. 
#' @param fileIn Input image path.
#' @param fileInOcc Image path with the occlusion. 
#' @param fileOut Output image path after application of image inpainting. 
#' @param patchSizeX Size of X patch. 
#' @param patchSizeY Size of Y patch.
#' @param nLevels Number of levels.
#' @param useFeatures Use features.
#' @param verboseMode Verbose mode.
#' @return as list containing time taken and path of the output image.
#' @export


imageInpaint <- function(fileIn, fileInOcc, fileOut, patchSizeX = 7L, patchSizeY = 7L, nLevels = -1, useFeatures = 1, verboseMode = 0) {
  startTime <- Sys.time()
  output <- image_inpaint(fileIn, fileInOcc, fileOut, patchSizeX, patchSizeY, nLevels, useFeatures, verboseMode)
  endTime <- Sys.time()
  imageInpaintObject <- createImageInpaintObject(fileIn, fileInOcc, fileOut, patchSizeX, patchSizeY,
                                                nLevels, useFeatures, verboseMode, startTime, endTime, TRUE)
  class(imageInpaintObject) <- "inpainting"
  imageInpaintObject
}

createImageInpaintObject <- function(fileIn, fileInOcc, fileOut, patchSizeX, patchSizeY, nLevels,
                                     useFeatures, verboseMode, startTime, endTime, isSuccessful){
  #a shorter way to create a list with all the arguments of a function
  #obj <- as.list(match.call())
  obj <- list(fileIn = fileIn, fileInOcc = fileInOcc, fileOut = fileOut, patchSizeX=patchSizeX, patchSizeY= patchSizeY, nLevels=nLevels,
              useFeatures = useFeatures, verboseMode = verboseMode, startTime = startTime, endTime = endTime, isSuccessful = isSuccessful)
  obj$timeTaken <- endTime - startTime
  obj
}

#' @export
print.inpainting <- function(x, ...){
  cat(sep = "\n")
  cat("Image inpainting result", sep = "\n")
  cat(sprintf("  Result : %s", ifelse(x$isSuccessful, 'success', 'fail')), sep = "\n")
  cat(sprintf("  Total time taken (sec) : %s", x$timeTaken), sep = "\n")
  cat(sprintf("  Output image path : %s", x$fileOut), sep = "\n")
}

#' @export
plot.inpainting <- function(x, ...){
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
  
  outputImage <- imager::load.image(x$fileOut)
  inputImage <- imager::load.image(x$fileIn)
  occlusionImage <- imager::load.image(x$fileInOcc)
  
  plot(outputImage, main = "Inpainted image")
  plot(inputImage, main = "Input image")
  plot(occlusionImage, main = "Occlusion input image")
}

summary.inpainting <- function(x){
  stopifnot(inherits(x, "inpainting"))
  cat(sep = "\n")
  cat("-----  Image inpainting summary  -----", sep = "\n")
  cat(sprintf("  Started at : %s", x$startTime), sep="\n")
  cat(sprintf("  Finished at : %s", x$endTime), sep="\n")
  cat(sprintf("  Total time taken (sec) : %s", x$timeTaken), sep = "\n")
  cat(sprintf("  Result : %s", ifelse(x$isSuccessful, 'success', 'fail')), sep = "\n")
  cat(sprintf("  Input image path : %s", x$fileIn), sep = "\n")
  cat(sprintf("  Input occlusion image path : %s", x$fileInOcc), sep = "\n")
  cat(sprintf("  Output image path : %s", x$fileOut), sep = "\n")
  cat(sprintf("  patchSizeX : %i", x$patchSizeX), sep = "\n")
  cat(sprintf("  patchSizeY : %i", x$patchSizeY), sep = "\n")
  cat(sprintf("  Number of Levels : %i", x$nLevels), sep = "\n")
  cat(sprintf("  Use Features : %i", x$useFeatures), sep = "\n")
  cat(sprintf("  Verbose mode : %i", x$verboseMode), sep = "\n")
  cat(sprintf("-----  End of summary  -----"), sep = "\n")
}

