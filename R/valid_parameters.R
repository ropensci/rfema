

#' Get all valid API parameters for a given FEMA data set
#'
#' @param data_set A character string indicating the data set to return valid parameters for
#'
#' @return Returns a vector of parameter names that can be used to filter an API call for a given open FEMA data set
#' 
#' @importFrom memoise memoise
#' 
#' @export
#'
#' @examples
#' valid_parameters("fimaNfipPolicies")
valid_parameters <- memoise::memoise(function(data_set = NULL) {
  data_set <- valid_dataset(data_set = data_set)
  data_fields <- fema_data_fields(data_set)
  data_fields <- data_fields[which(data_fields$isSearchable != "no"), ] # remove rows for parameters that aren't searchable
  params <- data_fields$name

  # one of the data sets (fimanfipclaims) appears to have the columns mislabled. This code
  # corrects for that.

  # if "id" is not in the name column that the column labels are mislabled
  if ("id" %in% tolower(params) == F) {
    found_id <- 0
    k <- 0
    while (found_id == 0 | k == ncol(data_fields)) {
      k <- k + 1
      params <- data_fields[, k]
      if ("id" %in% params) {
        found_id <- 1
      }
    }
  }

  # make sure params are returned as a character vector
  params <- as.vector(as.character(params))

  return(params)
})
