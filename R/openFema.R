



openFema <- function(data_set, top_n, filters, select, ask_before_call = T){
  
  # export parameters to the gen_api_query which generates the url string 
  # to use when generating a query
  api_query <- gen_api_query(data_set = data_set,
                             top_n = top_n,
                             filters = filters,
                             select = select)
  
  
  # Determine record count.  
  record_check_query  <- gen_api_query(data_set = data_set,
                                                   top_n = 1,
                                                   filters = filters,
                                                   select = "id")

  result <- httr::GET(record_check_query)
  jsonData <- httr::content(result)        
  n_records <- jsonData$metadata$count
  
  # calculate number of calls neccesary to get all records
  itterations <- ceiling(n_records / top_n)
  
  if(ask_before_call == T){
    # send some logging info to the console so we know what is happening
    print(paste0(n_records, " matching records found. At ", top_n, " records per call, it will take ", itterations," individual API calls to get all matching records. Continue?"),quote=FALSE)
    
    user_response <- readline(prompt=" 1 - Yes, get that data!, 0 - No, let me rething my API call:")
    
    if(user_response == "0"){
      stop("Opperation aborted by user.")
    }
  }
  
  if(itterations > 1){
    # Loop and call the API endpoint changing the record start each iteration. Each call will
    # return results in a JSON format. The metadata has been suppressed as we no longer need it.
    skip <- 0
    for(i in seq(from=1, to=itterations, by=1)){
      # As above, if you have filters, specific fields, or are sorting, add that to the base URL 
      #   or make sure it gets concatenated here.
      result <- httr::GET(paste0(api_query,"&$skip=",(i-1) * top_n))
      jsonData <- httr::content(result)         # should automatically parse as JSON as that is mime type
      
      if(i == 1){
        fullData <- dplyr::bind_rows(jsonData[[2]])
      } else {
        fullData <- dplyr::bind_rows(fullData, dplyr::bind_rows(jsonData[[2]]))
      }
      
      
    
      print(paste0(i," out of ",itterations," itterations completed"), quote=FALSE)
      
    }
  } else {
    result <- httr::GET(paste0(api_query))
    jsonData <- httr::content(result)         
    fullData <- dplyr::bind_rows(jsonData[[2]])
  }
  
  return(fullData)

}


# filter_list <- list(baseFloodElevation = c(1,2,3),
#                     countyCode = "51023" )
# filters <- filter_list
# data_set <- "fimaNfipPolicies"
# top_n = 1000
# select = c("censusTract","countyCode","baseFloodElevation")
# 
# filter_list <- list(countyCode = "51023" )
# 
# 
# data <- openFema(data_set = "fimaNfipPolicies",
#                  top_n = 1000,
#                  filters = filter_list,
#                  select = NULL,
#                  ask_before_call = T)