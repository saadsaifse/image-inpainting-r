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
  
  if (!file.exists(fileIn))
    stop("Input image file not found")

  if (!file.exists(fileInOcc))
    stop("Input occlusion file not found")
  
  file.verifyOutFile(fileOut)
  
  imgIn <- imager::load.image(fileIn)
  imgInOcc <- imager::load.image(fileInOcc)

  startTime <- Sys.time()
  
  output <- image_inpaint(fileIn, fileInOcc, fileOut, patchSizeX, patchSizeY, nLevels, useFeatures, verboseMode)
  
  endTime <- Sys.time()
  
  timeTaken <- endTime - startTime
  
  imgOut <- imager::load.image(fileOut)
  
  inpaintObject <- list(
    imgInPath = fileIn,
    imgIn = imgIn,
    imgInOccPath = fileInOcc,
    imgInOcc = imgInOcc,
    imgOutPath = fileOut,
    imgOut = imgOut,
    patchSizeX=patchSizeX,
    patchSizeY= patchSizeY,
    nLevels=nLevels,
    useFeatures = useFeatures,
    verboseMode = verboseMode,
    startTime =  format(startTime, "%X, %b %d %Y %Z"),
    endTime = format(endTime, "%X, %b %d %Y %Z"),
    timeTaken = format(timeTaken, "%X, %b %d %Y %Z"),
    isSuccessful = output$isSuccessful)
  
  class(inpaintObject) <- "inpaint"
  inpaintObject
}

#' @export
print.inpaint <- function(x, ...){
  cat(sep = "\n")
  cat("Image inpainting result", sep = "\n")
  cat(sprintf("  Result : %s", ifelse(x$isSuccessful, 'success', 'fail')), sep = "\n")
  cat(sprintf("  Total time taken (sec) : %s", round(x$timeTaken, digits = 2)), sep = "\n")
  cat(sprintf("  Output image path : %s", x$imgOutPath), sep = "\n")
}

#' @export
plot.inpaint <- function(x, ...){
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
  
  plot(x$imgOut, main = "Inpainted image")
  plot(x$imgIn, main = "Input image")
  plot(x$imgInOcc, main = "Occlusion input image")
}

#' @export
summary.inpaint <- function(object, ...){
  stopifnot(inherits(object, "inpaint"))

  result <- ifelse(object$isSuccessful, 'success', 'fail')
  output = matrix(c(object$startTime, object$endTime, round(object$timeTaken, digits = 2), result, object$imgInPath, object$imgInOccPath, object$imgOutPath, object$patchSizeX, object$patchSizeY,
                    object$nLevels, object$useFeatures, object$verboseMode), ncol = 1)
  rownames(output) = c("Start time", "End time", "Time taken (sec)", "Result", "Input image path", "Input occlusion image path", "Output iamge path"
                       , "Patch size X", "Patch size Y", "No. of levels", "Use features", "Verbose mode");
  colnames(output) = "value"
  
  return(output)
}

file.verifyOutFile <- function(path) {
  if (!is.character(path) && length(path) != 1)
    stop("Incorrect path format")

  if (!(file_ext(path) %in% c("png", "bmp", "jpeg", "jpg")))
    stop("Output file must only be a jpeg/png/bmp")
    
  file.create(path, overwrite=TRUE)
  
  #check if writeable
  file.access(path, mode = 2)[[1]] == 0
}
