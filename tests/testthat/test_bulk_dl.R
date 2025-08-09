
# bulk download one of the smaller data sets

# check to see if file is in the folder
test_that("bulk download function returns a deprecation warning", {
  # skip if a connection cannot be established
  skip_if_offline(host = "www.fema.gov")

  # download a file
  expect_error(bulk_dl("femaregions", output_dir = getwd(), file_name = "test_dl.csv"))

  
})

