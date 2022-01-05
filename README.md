
-   [rfema (R FEMA)](#rfema-r-fema)
-   [Introduction](#introduction)
-   [Why rfema?](#why-rfema)
-   [Installation](#installation)
-   [Usage](#usage)

## rfema (R FEMA)

[![R-CMD-check](https://github.com/dylan-turner25/rfema/workflows/R-CMD-check/badge.svg)](https://github.com/dylan-turner25/rfema/actions)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Codecov test
coverage](https://codecov.io/gh/dylan-turner25/rfema/branch/main/graph/badge.svg)](https://codecov.io/gh/dylan-turner25/rfema?branch=main)
[![Status at rOpenSci Software Peer
Review](https://badges.ropensci.org/484_status.svg)](https://github.com/ropensci/software-review/issues/484)

<!-- badges: start -->

<!-- [![R-CMD-check](https://github.com/dylan-turner25/rfema/workflows/R-CMD-check/badge.svg)](https://github.com/dylan-turner25/rfema/actions) -->
<!-- badges: end -->

## Introduction

`rfema` allows users to access The Federal Emergency Management Agency’s
(FEMA) publicly available data through the open FEMA API. The package
provides a set of functions to easily navigate and access all data sets
provided by FEMA, including (but not limited to) data from the National
Flood Insurance Program and FEMA’s various disaster aid programs.

FEMA data is publicly available at the open FEMA website
(<https://www.fema.gov/about/openfema/data-sets>) and is avaliable for
bulk download, however, the files are sometimes very large (multiple
gigabytes) and many times users do not need all records for a data
series (for example: many users may only want records for a single state
for several years). Using FEMA’s API is a good option to circumvent
working with the bulk data files, but can be inaccessible for those
without prior API experience. This package contains a set of functions
that allows users to easily identify and retrieve data from FEMA’s API
without needing any technical knowledge of APIs.

In accordance with the Open Fema terms and conditions: This product uses
the Federal Emergency Management Agency’s Open FEMA API, but is not
endorsed by FEMA. The Federal Government or FEMA cannot vouch for the
data or analyses derived from these data after the data have been
retrieved from the Agency’s website(s). Guidance on FEMA’s preferred
citation for Open FEMA data can be found at:
<https://www.fema.gov/about/openfema/terms-conditions>

## Why rfema?

What are the advantages of accessing the FEMA API through the `rfema`
package as compared to accessing the API directly? In short, the `rfema`
package handles much of the grunt work associated with constructing API
queries, dealing with API limits, and applying filters or other
parameters. Suppose one wants to obtain data on all of the flood
insurance claims in Broward County, FL between 2010 and 2012. The
following code obtains that data without the use of the `rfema` package.
As can be seen it requires quite a few lines of code, in part due to the
API limiting calls to 1000 records per call which can make obtaining a
full data set cumbersome.

``` r
# Code needed to obtain data on flood insurance claims in Broward County, FL without the rfema package ------------------

# define the url for the appropriate api end point
base_url <- "https://www.fema.gov/api/open/v1/FimaNfipClaims"

# append the base_url to apply filters
filters <- "?$inlinecount=allpages&$top=1000&$filter=(countyCode%20eq%20'12011')%20and%20(yearOfLoss%20ge%20'2010')%20and%20(yearOfLoss%20le%20'2012')"

api_query <- paste0(base_url, filters)

# run a query setting the top_n parameter to 1 to check how many records match the filters
record_check_query <- "https://www.fema.gov/api/open/v1/FimaNfipClaims?$inlinecount=allpages&$top=1&$select=id&$filter=(countyCode%20eq%20'12011')%20and%20(yearOfLoss%20ge%20'2010')%20and%20(yearOfLoss%20le%20'2012')"

# run the api call and determine the number of matching records
result <- httr::GET(record_check_query)
jsonData <- httr::content(result)        
n_records <- jsonData$metadata$count 


# calculate number of calls neccesary to get all records using the 
# 1000 records/ call max limit defined by FEMA
itterations <- ceiling(n_records / 1000)
  

for(i in seq(from=1, to=itterations, by=1)){
  # As above, if you have filters, specific fields, or are sorting, add that to the base URL 
  #   or make sure it gets concatenated here.
  result <- httr::GET(paste0(api_query,"&$skip=",(i-1) * 1000))
  jsonData <- httr::content(result)         
  
  if(i == 1){
    data <- dplyr::bind_rows(jsonData[[2]])
  } else {
    data <- dplyr::bind_rows(data, dplyr::bind_rows(jsonData[[2]]))
  }
  


}
 
  
# remove the html line breaks from returned data frame (if there are any)  
data <- as_tibble(lapply(data, function(data) gsub("\n", "", data)))

# view the retrieved data
data
```

    ## # A tibble: 2,119 × 39
    ##    agricultureStruct… asOfDate   baseFloodElevat… reportedCity  condominiumIndi…
    ##    <chr>              <chr>      <chr>            <chr>         <chr>           
    ##  1 FALSE              2021-07-2… 8                Temporarily … N               
    ##  2 FALSE              2021-09-0… 6                Temporarily … N               
    ##  3 FALSE              2021-09-0… 4                Temporarily … N               
    ##  4 FALSE              2021-09-0… 6                Temporarily … N               
    ##  5 FALSE              2021-09-0… <NA>             Temporarily … H               
    ##  6 FALSE              2021-09-0… 6                Temporarily … N               
    ##  7 FALSE              2021-07-0… <NA>             Temporarily … N               
    ##  8 FALSE              2021-07-0… 7                Temporarily … N               
    ##  9 FALSE              2021-07-0… 7                Temporarily … N               
    ## 10 FALSE              2021-09-0… <NA>             Temporarily … N               
    ## # … with 2,109 more rows, and 34 more variables: policyCount <chr>,
    ## #   countyCode <chr>, communityRatingSystemDiscount <chr>, dateOfLoss <chr>,
    ## #   elevatedBuildingIndicator <chr>, elevationDifference <chr>,
    ## #   censusTract <chr>, floodZone <chr>, houseWorship <chr>, latitude <chr>,
    ## #   longitude <chr>, locationOfContents <chr>, lowestAdjacentGrade <chr>,
    ## #   lowestFloorElevation <chr>, numberOfFloorsInTheInsuredBuilding <chr>,
    ## #   nonProfitIndicator <chr>, occupancyType <chr>, …

Compare the above block of code to the following code which obtains the
same data using the `rfema` package. The `rfema` package allows the same
request to be made with two lines of code. Notably, the `open_fema()`
function handles checking the number of records and implements an
iterative loop to deal with the 1000 records/call limit.

``` r
# define a list of filters to apply
filterList <- list(countyCode = "= 12011",yearOfLoss = ">= 2010", yearOfLoss = "<= 2012")

# make the API call using the `open_fema` function.
data <- rfema::open_fema(data_set = "fimaNfipClaims",ask_before_call = F, filters = filterList)
```

    ## Obtaining Data: 1 out of 3 iterations (33.33% complete) Obtaining Data: 2 out
    ## of 3 iterations (66.67% complete) Obtaining Data: 3 out of 3 iterations (100%
    ## complete)

``` r
# view data
data
```

    ## # A tibble: 2,119 × 40
    ##    agricultureStructur… asOfDate            baseFloodElevati… basementEnclosure…
    ##    <chr>                <dttm>              <chr>             <chr>             
    ##  1 FALSE                2021-07-25 00:00:00 8                 NULL              
    ##  2 FALSE                2021-09-02 00:00:00 6                 0                 
    ##  3 FALSE                2021-09-02 00:00:00 4                 0                 
    ##  4 FALSE                2021-09-02 00:00:00 6                 0                 
    ##  5 FALSE                2021-09-02 00:00:00 NULL              NULL              
    ##  6 FALSE                2021-09-02 00:00:00 6                 NULL              
    ##  7 FALSE                2021-07-04 00:00:00 NULL              NULL              
    ##  8 FALSE                2021-07-04 00:00:00 7                 NULL              
    ##  9 FALSE                2021-07-04 00:00:00 7                 NULL              
    ## 10 FALSE                2021-09-02 00:00:00 NULL              0                 
    ## # … with 2,109 more rows, and 36 more variables: reportedCity <chr>,
    ## #   condominiumIndicator <chr>, policyCount <chr>, countyCode <chr>,
    ## #   communityRatingSystemDiscount <chr>, dateOfLoss <dttm>,
    ## #   elevatedBuildingIndicator <chr>, elevationCertificateIndicator <chr>,
    ## #   elevationDifference <chr>, censusTract <chr>, floodZone <chr>,
    ## #   houseWorship <chr>, latitude <chr>, longitude <chr>,
    ## #   locationOfContents <chr>, lowestAdjacentGrade <chr>, …

## Installation

Right now, the best way to install and use the `rfema` package is by
installing directly from GitHub using
`remotes::install_github("dylan-turner25/rfema")`. The FEMA API does not
require an API key, meaning no further steps need be taken to start
using the package

## Usage

Use the `fema_data_sets()` function to obtain a tibble of available data
sets along with associated meta data.

``` r
data_sets <- fema_data_sets()

# view the just retrieved data
data_sets
```

    ## # A tibble: 37 × 64
    ##    identifier  name    title   description   distribution.acce… distribution.fo…
    ##    <chr>       <chr>   <chr>   <chr>         <chr>              <chr>           
    ##  1 openfema-1  Public… Public… FEMA provide… https://www.fema.… csv             
    ##  2 openfema-1  Public… Public… FEMA provide… https://www.fema.… csv             
    ##  3 openfema-26 FemaWe… FEMA W… This data se… https://www.fema.… csv             
    ##  4 openfema-28 Hazard… Hazard… This dataset… https://www.fema.… csv             
    ##  5 openfema-36 FemaRe… FEMA R… Provides the… https://www.fema.… csv             
    ##  6 openfema-22 Emerge… Emerge… This dataset… https://www.fema.… csv             
    ##  7 openfema-45 Hazard… Hazard… The dataset … https://www.fema.… csv             
    ##  8 openfema-12 Housin… Housin… This dataset… https://www.fema.… csv             
    ##  9 openfema-8  DataSe… OpenFE… Metadata for… https://www.fema.… csv             
    ## 10 openfema-37 Hazard… Hazard… This dataset… https://www.fema.… csv             
    ## # … with 27 more rows, and 58 more variables: distribution.datasetSize <chr>,
    ## #   distribution.accessURL.1 <chr>, distribution.format.1 <chr>,
    ## #   distribution.datasetSize.1 <chr>, distribution.accessURL.2 <chr>,
    ## #   distribution.format.2 <chr>, distribution.datasetSize.2 <chr>,
    ## #   webService <chr>, dataDictionary <chr>, keyword <chr>, modified <chr>,
    ## #   publisher <chr>, contactPoint <chr>, mbox <chr>, accessLevel <chr>,
    ## #   landingPage <chr>, temporal <chr>, api <chr>, version <chr>, …

Once you have the name of the data set you want, simply pass it as an
argument to the `open_fema()` function which will return the data set as
a tibble. By default, `open_fema()` will warn you if the number of
records is greater than 1000 and present an estimated time required to
complete the records request. As the user, you will the be asked to
confirm that you want to retrieve all of the available records (for many
data sets the total records is quite large). To turn off this feature,
set the parameter `ask_before_call` equal to FALSE. To limit the number
of records returned, specify the `top_n` argument. This is useful for
exploring a data set without retrieving all records.

``` r
# obtain the first 10 records from the fimaNfipClaims data set.
# Note: the data_set argument is not case sensative
retrieved_data <- open_fema(data_set = "fimanfipclaims", top_n = 10)

# view the data
retrieved_data
```

    ## # A tibble: 10 × 40
    ##    agricultureStructur… asOfDate            baseFloodElevati… basementEnclosure…
    ##    <chr>                <dttm>              <chr>             <chr>             
    ##  1 FALSE                2021-07-25 00:00:00 7                 NULL              
    ##  2 FALSE                2021-07-25 00:00:00 NULL              1                 
    ##  3 FALSE                2021-07-25 00:00:00 NULL              NULL              
    ##  4 FALSE                2021-09-30 00:00:00 5                 NULL              
    ##  5 FALSE                2021-07-25 00:00:00 11                NULL              
    ##  6 FALSE                2021-07-25 00:00:00 NULL              NULL              
    ##  7 FALSE                2021-07-25 00:00:00 NULL              NULL              
    ##  8 FALSE                2021-07-25 00:00:00 NULL              NULL              
    ##  9 FALSE                2021-07-25 00:00:00 NULL              NULL              
    ## 10 FALSE                2021-07-25 00:00:00 49                NULL              
    ## # … with 36 more variables: reportedCity <chr>, condominiumIndicator <chr>,
    ## #   policyCount <chr>, countyCode <chr>, communityRatingSystemDiscount <chr>,
    ## #   dateOfLoss <dttm>, elevatedBuildingIndicator <chr>,
    ## #   elevationCertificateIndicator <chr>, elevationDifference <chr>,
    ## #   censusTract <chr>, floodZone <chr>, houseWorship <chr>, latitude <chr>,
    ## #   longitude <chr>, locationOfContents <chr>, lowestAdjacentGrade <chr>,
    ## #   lowestFloorElevation <chr>, numberOfFloorsInTheInsuredBuilding <chr>, …

There are a variety of other ways to more precisely target the data you
want to retrieve by specifying how many records you want returned,
specifying which columns in a data set to return, and applying filters
to any of the columns in a data set. For more information and examples
of use cases, see the [Getting
Started](docs/articles/getting_started.html) vignette.
