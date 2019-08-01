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
  
  if (!file.verify(fileOut))
    stop("Output file cannot be created")
  
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
  cat(sprintf("  Total time taken (sec) : %s", round(x$timeTaken, digits = 2)), sep = "\n")
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

#' @export
summary.inpainting <- function(object, ...){
  stopifnot(inherits(object, "inpainting"))

  result <- ifelse(object$isSuccessful, 'success', 'fail')
  startTime <- format(object$startTime, "%X, %b %d %Y %Z")
  endTime <- format(object$endTime, "%X, %b %d %Y %Z")
  output = matrix(c(startTime, endTime, round(object$timeTaken, digits = 2), result, object$fileIn, object$fileInOcc, object$fileOut, object$patchSizeX, object$patchSizeY,
                    object$nLevels, object$useFeatures, object$verboseMode), ncol = 1)
  rownames(output) = c("Start time", "End time", "Time taken (sec)", "Result", "Input image path", "Input occlusion image path", "Output iamge path"
                       , "Patch size X", "Patch size Y", "No. of levels", "Use features", "Verbose mode");
  colnames(output) = "value"
  
  return(output)
}

file.verify <- function(path) {
  if (!assertthat::is.string(path))
    stop("Incorrect path format")
  
  if (!file.exists(path)){
    file.create(path)
  }
  else{
    file.remove(path)
  }
  assertthat::is.writeable(path)
}
