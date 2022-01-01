#' Get data from the FEMA API
#'
#' The function allows users to pull data directly from the FEMA API and have it
#' returned as a data frame natively within R.The FEMA API limits a single
#' query to 1000 records, thus for a query resulting in more than 1000 records,
#' an iterative approach is necessary to get all of the records. The function
#' handles this and will, by default, warn the user of how many iterations are
#' needed to get all the records matching their query, letting the user decide
#' choose whether to continue.
#'
#' @param data_set a character string indicating the data set to get data from
#' @param top_n an optional integer value to specify the maximum number of
#' matching records to return
#' @param filters an optional list containing values of the data fields
#' contained in the data set to construct filters from
#' @param select  an optional character vector to specify which data fields to
#' return (default is to return all data fields)
#' @param ask_before_call a logical indicating if users should be asked if they
#'  would like to proceed when an API call results in
#' a large number of records (default is T).
#' @param file_type  an optional character string that specifies a file type to
#'  save the data as (options are "csv" and "rds"). If a file
#' is specified, the function will not return the api call as a data frame
#' @param output_dir  an optional character string specifying the directory to
#' save the exported file if the file_type is specified
#' (defaults to working directory).
#' @return Returns a tibble containing the data from the FEMA API.
#' @import  httr
#' @importFrom dplyr bind_rows
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' data <- open_fema(
#'   data_set = "fimaNfipClaims", top_n = 100,
#'   filters = list(countyCode = "10001")
#' )
open_fema <- function(data_set, top_n = NULL, filters = NULL,
                              select = NULL, ask_before_call = T,
                              file_type = NULL, output_dir = NULL) {

  # return specific errors for edge case top_n arguments
  if (is.null(top_n) == F) {
    if (top_n == 0) {
      stop(paste0("Setting top_n = 0 wont return any records. Set top_n to a value greater than 0"))
    }
  }

  # construct the api query using the gen_api_query() function
  api_query <- gen_api_query(
    data_set = data_set,
    top_n = top_n,
    filters = filters,
    select = select
  )

  # if top_n is less than 1000, then call the api without
  # worrying about having to loop to get all matching records
  if (is.null(top_n) == F) {
    if (top_n < 1000) {
      result <- httr::GET(paste0(api_query))
      if (result$status_code != 200) {
        status <- httr::http_status(result)
        stop(status$message)
      }
      json_data <- httr::content(result)[[2]]

      # for data returned as a list of lists, correct any discrepencies in the
      # length of the lists by adding NA values to the shorter lists
      max_list_length <- max(sapply(json_data, length)) # calculate longest list

      # add NA values to lists shorter than the max list length
      json_data <- lapply(json_data, function(x) {
        c(x, rep(NA, max_list_length - length(x)))
      })

      # bind into a single df
      full_data <- data.frame(do.call(rbind, json_data))
    }
  }


  # if top_n is greater than 1000, we will have to loop
  # to make multiple API calls to get all the records
  if (T %in% c(top_n >= 1000, is.null(top_n))) {

    # construct an api call that will be used to determine the number of
    # matching records
    record_check_query <- gen_api_query(
      data_set = data_set,
      top_n = 1,
      filters = filters
    )

    # run the api call and determine the number of matching records
    result <- httr::GET(record_check_query)
    if (result$status_code != 200) {
      status <- httr::http_status(result)
      stop(status$message)
    }
    json_data <- httr::content(result)
    n_records <- json_data$metadata$count

    # calculate number of calls necessary to get all records using the
    # 1000 records/ call max limit defined by FEMA. If the use supplied a
    # top_n argument, calculate the number of iterations with respect to
    # that value.
    if (is.null(top_n)) {
      iterations <- ceiling(n_records / 1000)
    } else {
      iterations <- min(ceiling(top_n / 1000), ceiling(n_records / 1000))
    }

    # if ask_before_call == T and more than 1 iteration will be needed to
    # get the data, inform the user of how many iterations are needed and
    # ask if they want to proceed with the loop
    if (ask_before_call == T & iterations > 1) {
      
      # call the estimate_time function to get an estimated time per API call
      estimated_time <- time_iterations(data_set, iterations)
      
      
      
      # calculate several message for various scenarios
      
      # top_n is less than the matching records 
      message1 <- paste0(n_records, " matching records found. At ",
                                 1000, " records per call, it will take ",iterations,
                                 " individual API calls to get the top ", top_n ," matching records. ",
                                 "It's estimated that this will take approximately ", estimated_time ,". Continue?")
      
      # top_n is not specified or greater than the number of matching records
      message2 <-paste0(n_records, " matching records found. At ",
                       1000, " records per call, it will take ",iterations,
                       " individual API calls to get all matching records. ",
                       "It's estimated that this will take approximately ", estimated_time ,". Continue?")
      
      # send some logging info to the console so we know what is happening
      if(is.null(top_n) == F){
        if(n_records < top_n){
          message(message2)
        } else message(message1)
      } else message(message2)  
        
  
      user_response <- readline(prompt = " 1 - Yes, get that data!, 0 - No, let me rethink my API call: ")

      if (user_response != "1") {
        stop("Opperation aborted by user.")
      }
    }

    # if the number of iterations is greater than 1, start the loop. If only one
    # iteration is needed, do it without entering the loop
    if (iterations > 1) {
      # Loop and call the API endpoint changing the record start each iteration.
      # Each call will return results in a JSON format. The metadata has been
      # suppressed as we no longer need it.
      skip <- 0
      for (i in seq(from = 1, to = iterations, by = 1)) {
        # As above, if you have filters, specific fields, or are sorting, add
        # that to the base URL or make sure it gets concatenated here.
        result <- httr::GET(paste0(api_query, "&$skip=", (i - 1) * 1000))
        if (result$status_code != 200) {
          status <- httr::http_status(result)
          stop(status$message)
        }
        json_data <- httr::content(result)[[2]]

        # for data returned as a list of lists, correct any discrepancies
        # in the length of the lists by adding NA values to the shorter lists

        # calculate longest list
        max_list_length <- max(sapply(json_data, length))

        # add NA values to lists shorter than the max list length
        json_data <- lapply(json_data, function(x) {
          c(x, rep(NA, max_list_length - length(x)))
        })


        if (i == 1) {
          # bind the data into a single data frame
          full_data <- data.frame(do.call(rbind, json_data))
        } else {
          full_data <- dplyr::bind_rows(
            full_data,
            data.frame(do.call(rbind, json_data))
          )
        }


        progress <- paste0("Obtaining Data: ", i, " out of ", iterations, " iterations (" ,round(i/iterations*100,2), "% complete)")
        message('\r', progress, appendLF = FALSE)
        
      }
    } else {
      result <- httr::GET(paste0(api_query))
      if (result$status_code != 200) {
        status <- httr::http_status(result)
        stop(status$message)
      }
      json_data <- httr::content(result)[[2]]

      # for data returned as a list of lists, correct any discrepancies in the
      # length of the lists by adding NA values to the shorter lists
      max_list_length <- max(sapply(json_data, length)) # calculate longest list

      # add NA values to lists shorter than the max list length
      json_data <- lapply(json_data, function(x) {
        c(x, rep(NA, max_list_length - length(x)))
      })

      full_data <- data.frame(do.call(rbind, json_data))
    }


    # if top_n is not null, trim the final output to the right number of rows
    # which may be slightly more than top_n since top_n might not be a multiple
    # of 1000
    if (is.null(top_n) == F) {
      if (nrow(full_data) > top_n) {
        full_data <- full_data[1:(top_n), ]
      }
    }
  }

  # remove the html line breaks from returned data frame (if there are any)
  full_data <- as.data.frame(lapply(
    full_data,
    function(full_data) gsub("\n", "", full_data)
  ))
  
  # convert full_data to a tibble
  full_data <- as_tibble(full_data)
  
  
  # convert dates to POSIXct format before returning the full data
  full_data <- convert_dates(full_data)



  if (is.null(file_type)) {
    return(full_data)
  }

  if (is.null(output_dir)) {
    output_dir <- getwd()
  }

  if (file_type == "rds") {
    saveRDS(full_data, file = paste0(output_dir, "/", data_set, ".rds"))
    message(paste0(
      "Saving data to ",
      paste0(output_dir, "/", data_set, ".rds")
    ))
  }
  if (file_type == "csv") {
    write.table(full_data,
      file = paste0(output_dir, "/", data_set, ".csv"),
      sep = ","
    )
    message(paste0(
      "Saving data to ",
      paste0(output_dir, "/", data_set, ".csv")
    ))
  }
}
