
# bulk download one of the smaller data sets

# check to see if file is in the folder
test_that("downloaded file is in the specified location", {
  # skip if a connection cannot be established
  skip_if_offline(host = "www.fema.gov")

  # download a file
  bulk_dl("femaregions", output_dir = getwd(), file_name = "test_dl.csv")

  # see if the file is in the directory
  expect_equal("test_dl.csv" %in% list.files(getwd()), T)

  # remove the file from the directory
  file.remove("test_dl.csv")
})


# check to see if file is in the folder
test_that("downloaded file is in the cd if no location is specified", {
  # skip if no connection can be established
  skip_if_offline(host = "www.fema.gov")

  #  download a file
  bulk_dl("femaregions", output_dir = getwd(), file_name = "test_dl.csv")

  # see if file is in the directory
  expect_equal("test_dl.csv" %in% list.files(getwd()), T)

  # remove file
  file.remove("test_dl.csv")
})






# check to see if file is in the folder
test_that("bulk_dl works without specifying file path or file name", {

  # skip if no connection is established
  skip_if_offline(host = "www.fema.gov")

  # download without specifying a file name
  ds <- "femaregions"
  bulk_dl(ds)

  # get name of csv files/rds files in wd
  csv_file <- list.files(getwd(), pattern = ".csv")

  # see if the file was named correctly
  expect_match(paste0(valid_dataset(ds), ".csv"), csv_file)

  # remove the file
  file.remove(csv_file)
})
