#' Helper function to generate the URL string for an API query
#'
#' @param data_set character string specifiying the data set to query from
#' @param top_n numeric value indicating how many records to retun (default is 1000 which is the maximum number of records the API will return in a single query )
#' @param filters a list containing values of data fields that should be used to construct filters.
#' @param select a character vector of data fields to return (default is to return all data fields for the data set)
#'
#' @return The function returns a string containing a url that can be used to query the API.
#' @export
#'
#' @examples
#' filter_list <- list(baseFloodElevation = c(5, 6), countyCode = "34029")
#' vars_to_select <- c("countyCode", "baseFloodElevation")
#' url <- gen_api_query(
#'   data_set = "fimaNfipPolicies", top_n = 100,
#'   filters = filter_list, select = vars_to_select
#' )
gen_api_query <- function(data_set = NULL, top_n = NULL, filters = NULL, select = NULL) {

  # replace top_n with 1000 if no value is supplied
  if (is.null(top_n)) {
    top_n <- 1000
  }

  # build up the api query starting with the base url for the data set
  base_url <- paste0(fema_api_endpoints(data_set), "?$inlinecount=allpages")

  # append the querty to represent the top parameter
  api_query <- paste0(base_url, "&$top=", top_n)

  # if select is not NULL then append the api query to
  # limit the api call to the field specified in select
  if (is.null(select) == F) {

    # check to make sure the selected fields are in the selected data set
    for (field in select) {
      if (field %in% valid_parameters(data_set) == F) {
        stop(paste0(field, " is not a valid data field for the ", data_set, " data set use the valid_parameters() function to view all valid parameters for a data set."))
      }
    }

    api_query <- paste0(api_query, "&$select=", paste(select, collapse = ","))
  }

  # if filters is not NULL, then append the api query to
  # apply those filters
  if (is.null(filters) == F) {

    # check to make sure the fields used to filter are in the selected data set
    for (field in names(filters)) {
      if (field %in% valid_parameters(data_set) == F) {
        stop(paste0(field, " is not a valid data field for the ", data_set, " thus cannot be used to construct a filter"))
      }
    }
    filters_n <- length(filters)
    filters_vector <- c()
    for (k in 1:filters_n) {
      operators <- data.frame(sym = c("=", ">", "<", "!=", ">=", "<="), char = c("eq", "gt", "lt", "ne", "ge", "le"))

      op_temp <- NULL
      for (op in operators$sym) {
        if (T %in% grepl(op, filters[[k]])) {
          op_temp <- operators$char[which(operators$sym == op)]
        }
        if (is.null(op_temp)) {
          op_temp <- "eq"
        }
      }

      filter_temp <- trimws(gsub(paste(operators$sym, collapse = "|"), "", filters[[k]]))

      if (is.character(filter_temp)) {
        filter_temp <- paste0("(", names(filters)[k], " ", op_temp, " ", noquote(paste0("'", filter_temp, "'", collapse = paste0(" or ", names(filters)[k], " ", op_temp, " "))), ")")
      } else {
        filter_temp <- paste0("(", names(filters)[k], " ", op_temp, " ", noquote(paste0(filter_temp, collapse = paste0(" or ", names(filters)[k], " ", op_temp, " "))), ")")
      }
      filters_vector <- c(filters_vector, filter_temp)
    }
    api_query <- paste0(api_query, "&$filter=", paste0(filters_vector, collapse = " and "))
  }

  # fill spaces in with %20
  api_query <- gsub(" ", "%20", api_query)

  return(api_query)
}
