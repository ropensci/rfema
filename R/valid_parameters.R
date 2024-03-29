

#' Get all valid API parameters for a given FEMA data set
#'
#' @param data_set A character string indicating the data set to return valid parameters for
#'
#' @return Returns a tibble of parameter names that can be used to filter an API call for a given open FEMA data set
#'
#' @importFrom memoise memoise
#' @importFrom tibble as_tibble
#'
#' @export
#'
#' @examples
#' \dontrun{
#' valid_parameters("fimaNfipPolicies")
#' }
valid_parameters <- memoise::memoise(function(data_set = NULL) {
  data_set <- valid_dataset(data_set = data_set)
  data_fields <- fema_data_fields(data_set)
  
  # remove rows for parameters that aren't searchable
  data_fields <- data_fields[which(data_fields$isSearchable == TRUE), ] 
  
  # remove rows for parameters that aren't part of the most current data set version
  data_fields <- data_fields[which(data_fields$datasetVersion == max(data_fields$datasetVersion)), ] 
  params <- data_fields$name

  # one of the data sets (fimanfipclaims) appears to have the columns mislabled. This code
  # corrects for that.

  # if "id" is not in the name column than the column labels are mislabled
  if ("id" %in% tolower(params) == F) {
    found_id <- 0
    k <- 0
    while (found_id == 0 | k == ncol(data_fields)) {
      k <- k + 1
      params <- data_fields[, k]
      if (TRUE %in% ("id" == params)) {
        found_id <- 1
      }
    }
  }

  # trim white space before returning
  params <- data.frame(params)
  params[, 1] <- trimws(params[, 1])


  return(as_tibble(params))
})
