
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
n_records <- jsonData$metadata$count # there are 2119 records meaning we will need three seperate API calls to get all the data


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
data <- as.data.frame(lapply(data, function(data) gsub("\n", "", data)))
```

Compare the above block of code to the following code which obtains the
same data using the `rfema` package. The `rfema` package allows the same
request to be made with two lines of code. Notably, the `open_fema()`
function handles checking the number of records and implements an
iterative loop to deal with the 1000 records/call limit.

``` r
# define a list of filters to apply
filterList <- list(countyCode = "= 12011",yearOfLoss = ">= 2010", yearOfLoss = "<= 2012")

# make the API call using the `open_fema` function.
data <- rfema::open_fema(data_set = "fimaNfipClaims",ask_before_call = F, filters = filterList )
```

    ## 1 out of 3 itterations completedFALSE

    ## 2 out of 3 itterations completedFALSE

    ## 3 out of 3 itterations completedFALSE

## Installation

Right now, the best way to install and use the `rfema` package is by
installing directly from GitHub using
`devtools::install_github("dylan-turner25/rfema")`. The FEMA API does
not require an API key, meaning no further steps need be taken to start
using the package

## Usage

Use the `fema_data_sets()` function to obtain a data frame of available
data sets along with associated meta data.

``` r
data_sets <- fema_data_sets()

# truncate the description field for purposes of displaying the table
data_sets$description <- paste0(substr(data_sets$description,1,50),"...")

# view just the first three datasets
kable(head(data_sets,3))
```

| identifier  | name                                    | title                                      | description                                         | distribution.accessURL                                                         | distribution.format | distribution.datasetSize | distribution.accessURL.1                                                        | distribution.format.1 | distribution.datasetSize.1 | distribution.accessURL.2                                                         | distribution.format.2 | distribution.datasetSize.2 | webService                                                                 | dataDictionary                                                                           | keyword                                                    | modified                 | publisher                           | contactPoint | mbox                | accessLevel | landingPage                              | temporal    | api  | version | bureauCode | programCode | accessLevelComment | license | spatial | theme                | dataQuality | accrualPeriodicity | language | primaryITInvestmentUII | issued                   | systemOfRecords | deprecated | hash                             | lastRefresh              | recordCount | depApiMessage | depNewURL | depWebMessage | lastDataSetRefresh       | id                       | accessUrl | format | depDate | keyword1 | keyword2 | keyword3 | keyword4 | keyword5 | keyword6 | keyword7 | keyword8 | keyword9 | keyword10 | keyword11 | keyword12 | keyword13 | keyword14 | references |
|:------------|:----------------------------------------|:-------------------------------------------|:----------------------------------------------------|:-------------------------------------------------------------------------------|:--------------------|:-------------------------|:--------------------------------------------------------------------------------|:----------------------|:---------------------------|:---------------------------------------------------------------------------------|:----------------------|:---------------------------|:---------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------|:-----------------------------------------------------------|:-------------------------|:------------------------------------|:-------------|:--------------------|:------------|:-----------------------------------------|:------------|:-----|:--------|:-----------|:------------|:-------------------|:--------|:--------|:---------------------|:------------|:-------------------|:---------|:-----------------------|:-------------------------|:----------------|:-----------|:---------------------------------|:-------------------------|:------------|:--------------|:----------|:--------------|:-------------------------|:-------------------------|:----------|:-------|:--------|:---------|:---------|:---------|:---------|:---------|:---------|:---------|:---------|:---------|:----------|:----------|:----------|:----------|:----------|:-----------|
| openfema-1  | PublicAssistanceFundedProjectsSummaries | Public Assistance Funded Project Summaries | FEMA provides supplemental Federal disaster grant … | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.csv> | csv                 | small (10MB - 50MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.json> | json                  | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.jsona> | jsona                 | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries> | <https://www.fema.gov/openfema-data-page/public-assistance-funded-projects-summaries-v1> | public, assistance, disaster, grant, funding, sub-grantees | 2019-05-30T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/assistance/public> | 1980-02-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Public Assistance    | true        | R/P1D              | en-US    |                        | 2010-01-21T05:00:00.000Z |                 | FALSE      | bd507ed0181bba91866372a0a5d3c3e4 | 2021-11-09T17:36:48.359Z | 171463      |               |           |               | 2021-11-09T17:36:48.359Z | 5dd723598ca22d24d423eb6f | NA        | NA     | NA      | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-1  | PublicAssistanceFundedProjectsSummaries | Public Assistance Funded Project Summaries | FEMA provides supplemental Federal disaster grant … | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.csv> | csv                 | small (10MB - 50MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.json> | json                  | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.jsona> | jsona                 | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries> | <https://www.fema.gov/openfema-data-page/public-assistance-funded-projects-summaries-v1> | public, assistance, disaster, grant, funding, sub-grantees | 2019-05-30T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/assistance/public> | 1980-02-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Public Assistance    | true        | R/P1D              | en-US    |                        | 2010-01-21T05:00:00.000Z |                 | FALSE      | bd507ed0181bba91866372a0a5d3c3e4 | 2021-11-09T17:36:48.359Z | 171463      |               |           |               | 2021-11-09T17:36:48.359Z | 5dd723598ca22d24d423eb6f | NA        | NA     | NA      | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-26 | FemaWebDeclarationAreas                 | FEMA Web Declaration Areas                 | This data set contains general information on decl… | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.csv>                 | csv                 | medium (50MB - 500MB)    | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.json>                 | json                  | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.jsona>                 | jsona                 | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas>                 | <https://www.fema.gov/openfema-data-page/fema-web-declaration-areas-v1>                  | disaster, declaration, fema website                        | 2019-09-26T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/disasters>         | 1960-11-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Disaster Information | true        | R/PT20M            | en-US    |                        | NA                       |                 | FALSE      | 89eaca0ba42130ddbd5477ed92fee30b | 2021-11-09T19:31:35.318Z | 438102      |               |           |               | 2021-11-09T19:31:35.318Z | 5dd723598ca22d24d423eb73 | NA        | NA     | NA      | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |

Once you have the name of the data set you want, simply pass it as an
argument to the `open_fema()` function which will return the data set as
a data frame. By default, `open_fema()` will warn you if the number of
records is greater than 1000 and will ask you to confirm that you want
to retrieve all of the available records (for many data sets the total
records is quite large). To turn off this feature, set the parameter
`ask_before_call` equal to FALSE. To limit the number of records
returned, specify the `top_n` argument. This is useful for exploring a
data set without retrieving all records.

``` r
retrieved_data <- open_fema(data_set = "fimanfipclaims", top_n = 10)

kable(head(retrieved_data))
```

| agricultureStructureIndicator | asOfDate                 | baseFloodElevation | basementEnclosureCrawlspace | reportedCity            | condominiumIndicator | policyCount | countyCode | communityRatingSystemDiscount | dateOfLoss               | elevatedBuildingIndicator | elevationCertificateIndicator | elevationDifference | censusTract | floodZone | houseWorship | latitude | longitude | locationOfContents | lowestAdjacentGrade | lowestFloorElevation | numberOfFloorsInTheInsuredBuilding | nonProfitIndicator | obstructionType | occupancyType | originalConstructionDate | originalNBDate           | amountPaidOnBuildingClaim | amountPaidOnContentsClaim | amountPaidOnIncreasedCostOfComplianceClaim | postFIRMConstructionIndicator | rateMethod | smallBusinessIndicatorBuilding | state | totalBuildingInsuranceCoverage | totalContentsInsuranceCoverage | yearOfLoss | reportedZipcode | primaryResidence | id                       |
|:------------------------------|:-------------------------|:-------------------|:----------------------------|:------------------------|:---------------------|:------------|:-----------|:------------------------------|:-------------------------|:--------------------------|:------------------------------|:--------------------|:------------|:----------|:-------------|:---------|:----------|:-------------------|:--------------------|:---------------------|:-----------------------------------|:-------------------|:----------------|:--------------|:-------------------------|:-------------------------|:--------------------------|:--------------------------|:-------------------------------------------|:------------------------------|:-----------|:-------------------------------|:------|:-------------------------------|:-------------------------------|:-----------|:----------------|:-----------------|:-------------------------|
| FALSE                         | 2021-07-25T01:39:04.381Z | NULL               | NULL                        | Temporarily Unavailable | N                    | 1           | 30009      | NULL                          | 2011-07-12T04:00:00.000Z | TRUE                      | NULL                          | NULL                | 30009000300 | AE        | FALSE        | 45.2     | -109.2    | 0                  | NULL                | 0                    | 2                                  | FALSE              | 50              | 1             | 1975-01-01T05:00:00.000Z | 2011-04-13T04:00:00.000Z | 593.5                     | NULL                      | NULL                                       | FALSE                         | 1          | FALSE                          | MT    | 150000                         | 0                              | 2011       | 59068           | TRUE             | 6175bc553f4df1156c4c42d1 |
| FALSE                         | 2021-07-25T01:39:04.381Z | NULL               | 1                           | Temporarily Unavailable | N                    | 1           | 24033      | 5                             | 2007-01-01T05:00:00.000Z | FALSE                     | NULL                          | NULL                | 24033801600 | X         | FALSE        | 38.8     | -77.0     | 0                  | NULL                | 0                    | 3                                  | FALSE              | NULL            | 1             | 1953-01-01T05:00:00.000Z | 2006-11-15T05:00:00.000Z | NULL                      | NULL                      | NULL                                       | FALSE                         | 7          | FALSE                          | MD    | 100000                         | 40000                          | 2007       | 20745           | TRUE             | 6175bc553f4df1156c4c42d0 |
| FALSE                         | 2021-07-25T01:39:04.381Z | NULL               | 2                           | Temporarily Unavailable | N                    | 1           | 29189      | NULL                          | 2008-09-13T04:00:00.000Z | FALSE                     | NULL                          | NULL                | 29189215700 | AE        | FALSE        | 38.7     | -90.3     | 0                  | NULL                | 0                    | 2                                  | FALSE              | NULL            | 1             | 1957-01-01T05:00:00.000Z | 1996-02-08T05:00:00.000Z | 118224.96                 | 26300                     | NULL                                       | FALSE                         | 1          | FALSE                          | MO    | 250000                         | 0                              | 2008       | 63130           | TRUE             | 6175bc553f4df1156c4c42d6 |
| FALSE                         | 2021-07-25T01:39:04.381Z | NULL               | NULL                        | Temporarily Unavailable | N                    | 1           | 12086      | 10                            | 1992-08-24T04:00:00.000Z | FALSE                     | 3                             | 2                   | 12086008405 | AE        | FALSE        | 25.7     | -80.3     | 0                  | NULL                | 0                    | 1                                  | FALSE              | 10              | 1             | 1988-01-01T05:00:00.000Z | 1988-06-15T04:00:00.000Z | NULL                      | NULL                      | NULL                                       | TRUE                          | 1          | FALSE                          | FL    | 185000                         | 52500                          | 1992       | 33176           | FALSE            | 6175bc553f4df1156c4c42d7 |
| FALSE                         | 2021-07-25T01:39:04.381Z | NULL               | NULL                        | Temporarily Unavailable | N                    | 1           | 48201      | 7                             | 1989-08-01T04:00:00.000Z | FALSE                     | NULL                          | NULL                | 48201350400 | X         | FALSE        | 29.6     | -95.2     | 0                  | NULL                | 0                    | 3                                  | FALSE              | 10              | 1             | 1974-12-31T05:00:00.000Z | 1984-12-20T05:00:00.000Z | NULL                      | NULL                      | NULL                                       | FALSE                         | 1          | FALSE                          | TX    | 88700                          | 25600                          | 1989       | 77089           | FALSE            | 6175bc553f4df1156c4c42d8 |
| FALSE                         | 2021-07-25T01:39:04.381Z | NULL               | NULL                        | Temporarily Unavailable | N                    | 1           | 51810      | 7                             | 1998-02-05T05:00:00.000Z | FALSE                     | NULL                          | NULL                | 51810045412 | X         | FALSE        | 36.7     | -75.9     | 0                  | NULL                | 0                    | 2                                  | FALSE              | 10              | 1             | 1984-07-01T04:00:00.000Z | 1988-09-23T04:00:00.000Z | 342.57                    | NULL                      | NULL                                       | TRUE                          | 1          | FALSE                          | VA    | 185000                         | 60000                          | 1998       | 23456           | TRUE             | 6175bc553f4df1156c4c42d9 |

There are a variety of other ways to more precisely target the data you
want to retrieve by specifying how many records you want returned,
specifying which columns in a data set to return, and applying filters
to any of the columns in a data set. For more information and examples
of use cases, see the [Getting
Started](docs/articles/getting_started.html) vignette.
