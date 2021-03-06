saveNupload <- function(dataList, cancer, directory = "data/bits") {
    cancerSubdir <- file.path(directory, cancer)
    if (!dir.exists(cancerSubdir))
        dir.create(cancerSubdir, recursive = TRUE)
    filePrefix <- paste0(toupper(cancer), "_")
    filetype <- ".rda"
    dataNames <- names(dataList)
    stopifnot(!is.null(dataNames))
    objnames <- paste0(filePrefix, dataNames)
    fnames <- file.path(directory, paste0(objnames, ".rda"))
    for (i in seq_along(dataList)) {
        message(paste0("Writing: ", fnames[i]))
        objname <- objnames[i]
        assign(x = objname, value = dataList[[i]])
        save(list = objname,
             file = fnames[i],
             compress = "bzip2")
        AnnotationHubData:::upload_to_S3(file = fnames[i],
                                         remotename = basename(fnames[i]),
                                         bucket =
                                             "experimenthub/curatedTCGAData/")
        updateMetadata(dataList[i], cancer)
    }
}
