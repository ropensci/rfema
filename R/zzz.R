.onLoad <- function(libname, pkgname) {

  # memoise functions
  open_fema <<- memoise::memoise(open_fema)
  fema_data_fields <<- memoise::memoise(fema_data_fields)
  fema_data_sets <<- memoise::memoise(fema_data_sets)
  valid_dataset <<- memoise::memoise(valid_dataset)
  gen_api_query <<- memoise::memoise(gen_api_query)
  fema_api_endpoints <<- memoise::memoise(fema_api_endpoints)
  parameter_values <<- memoise::memoise(parameter_values)
}
