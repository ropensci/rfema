fema_data_fields <- function(data_set){
  #' Get data fields and descriptions for a given FEMA data set
  #'
  #'
  #' @param data_set a character string indicating the data set of interest
  #'
  #' @return Returns a data frame consisting of the data field name, the data field title, the data type , a description of the data field, and whether it is searchable within an API query.
  #' @export
  #'
  #' @examples 
  #' fema_data_fields("FimaNfipClaims")
  #' fema_data_fields("FimaNfipPolicies")
  #' 
  #' @importFrom dplyr %>%
  
  
  
  
  data_set <- tolower(data_set)
  
  data_set_urls <- data.frame(source = c("FimaNfipClaims","FimaNfipPolicies","HousingAssistanceOwners"),
                              url = c("https://www.fema.gov/openfema-data-page/fima-nfip-redacted-claims-v1",
                                      "https://www.fema.gov/openfema-data-page/fima-nfip-redacted-policies-v1",
                                      "https://www.fema.gov/openfema-data-page/housing-assistance-program-data-owners-v2"))
  
  url <- data_set_urls$url[which( tolower(data_set_urls$source) == data_set)]
  
  page_content <- rvest::read_html(url)
  tables <- page_content %>% rvest::html_table(fill = TRUE)
  
  found_table <- 0
  table_num <- 0
  while(found_table == 0){
    table_num <- table_num + 1
    data_table <- tables[[table_num]]
    if("Is Searchable" %in% colnames(data_table)){
      data_fields <- data_table
      found_table <- 1
    }
    
    if(table_num > length(tables)){
      stop(paste0("Unable to find data fields table from: ",url))
    }
  }
  
  return(data_fields)
}