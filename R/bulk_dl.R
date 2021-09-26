#' Bulk download full openFEMA data sets as .csv files
#'
#' For large files, the function 
#'
#' @param data_set A character string indicating the name of the data set to download
#' @param output_dir An optional character string indicating the directory (defaults to working directory)
#' @param file_name An optional character string indicating the file name (defaults to data set name with time stamp)
#' @param size_warning A logical indicating whether to issue a warning before proceeding with downloading a large file (default is TRUE)
#' @return Returns a downloaded csv file of the data set to the specified output directory.
#' @export
#'
#' 
bulk_dl <- function(data_set, output_dir = NULL,file_name = NULL, size_warning = T){
  
  # get info on all data sets fema offers
  ds <- fema_data_sets()
  
  # make sure data set is valid and uses the FEMA 
  # consistent capitalization
  data_set <- unique(valid_dataset(data_set))
  
  # filter data sets to only those matching the name of the user supplied data set
  ds <- ds[which(ds$name == data_set ),]
  
  # determine the most recent version of the data set
  latest_version <- max(as.numeric(ds$version))
  
  # filter data sets df to only the most recent version
  ds <- ds[which(as.numeric( ds$version ) == latest_version),]
  
  # get url for bulk download of csv file
  url <- ds$distribution.accessURL
  
  if(is.null(output_dir)){
    output_dir <- getwd()
  }
  if(is.null(file_name)){
    file_name <- paste0(data_set,"_",Sys.time(),".csv")
  }

  if(size_warning == T){
    file_size <- ds$distribution.datasetSize
    if(grepl("large",file_size)){
      print(paste0("FEMA indicates this file is: ", ds[which(ds$name == data_set ), "distribution.datasetSize"],". Continue with download?"))
      
      user_response <- readline(prompt=" 1 - Yes, get that data!, 0 - No:")
      
      if(user_response == "0"){
        stop("Opperation aborted by user.")
      }
      
    }
  }
  
  print(paste0("Downloading file to ", paste0(output_dir,"/",file_name)))
  utils::download.file(url, destfile = paste0(output_dir,"/",file_name))
  
}
  
  
  