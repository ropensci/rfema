
fema_api_endpoints <- function(data_set){
  
  #' Returns the API endpoint associated with a openFEMA data set
  #'
  #' @param data_set A character string with the name of the data set to get the API endpoint for. 
  #'
  #' @return Returns a character string containing the API endpoint url associated with the data set.
  #' @export
  #'
  #' @examples
  #' fema_api_endpoints("FimaNfipClaims")
  #' fema_api_endpoints("fImAnfiPclaims")
  #' fema_api_endpoints("fimanfippolicies")
  
  data_set <- tolower(data_set)
  endpoints <- data.frame(source = c("FimaNfipClaims",
                                     "FimaNfipPolicies",
                                     "HousingAssistanceOwners"), 
                          endpoint = c("https://www.fema.gov/api/open/v1/FimaNfipClaims",
                                       "https://www.fema.gov/api/open/v1/FimaNfipPolicies",
                                       "https://www.fema.gov/api/open/v2/HousingAssistanceOwners"))

  return(endpoints$endpoint[which(tolower(endpoints$source) == data_set)])
}
