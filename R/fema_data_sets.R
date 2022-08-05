#' Get a tibble of available FEMA data sets
#'
#'
#' @return Returns a tibble containing meta data about each data
#' set available through the FEMA API. For more information see the FEMA
#' documentation page: https://www.fema.gov/about/openfema/data-sets.
#'
#' @import httr
#' @importFrom plyr rbind.fill
#' @importFrom tibble as_tibble
#'
#' @export
#'
#' @examples
#' \dontrun{
#' fema_data_sets()
#' }
fema_data_sets <- function() {
  
  # get raw data from api endpoint
  result <- httr::GET(url = "https://www.fema.gov/api/open/v1/OpenFemaDataSets?$inlinecount=allpages")
  
  # check status code
  if (result$status_code != 200) {
    status <- httr::http_status(result)
    stop(status$message)
  }
  
  json_data <- httr::content(result)[[2]]
  
  full_data <- data.frame(do.call(rbind, json_data))
  
  # unlist columns in full_data if possible
  for(k in seq_len(ncol(full_data))){
    try({full_data[,k] <- unlist(full_data[,k])}, silent = T)
  }
  
  return(as_tibble(full_data))
  
}
