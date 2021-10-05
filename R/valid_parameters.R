

#' Get all valid API parameters for a given FEMA data set
#'
#' @param data_set A character string indicating the data set to return valid parameters for
#'
#' @return Returns a vector of parameter names that can be used to filter an API call for a given open FEMA dataset
#' @export
#'
#' @examples
#' valid_parameters("fimaNfipPolicies")
valid_parameters <- function(data_set = NULL) {
  data_set <- valid_dataset(data_set = data_set)
  data_fields <- fema_data_fields(data_set)
  data_fields <- data_fields[which(data_fields$`Is Searchable` == "yes"), ] # remove rows for parameters that aren't searchable
  params <- data_fields$Name
  return(params)
}
