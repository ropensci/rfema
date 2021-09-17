valid_dataset <- function(data_set){
  # get df with info on fema data sets
  fema_data_sets <- fema_data_sets(rfema_access = F)
  
  # convert user specified data set to lower case
  data_set <- tolower(data_set)
  
  # match up user specified data set to data sets in "fema_data_sets"
  # and redefine the "data_set" object to make sure its consistent with the 
  # capitalization fema uses
  match <- fema_data_sets$name[ tolower(fema_data_sets$name) == data_set ]
  if(length(match) == 0){
    stop(paste0(data_set, " is not a valid data set. These are the currently supported data sets: ", paste(fema_data_sets$name, collapse = ", ")))
  } else{
    data_set <- match
  }
  return(data_set)
}