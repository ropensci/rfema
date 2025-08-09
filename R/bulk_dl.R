#' Bulk download full open FEMA data sets as .csv files
#'
#' Deprecated function for downloading full open FEMA data sets as .csv files. 
#' 
#' @param data_set A character string indicating the name of the data set
#' to download
#' @param output_dir An optional character string indicating the
#' directory (defaults to working directory)
#' @param file_name An optional character string indicating the file
#' name (defaults to data set name with time stamp)
#' @param size_warning A logical indicating whether to issue a warning
#' before proceeding with downloading a large file (default is TRUE)
#' @return Returns a downloaded csv file of the data set to the
#' specified output directory.
#' @importFrom utils download.file
#' @export
#' @examples
#' \dontrun{
#' bulk_dl("femaregions") # download the file
#' }
#' \dontrun{
#' file.remove("FemaRegions.csv") # clean up directory after file downloads
#' }
bulk_dl <- function(data_set, output_dir = NULL, file_name = NULL, size_warning = TRUE) {

  stop("As of August 2025, bulk data files are no longer hosted on FEMA's website. Data access now requires use of the API using the `openFEMA` function.")
  
}
