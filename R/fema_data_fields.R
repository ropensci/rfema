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
  
  # convert data_set to fema consistent capitalization
  data_set <- valid_dataset(data_set)
  
  # get df of all fema data sets
  fema_data_sets <- fema_data_sets()
  
  # determine most recent version of the data set
  version <- as.character(max(as.numeric(fema_data_sets[which(fema_data_sets$name == data_set),"version"])))
  
<<<<<<< HEAD
  # get url for the data dictionary from the fema_data_sets variable using most recent version of data set
  url <- fema_data_sets$dataDictionary[ which( fema_data_sets$name == data_set & 
                                                 fema_data_sets$version == version ) ]
=======
  # get url for the data dictionary from the fema_data_sets variable
  url <- fema_data_sets$dataDictionary[ which( fema_data_sets$name == data_set ) ]
>>>>>>> 0d62dda3756309cbb7399f46314b7742f907182d
  
  # get page content from the data dictionary url
  page_content <- rvest::read_html(url)
  
  # get just the tables
  tables <- page_content %>% rvest::html_table(fill = TRUE)
  
  # search each table itteratively untill the one holding the data descriptions is found
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