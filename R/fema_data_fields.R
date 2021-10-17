#' Get data fields and descriptions for a given FEMA data set
#'
#'
#' @param data_set a character string indicating the data set of interest
#'
#' @return Returns a data frame consisting of the data fields name, along with information about each data field including the data type, a description of the data field, and whether the data field is "searchable" (i.e. can it be used to filter the returned data in an API query)
#' @export
#'
#' @examples
#' fema_data_fields("FimaNfipClaims")
#' fema_data_fields("FimaNfipPolicies")

fema_data_fields <- function(data_set) {



  # convert data_set to fema consistent capitalization
  data_set <- valid_dataset(data_set)
  
  # obtain the data fields data set using the open_fema function
  data_fields <- open_fema("DataSetFields")
  
  # keep only data fields which correspond to the choosen data set
  data_fields <- data_fields[which(data_fields$openFemaDataSet == data_set),]
  


  return(data_fields)
}
