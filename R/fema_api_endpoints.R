#' Returns the API endpoint associated with a openFEMA data set
#'
#' @param data_set A character string with the name of the data set to get the API endpoint for. 
#'
#' @return Returns a character string containing the API endpoint url associated with the data set.
#' @export
#'
#' @examples
#' fema_api_endpoints("FimaNfipClaims")
#' fema_api_endpoints("fImAnfiPclaims")
#' fema_api_endpoints("fimanfippolicies")

fema_api_endpoints <- function(data_set){

  # convert dataset to fema consistent capitalization
<<<<<<< HEAD
  data_set <- unique(valid_dataset(data_set))
=======
  data_set <- valid_dataset(data_set)
>>>>>>> 0d62dda3756309cbb7399f46314b7742f907182d
  
  # get df of all fema data sets
  fema_data_sets <- fema_data_sets()
  
  # get the most current version
<<<<<<< HEAD
  version <- max(as.numeric(fema_data_sets$version[which(data_set == fema_data_sets$name  )]))
=======
  version <- fema_data_sets$version[which(data_set == fema_data_sets$name)]
>>>>>>> 0d62dda3756309cbb7399f46314b7742f907182d
  
  endpoint <- paste0("https://www.fema.gov/api/open/v",version,"/",data_set)
  
  return(endpoint)
}
