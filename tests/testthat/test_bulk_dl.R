
# bulk download one of the smaller data sets
bulk_dl("femaregions", output_dir = getwd(), file_name = "test_dl.csv")

# check to see if file is in the folder
test_that("downloaded file is in the specified location", {
  expect_equal("test_dl.csv" %in% list.files(getwd()),T)
})

# remove file so directory doesn't get cluttered
file.remove("test_dl.csv")





# bulk download one of the smaller data sets without specifying download details
bulk_dl("femaregions", output_dir = getwd(), file_name = "test_dl.csv")

 # check to see if file is in the folder
 test_that("downloaded file is in the cd if no location is specified", {
   expect_equal("test_dl.csv" %in% list.files(getwd()),T)
 })
 
 file.remove("test_dl.csv")
 
 
 
 
 # download without specifying a file name
 ds <- "femaregions"
 bulk_dl(ds)
 
 # get name of csv files/rds files in wd
 csv_file <- list.files(getwd(), pattern = ".csv")

 # check to see if file is in the folder
 test_that("bulk_dl works without specifying file path or file name", {
   expect_match(paste0(valid_dataset(ds),".csv"), csv_file)
 })
 
 file.remove(csv_file)
 

 