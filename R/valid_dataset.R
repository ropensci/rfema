#' Ensure data_set parameter matches an open FEMA data offering.
#'
#' The function corrects any capitalization inconsistencies so that the "data_set" parameter in any of rfema's functions is not case sensative.
#'
#' @param data_set a character string representing the data set.
#'
#' @return returns the data with capitalization changed to be consistent with FEMA's naming convention or returns an error if the data set is not one of the valid offerings through the FEMA API.
#' @export
#'
#' @examples
#' valid_dataset("fimanfipclaims")
#' valid_dataset("fIMANfipclaiMS")
valid_dataset <- function(data_set) {


  # get df with info on fema data sets
  fema_data_sets <- fema_data_sets()

  # convert user specified data set to lower case
  data_set <- tolower(data_set)

  # match up user specified data set to data sets in "fema_data_sets"
  # and redefine the "data_set" object to make sure its consistent with the
  # capitalization fema uses
  match <- fema_data_sets$name[tolower(fema_data_sets$name) == data_set]
  if (length(match) == 0) {
    stop(paste0(data_set, " is not a valid data set. These are the currently supported data sets: ", paste(fema_data_sets$name, collapse = ", ")))
  } else {
    data_set <- match
  }
  return(unique(data_set))
}
