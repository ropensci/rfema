

rfema 0.0.1.9000 (2021-12-28)
=========================
### NEW FEATURES 

### DOCUMENTATION FIXES

* TODO: emphasize in readme that no API is needed

* TODO: link FEMA data sets webpage in README when talking about fema_data_sets()
  - also add link in vignette and helpfile
  
* TODO: remove the use of kable() in the readme and vignettes

* TODO: fix link to R-CMD-check badge
  - DONE
  
* TODO: proofread readme, vignette, and function docs (devtools::spell_check())

* TODO: fix documentation for bulk_dl()

* TODO: make sure functions in helpers.R are NOT exported
  - DONE

* TODO: make sure there are links in the README to the Contributing file. 

* TODO: include issues template in README using usethis::use_tidy_issue_template()

* TODO: update DESCRIPTION file to include reviewers (who want to be acknowledged)

* TODO: clarify that the first block of code in the readme is without the package (pull request)
  - DONE:

* TODO: pre-compile vignette and make available from R console https://ropensci.org/blog/2019/12/08/precompute-vignettes/

* TODO: use TRUE/FALSE in the documentation

* TODO: The link to the code of conduct from the CONTRIBUTING file is broken. (need to fix)

### MINOR IMPROVEMENTS

* TODO: Convert all output to tibbles
  - DONE: all exported functions return tibbles now

* TODO: Add a estimate time option in open_fema
  - DONE:

* TODO: Format returned date and time columns as POSIX 
  - DONE:
    
* TODO: investigate if parameter_values() function can obtain all parameter values
  - DONE: changed scope of the function to just report the description and several examples of the data set
 
* TODO: using remotes instead of devtools for installation (pull request)
  - DONE:

* TODO: memoization in .onLoad function (https://memoise.r-lib.org/reference/memoise.html#details)
  - DONE:

### BUG FIXES 

* TODO: fix bug in iteration printout (prints FALSE)
  - DONE:

* TODO: alter iteration printout to overwrite each iteration
    - maybe add (percentage complete too)
      -DONE:
    
* TODO: wrap examples in \dontrun{} to avoid CRAN check failures
    


rfema 0.0.0.9000 (2021-11-19)
=========================

### DOCUMENTATION FIXES
* Added a NEWS.md file 

<!-- ### NEW FEATURES -->

<!--   * New function added `do_things()` to do things (#5) -->

<!-- ### MINOR IMPROVEMENTS -->

 
<!--   * Improved documentation for `things()` (#4) -->

<!-- ### BUG FIXES -->

  
<!--   * Fix parsing bug in `stuff()` (#3) -->

<!-- ### DEPRECATED AND DEFUNCT -->

<!--   * `hello_world()` now deprecated and will be removed in a -->
<!--      future version, use `hello_mars()` -->

<!-- ### DOCUMENTATION FIXES -->

<!--   * Adding a NEWS.md file -->

<!-- ### (a special: any heading grouping a large number of changes under one thing) -->

<!--     * blablabla. -->

