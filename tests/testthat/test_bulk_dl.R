
# bulk download one of the smaller data sets
bulk_dl("femaregions", output_dir = getwd(), file_name = "test_dl.csv")

# check to see if file is in the folder
test_that("downloaded file is in the specified location", {
  expect_equal("test_dl.csv" %in% list.files(getwd()),T)
})

# remove file so directory doesn't get cluttered
 file.remove("test_dl.csv")
