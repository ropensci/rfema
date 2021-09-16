parameter_values <- function(data_set = NULL, data_field = NULL){
  data <- openFema(data_set = data_set,top_n = 999, select = data_field, ask_before_call = F)
  values <- unique(data[,data_field])
  return(values)
}

