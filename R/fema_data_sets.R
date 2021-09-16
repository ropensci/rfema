#' Get a dataframe of avaliable FEMA data sets
#'
#' @param rfema_access logical indicating whether to return only the datasets that are accessable through the rfema package (default = TRUE). 
#' Set to FALSE to get information on all data sets FEMA offers.
#'
#' @return Returns a data frame containing information about each data set avaliable.
#' @export
#'
#' @examples
#' fema_data_sets(rfema_access  = TRUE)
#' fema_data_sets(rfema_access  = FALSE)
fema_data_sets <- function(rfema_access = T){
  
  rfema_data_sets <- c("FimaNfipPolicies","FimaNfipClaims")
  
  result <- httr::GET("https://www.fema.gov/api/open/v1/DataSets")
  jsonData <- httr::content(result)  
  df <- data.frame(t(unlist(jsonData$DataSets[1])))
  for(k in 1:length(jsonData$DataSets)){
    df <- plyr::rbind.fill(df, data.frame(t(unlist(jsonData$DataSets[k]))))
  }
  
  if(rfema_access == T){
    df <- df %>% dplyr::filter(tolower(df$name) %in% tolower(rfema_data_sets) )
  }
  
  return(df)
}