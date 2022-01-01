#' Get a dataframe of avaliable FEMA data sets
#'
#'
#' @return Returns a tibble containing information about each data
#' set avaliable.
#' 
#' @import httr
#' @importFrom plyr rbind.fill
#' @importFrom tibble as_tibble
#' 
#' @export
#'
#' @examples
#' fema_data_sets()
fema_data_sets <- function(){
  result <- httr::GET("https://www.fema.gov/api/open/v1/DataSets")
  jsonData <- httr::content(result)
  df <- data.frame(t(unlist(jsonData$DataSets[1])))
  for (k in seq_len(length(jsonData$DataSets))) {
    df <- plyr::rbind.fill(df, data.frame(t(unlist(jsonData$DataSets[k]))))
  }

  # remove the html line break characters
  df <- as.data.frame(lapply(df, function(df) gsub("\n", "", df)))


  return(as_tibble(df))
}
