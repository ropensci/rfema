fema_api_endpoints <- function(data_set){
  data_set <- tolower(data_set)
  endpoints <- data.frame(source = c("FimaNfipClaims"), endpoint = c("https://www.fema.gov/api/open/v1/FimaNfipClaims"))

  return(endpoints$endpoint[which(tolower(endpoints$source) == data_set)])
}
