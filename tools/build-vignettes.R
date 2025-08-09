
# Build Vignettes Script
# This script knits .Rmd.orig files to create both .Rmd and .md outputs
# for package vignettes and pkgdown documentation

library(knitr)
library(rmarkdown)

# Set working directory to package root
if (basename(getwd()) == "tools") {
  setwd("..")
}

# Find all .Rmd.orig files
orig_files <- list.files("vignettes", pattern = "\\.Rmd\\.orig$", full.names = TRUE)

if (length(orig_files) == 0) {
  stop("No .Rmd.orig files found in vignettes directory.")
}

# Process each .Rmd.orig file
for (orig_file in orig_files) {
  # Get base name without .orig extension
  base_name <- sub("\\.Rmd\\.orig$", "", basename(orig_file))
  rmd_output <- file.path("vignettes", paste0(base_name, ".Rmd"))
  md_output <- file.path("vignettes", paste0(base_name, ".md"))
  
  # Read original file
  orig_content <- readLines(orig_file)
  
  # Find YAML header end
  yaml_end <- which(orig_content == "---")[2]
  yaml_header <- orig_content[1:yaml_end]
  content_body <- orig_content[(yaml_end + 1):length(orig_content)]
  
  # Knit to .Rmd with executed output
  knitr::knit(orig_file, output = rmd_output, quiet = TRUE)
  
  # Create temporary .Rmd file with github_document output
  temp_md_rmd <- file.path("vignettes", paste0(base_name, "_temp.Rmd"))
  
  # Read the original file content
  orig_lines <- readLines(orig_file)
  
  # Replace output format in YAML
  yaml_end_line <- which(orig_lines == "---")[2]
  for (i in 1:yaml_end_line) {
    if (grepl("^output:", orig_lines[i])) {
      orig_lines[i] <- "output: github_document"
    }
  }
  
  # Write temporary file
  writeLines(orig_lines, temp_md_rmd)
  
  # Render to markdown
  rmarkdown::render(temp_md_rmd, 
                    output_file = basename(md_output),
                    output_dir = "vignettes",
                    quiet = TRUE)
  
  # Clean up temp file
  unlink(temp_md_rmd)
}