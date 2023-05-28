#' Helper function to construct status message for `open_fema()` function
#'
#' @param n_records a numeric value indicating the number of matching records
#' in the API call
#' @param iterations numeric value indicating the  number of iterations
#' necessary to retrieve all the data
#' @param top_n numeric value indicating the number of matching records to return
#' @param estimated_time character string indicating the estimated time to
#' complete the API call.
#'
#' @return a character string
#'
#' @noRd
#' @keywords internal
#'
#' @examples \dontrun{
#' rfema:::get_status_message(2000, 2, 1000, "2 minutes")
#' }
get_status_message <- function(n_records, iterations, top_n, estimated_time) {

  # top_n argument is specified and top_n is less than the number of matching
  # records
  if (is.null(top_n) == F) {
    if (n_records < top_n) {
      message <- paste0(
        n_records, " matching records found. At ",
        1000, " records per call, it will take ", iterations,
        " individual API calls to get all matching records. ",
        "It's estimated that this will take approximately ",
        estimated_time, ". Continue?"
      )
    } else {
      # top_n is less than the matching records
      message <- paste0(
        n_records, " matching records found. At ",
        1000, " records per call, it will take ", iterations,
        " individual API calls to get the top ", top_n, " matching records. ",
        "It's estimated that this will take approximately ", estimated_time, ". Continue?"
      )
    }
  }

  # top_n argument is not specified
  if (is.null(top_n)) {
    message <- paste0(
      n_records, " matching records found. At ",
      1000, " records per call, it will take ", iterations,
      " individual API calls to get all matching records. ",
      "It's estimated that this will take approximately ",
      estimated_time, ". Continue?"
    )
  }

  return(message)
}



#' Helper function to convert date columns
#'
#' @param data a tibble returned from open_fema()
#'
#' @return returns a tibble with the columns representing dates converted to
#' POSIXct format
#'
#' @noRd
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' data <- open_fema("fimanfipclaims", top_n = 10)
#' }
#' \dontrun{
#' data_with_dates <- rfema:::convert_dates(data)
#' }
convert_dates <- function(data) {

  # identify columns to convert to date objects based on if "date" is
  # in the column name
  cols_to_convert <- colnames(data)[grepl("date", tolower(colnames(data)))]

  # loop over each column identified above
  for (c in cols_to_convert) {

    # initialize an object to store the converted column
    converted_col <- NULL

    # wrap the following in a tryCatch in case a column was identified above
    # that really shouldn't be converted to a date object
    tryCatch(
      {
        # convert the tibble to a data frame
        to_convert <- data.frame(data)[, c]

        # replace NULL values with NA
        to_convert <- replace(to_convert, to_convert == "NULL", NA)

        # convert to a POSIXct object
        converted_col <- as.POSIXct(to_convert, Sys.timezone())
      },
      error = function(e) {
        cat("ERROR :", conditionMessage(e), "\n")
      }
    )

    # if the converted_col is not empty, go ahead and overwrite the
    # corresponding column in the data
    if (is.null(converted_col) == F) {
      data[, c] <- converted_col
    }
  }

  return(data)
}



#' Helper function to insure data_set parameter matches an open FEMA data
#'  offering.
#'
#' The function corrects any capitalization inconsistencies so that the
#' "data_set" parameter in any of rfema's functions is not case sensitive.
#'
#' @param data_set a character string representing the data set.
#'
#' @return returns the data with capitalization changed to be consistent with
#' FEMA's naming convention or returns an error if the data set is not one of
#' the valid offerings through the FEMA API.
#'
#'
#' @noRd
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' rfema:::valid_dataset("fimanfipclaims")
#' }
#' \dontrun{
#' rfema:::valid_dataset("fIMANfipclaiMS")
#' }
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
    stop(paste0(
      data_set,
      " is not a valid data set. Use fema_data_sets() to return avaliable data sets and associated meta data."
    ))
  } else {
    data_set <- match
  }
  return(as.character(unique(data_set)))
}






#' Helper function to generate the URL string for an API query
#'
#' @param data_set character string specifying the data set to query from
#' @param top_n numeric value indicating how many records to return
#' (default is 1000 which is the maximum number of records the API will return
#' in a single query )
#' @param filters a list containing values of data fields that should be used
#' to construct filters.
#' @param select a character vector of data fields to return
#' (default is to return all data fields for the data set)
#'
#' @noRd
#' @keywords internal
#'
#' @return The function returns a string containing a url that can be used to
#'  query the API.
#'
#' @examples
#' \dontrun{
#' filter_list <- list(baseFloodElevation = c(5, 6), countyCode = "34029")
#' vars_to_select <- c("countyCode", "baseFloodElevation")
#' url <- rfema:::gen_api_query(
#'   data_set = "fimaNfipPolicies", top_n = 100,
#'   filters = filter_list, select = vars_to_select
#' )
#' }
gen_api_query <- function(data_set = NULL, top_n = NULL, filters = NULL,
                          select = NULL) {

  # replace top_n with 1000 if no value is supplied
  if (is.null(top_n)) {
    top_n <- format(1000, scientific=F)  
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
      if (!(T %in% (field == valid_parameters(data_set)))) {
        stop(paste0(
          field, " is not a valid data field for the ", data_set,
          " data set use the valid_parameters() function to view all valid parameters for a data set."
        ))
      }
    }

    api_query <- paste0(api_query, "&$select=", paste(select, collapse = ","))
  }

  # if filters is not NULL, then append the api query to
  # apply those filters
  if (is.null(filters) == F) {

    # check to make sure the fields used to filter are in the selected data set
    params <- valid_parameters(data_set)
    for (field in names(filters)) {
      if (!(T %in% (field == params))) {
        stop(paste0(
          field, " is not a valid data field for the ", data_set,
          " thus cannot be used to construct a filter"
        ))
      }
    }
    filters_n <- length(filters)
    filters_vector <- c()
    for (k in 1:filters_n) {
      operators <- data.frame(
        sym = c("=", ">", "<", "!=", ">=", "<="),
        char = c("eq", "gt", "lt", "ne", "ge", "le")
      )

      op_temp <- NULL
      for (op in operators$sym) {
        if (T %in% grepl(op, filters[[k]])) {
          op_temp <- operators$char[which(operators$sym == op)]
        }
        if (is.null(op_temp)) {
          op_temp <- "eq"
        }
      }

      filter_temp <- trimws(gsub(
        paste(operators$sym, collapse = "|"), "",
        filters[[k]]
      ))
      
     suppressWarnings({
      if(!is.na(as.numeric(filter_temp))){
        filter_temp <- as.numeric(filter_temp)
      }
     })

      if (is.character(filter_temp)) {
        filter_temp <- paste0("(", names(filters)[k], " ", op_temp, " ", noquote(paste0("'", filter_temp, "'", collapse = paste0(" or ", names(filters)[k], " ", op_temp, " "))), ")")
      } else {
        filter_temp <- paste0("(", names(filters)[k], " ", op_temp, " ", noquote(paste0(filter_temp, collapse = paste0(" or ", names(filters)[k], " ", op_temp, " "))), ")")
      }
      filters_vector <- c(filters_vector, filter_temp)
    }
    api_query <- paste0(api_query, "&$filter=", paste0(filters_vector,
      collapse = " and "
    ))
  }

  # fill spaces in with %20
  api_query <- gsub(" ", "%20", api_query)

  return(api_query)
}





#' Helper function that returns the API endpoint associated with an open FEMA
#' data set
#'
#' @noRd
#' @keywords internal
#'
#' @param data_set A character string with the name of the data set to get the
#' API endpoint for.
#'
#' @return Returns a character string containing the API endpoint URL associated
#'  with the data set.
#'
#' @examples
#' \dontrun{
#' rfema:::fema_api_endpoints("FimaNfipClaims")
#' rfema:::fema_api_endpoints("fImAnfiPclaims")
#' rfema:::fema_api_endpoints("fimanfippolicies")
#' }
fema_api_endpoints <- function(data_set) {

  # convert dataset to fema consistent capitalization
  data_set <- unique(valid_dataset(data_set))

  # get df of all fema data sets
  fema_data_sets <- fema_data_sets()

  # get the most current version

  version <- max(as.numeric(fema_data_sets$version[which(data_set == fema_data_sets$name)]))


  endpoint <- paste0("https://www.fema.gov/api/open/v", version, "/", data_set)

  return(endpoint)
}


#' Helper function to estimate time per API call
#'
#' @noRd
#' @keywords internal
#'
#' @param data_set the name of the open FEMA data set to time API calls for
#' @param iterations the number of iterations that need to be performed
#'
#' @return returns a character string detailing the estimated time needed to
#' perform the specified number of API call iterations on the specified data set
#'
#' @examples
#' \dontrun{
#' rfema:::time_iterations("fimanfipclaims", 25)
#' }
time_iterations <- function(data_set, iterations) {

  # number of API calls to make
  api_calls <- 5

  # clear the memoise cache for the given open fema arguments so the function
  # contacts the API rather than returning cached results.
  cache_exists <- memoise::drop_cache(open_fema)(data_set, top_n = api_calls * 1000, ask_before_call = F)

  # get system start time
  start_time <- Sys.time()

  # print message on estimated code time
  message("Calculating estimated API call time...")

  # execute an api call for "data_set" for 5000 records
  data <- suppressMessages(open_fema(data_set, top_n = api_calls * 1000, ask_before_call = F))

  # get system end time
  end_time <- Sys.time()

  # get time difference in seconds
  diff <- as.numeric(end_time - start_time)

  # estimated seconds per iteration
  time_per_itt <- diff / api_calls

  # establish total estimated time given the iterations that need to be run
  total_seconds <- time_per_itt * iterations

  # establish units and convert second to that unit
  units <- "seconds"
  time <- total_seconds
  total_minutes <- 0
  total_hours <- 0
  total_years <- 0
  if (time > 60 & units == "seconds") {
    time <- total_seconds / 60
    units <- "minutes"
  }
  if (time > 60 & units == "minutes") {
    time <- time / 60
    units <- "hours"
  }
  if (time > 24 & units == "hours") {
    time <- time / 24
    units <- "days"
  }

  return(paste(round(time, 2), units))
}
