
## rfema (R FEMA)

\[![R-CMD-check](https://github.com/ropensci/ijtiff/workflows/R-CMD-check/badge.svg)\]

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

## Introduction

`rfema` allows users to access The Federal Emergency Management Agency’s
(FEMA) publicly available data through their API. The package provides a
set of functions to easily navigate and access data from the National
Flood Insurance Program along with FEMA’s various disaster aid programs,
including (but not limited to) the Hazard Mitigation Grant Program, the
Public Assistance Grant Program, and the Individual Assistance Grant
Program.

FEMA data is publicly available at the open FEMA website
(<https://www.fema.gov/about/openfema/data-sets>) and is avaliable for
bulk download, however, the files are sometimes very large (multiple
gigabytes) and many times users do not need all records for a data
series (for example: many users may only want a single state for several
years). Using FEMA’s API is a good option to circumvent working with the
bulk data files, but can be intimidating for those not used to working
with APIs. This package contains a set of functions that allows users to
identify the data they need and query the API to get that data.

In accordance with the openFEMA terms and conditions: This product uses
the Federal Emergency Management Agency’s OpenFEMA API, but is not
endorsed by FEMA. The Federal Government or FEMA cannot vouch for the
data or analyses derived from these data after the data have been
retrieved from the Agency’s website(s). Guidance on FEMA’s preffered
citation for openFEMA data can be found at:
<https://www.fema.gov/about/openfema/terms-conditions>

## Installation

Anyone who stumbles upon this package and wants to use it right now can
do so by cloning this GitHub repo or by using the `install_github()`
function from the devtools package.

``` r
install.packages("devtools") # install if not already in library
```

    ## Installing package into '/home/dylan/R/x86_64-pc-linux-gnu-library/4.1'
    ## (as 'lib' is unspecified)

``` r
devtools::install_github("dylan-turner25/rfema", force = TRUE)
```

    ## Downloading GitHub repo dylan-turner25/rfema@HEAD

    ## 
    ##      checking for file ‘/tmp/RtmpRA7NM5/remotes139b920b55b1b/dylan-turner25-rfema-df4f80a/DESCRIPTION’ ...  ✓  checking for file ‘/tmp/RtmpRA7NM5/remotes139b920b55b1b/dylan-turner25-rfema-df4f80a/DESCRIPTION’
    ##   ─  preparing ‘rfema’:
    ##      checking DESCRIPTION meta-information ...  ✓  checking DESCRIPTION meta-information
    ##   ─  checking for LF line-endings in source and make files and shell scripts
    ##   ─  checking for empty or unneeded directories
    ##    Omitted ‘LazyData’ from DESCRIPTION
    ##   ─  building ‘rfema_0.0.0.9000.tar.gz’
    ##      
    ## 

    ## Installing package into '/home/dylan/R/x86_64-pc-linux-gnu-library/4.1'
    ## (as 'lib' is unspecified)

``` r
library(rfema)
```

## Supported Datasets

Below is a short description of the data sets that are currently
supported. `rfema` is designed to work with any of FEMAs data sets, but
the following data sets have been explicitly tested.

| data\_set        | title                       | dataDictionary                                                           | size                 | recordCount |
|:-----------------|:----------------------------|:-------------------------------------------------------------------------|:---------------------|:------------|
| FimaNfipPolicies | FIMA NFIP Redacted Policies | <https://www.fema.gov/openfema-data-page/fima-nfip-redacted-policies-v1> | x-large (&gt; 10GB)  | 59341663    |
| FimaNfipClaims   | FIMA NFIP Redacted Claims   | <https://www.fema.gov/openfema-data-page/fima-nfip-redacted-claims-v1>   | large (500MB - 10GB) | 2547311     |

## Example Workflow

First, to see the avaliable datasets currently supported by the package,
we can run the “fema\_data\_sets()” function which calls the FEMA API
endpoint: “<https://www.fema.gov/api/open/v1/DataSets>” and by
default,filters the results by the data sets currently supported in the
package.

``` r
df <- fema_data_sets()
df$description <- paste0(substr(df$description,1,50),"...") # description shortened in this case to make table smaller
kable(df)
```

| identifier  | name             | title                       | description                                         | distribution.accessURL                                                      | distribution.format | distribution.datasetSize | distribution.accessURL.1 | distribution.format.1 | distribution.datasetSize.1 | distribution.accessURL.2 | distribution.format.2 | distribution.datasetSize.2 | webService                                          | dataDictionary                                                           | keyword | modified                 | publisher                           | contactPoint | mbox                | accessLevel | landingPage                            | temporal    | api  | version | bureauCode | programCode | accessLevelComment | license | spatial | theme                            | dataQuality | accrualPeriodicity | language | primaryITInvestmentUII | issued   | systemOfRecords | deprecated | hash                                     | lastRefresh              | recordCount | depApiMessage | depNewURL | depWebMessage | lastDataSetRefresh       | id                       | accessUrl | format | depDate | keyword1 | keyword2 | keyword3  | keyword4 | keyword5 | keyword6 | keyword7 | keyword8 | keyword9 | keyword10 | keyword11 | keyword12 | keyword13 | keyword14 | references                                                                   |
|:------------|:-----------------|:----------------------------|:----------------------------------------------------|:----------------------------------------------------------------------------|:--------------------|:-------------------------|:-------------------------|:----------------------|:---------------------------|:-------------------------|:----------------------|:---------------------------|:----------------------------------------------------|:-------------------------------------------------------------------------|:--------|:-------------------------|:------------------------------------|:-------------|:--------------------|:------------|:---------------------------------------|:------------|:-----|:--------|:-----------|:------------|:-------------------|:--------|:--------|:---------------------------------|:------------|:-------------------|:---------|:-----------------------|:---------|:----------------|:-----------|:-----------------------------------------|:-------------------------|:------------|:--------------|:----------|:--------------|:-------------------------|:-------------------------|:----------|:-------|:--------|:---------|:---------|:----------|:---------|:---------|:---------|:---------|:---------|:---------|:----------|:----------|:----------|:----------|:----------|:-----------------------------------------------------------------------------|
| openfema-32 | FimaNfipPolicies | FIMA NFIP Redacted Policies | Congress passed the National Flood Insurance Act (… | <https://www.fema.gov/about/reports-and-data/openfema/FimaNfipPolicies.csv> | csv                 | x-large (&gt; 10GB)      | NA                       | NA                    | NA                         | NA                       | NA                    | NA                         | <https://www.fema.gov/api/open/v1/FimaNfipPolicies> | <https://www.fema.gov/openfema-data-page/fima-nfip-redacted-policies-v1> | NA      | 2020-06-24T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/flood-insurance> | 2009-01-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | National Flood Insurance Program | true        | R/P1M              | en-US    |                        | 6/1/2019 |                 | NA         | efc24b58970f058495f3a30e92d3d8e598cf5afd | 2021-09-12T00:23:19.356Z | 59341663    |               |           |               | 2021-09-12T00:23:19.356Z | 5f086f050c96941b08614c46 | NA        | NA     | NA      | NFIP     | Flood    | Insurance | Policy   | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | <https://nfipservices.floodsmart.gov/manuals/jan_2015_consolidated_trrp.pdf> |
| openfema-31 | FimaNfipClaims   | FIMA NFIP Redacted Claims   | Congress passed the National Flood Insurance Act (… | <https://www.fema.gov/about/reports-and-data/openfema/FimaNfipClaims.csv>   | csv                 | large (500MB - 10GB)     | NA                       | NA                    | NA                         | NA                       | NA                    | NA                         | <https://www.fema.gov/api/open/v1/FimaNfipClaims>   | <https://www.fema.gov/openfema-data-page/fima-nfip-redacted-claims-v1>   | NA      | 2020-06-24T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/flood-insurance> | 1970-08-31/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | National Flood Insurance Program | true        | R/P1M              | en-US    |                        | 6/1/2019 |                 | NA         | 98ddc88c92e35364e1d5830afc01cc6d8fe2d508 | 2021-09-13T12:57:18.722Z | 2547311     |               |           |               | 2021-09-13T12:57:18.722Z | 5f086f050c96941b08614c47 | NA        | NA     | NA      | NFIP     | FIMA     | claims    | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | <https://nfipservices.floodsmart.gov/manuals/jan_2015_consolidated_trrp.pdf> |

If we wanted to see all of the data sets that FEMA maintains, we can
call the fema\_data\_sets() function again setting the “rfema\_access”
parameter to FALSE which will return information on all FEMA data sets
regardless of if they are currently supported by the package.

Once we know what data set we want to access, or perhaps if we want to
know more about what data is avaliable in a given data set, we can use
the fema\_data\_fields() function to get a look at the avaliable data
fields in a given data set by setting the “data\_set” parameter to one
of the “name” columns in the data frame returned by the
fema\_data\_sets() function.

``` r
df <- fema_data_fields(data_set = "fimaNfipPolicies")
df$Description<- paste0(substr(df$Description,1,50),"...") # description shortened in this case to make table smaller
kable(head(df))
```

| Name                            | Title                                   | Type    | Description                                         | Is Searchable |
|:--------------------------------|:----------------------------------------|:--------|:----------------------------------------------------|:--------------|
| agricultureStructureIndicator   | Agriculture Structure Indicator         | boolean | Yes (Y) or No (N) indicator of whether or not a bu… | no            |
| baseFloodElevation              | Base Flood Elevation                    | number  | Base Flood Elevation (BFE) is the elevation at whi… | yes           |
| basementEnclosureCrawlspaceType | Basement Enclosure Crawlspace Type Code | number  | Basement is defined for purposes of the NFIP as an… | yes           |
| cancellationDateOfFloodPolicy   | Cancellation Date of Flood Policy       | date    | The cancellation date of the flood policy (if any)… | yes           |
| censusTract                     | Census Tract                            | string  | US Census Bureau defined census Tracts; statistica… | yes           |
| condominiumIndicator            | Condominium Indicator                   | string  | This is an indicator of what type of condominium p… | yes           |

The returned data frame is a data dictionary for, in this case, the
National Flood Insurance Programs’s Policies dataset and includes the
name of each variable in the data set, a “Title” for each variable, the
variable type, a description of the variable, and a column indicating if
the variable is “Searchable”. Searchable variables are those than can be
used to filter API queries. If we decide to pull some of this data, we
can do so using the openFema() function.

The FEMA API limits the number of records that can be returned in a
single query to 1000, meaning if we want more observations than that, a
loop is neccesary to itterate over multiple API calls. The function
handles this automatically, but will warn you before itterating by
letting you know how many records there are and how many individual API
calls it will take to get all the records. At that point you can enter
“1” to continue or “0” to abort the opperation. As can be seen below,
running the following code will indicate that there are over 59 million
records if we don’t apply any filters to the data set which would take
many iterations (and a long time) to collect the full data set.

``` r
#openFema(data_set = "fimaNfipPolicies")

"[1] 59341663 matching records found. At 1000 records per call, it will take 59342 individual API calls to get all matching records. Continue?"
```

    ## [1] "[1] 59341663 matching records found. At 1000 records per call, it will take 59342 individual API calls to get all matching records. Continue?"

Alternatively, we could specify the top\_n argument to limit the number
of records returned. Specifying top\_n greater than 1000 will initiate
the same message letting you know how many itterations it will take to
get your data. If top\_n is less than 1000, the API call will be
automatically be carried out. In the case below, we will return the
first 10 records from the NFIP Policies data.

``` r
df <- openFema(data_set = "fimaNfipPolicies", top_n = 10)
kable(df)
```

| agricultureStructureIndicator | censusTract | condominiumIndicator | construction | countyCode | crsClassCode | deductibleAmountInBuildingCoverage | deductibleAmountInContentsCoverage | elevationBuildingIndicator | federalPolicyFee | floodZone | hfiaaSurcharge | houseOfWorshipIndicator | latitude | longitude | locationOfContents | lowestAdjacentGrade | nonProfitIndicator | numberOfFloorsInTheInsuredBuilding | occupancyType | originalConstructionDate | originalNBDate           | policyCost | policyCount | policyEffectiveDate      | policyTerminationDate    | policyTermIndicator | postFIRMConstructionIndicator | primaryResidenceIndicator | propertyState | reportedZipCode | rateMethod | regularEmergencyProgramIndicator | reportedCity            | smallBusinessIndicatorBuilding | totalBuildingInsuranceCoverage | totalContentsInsuranceCoverage | totalInsurancePremiumOfThePolicy | id                       | basementEnclosureCrawlspace |
|:------------------------------|:------------|:---------------------|:-------------|:-----------|-------------:|:-----------------------------------|:-----------------------------------|:---------------------------|-----------------:|:----------|---------------:|:------------------------|:---------|:----------|-------------------:|--------------------:|:-------------------|-----------------------------------:|--------------:|:-------------------------|:-------------------------|-----------:|------------:|:-------------------------|:-------------------------|--------------------:|:------------------------------|:--------------------------|:--------------|:----------------|:-----------|:---------------------------------|:------------------------|:-------------------------------|-------------------------------:|-------------------------------:|---------------------------------:|:-------------------------|----------------------------:|
| FALSE                         | 12103025203 | N                    | FALSE        | 12103      |            3 | 2                                  | 2                                  | FALSE                      |               44 | AE        |              0 | FALSE                   | 27.9     | -82.8     |                  3 |                   0 | FALSE              |                                  1 |             1 | 1965-07-01T04:00:00.000Z | 1990-11-26T05:00:00.000Z |       1898 |           1 | 2014-11-26T05:00:00.000Z | 2015-11-26T05:00:00.000Z |                   1 | FALSE                         | TRUE                      | FL            | 33770           | 1          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                           2800 |                             1765 | 613cae5af3de2d084b0c2324 |                          NA |
| FALSE                         | NA          | N                    | FALSE        |            |           NA | F                                  | F                                  | FALSE                      |               25 | X         |             25 | FALSE                   | NA       | NA        |                  3 |                   0 | FALSE              |                                  1 |             1 | 2020-05-25T04:00:00.000Z | 2021-08-07T04:00:00.000Z |        572 |           1 | 2021-08-07T04:00:00.000Z | 2022-08-07T04:00:00.000Z |                   1 | TRUE                          | TRUE                      | TX            | 77459           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                         100000 |                              442 | 613cae5af3de2d084b0c230c |                           0 |
| FALSE                         | 12009066200 | N                    | FALSE        | 12009      |           NA | F                                  | F                                  | FALSE                      |               22 | X         |             25 | FALSE                   | 28.1     | -80.6     |                  3 |                   0 | FALSE              |                                  1 |             1 | 1964-07-01T04:00:00.000Z | 1977-10-13T04:00:00.000Z |        430 |           1 | 2015-10-28T04:00:00.000Z | 2016-10-28T04:00:00.000Z |                   1 | FALSE                         | TRUE                      | FL            | 32903           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                         100000 |                              348 | 613cae5af3de2d084b0c2300 |                          NA |
| FALSE                         | 48167722001 | N                    | FALSE        | 48167      |           NA | F                                  | F                                  | FALSE                      |               25 | X         |             25 | FALSE                   | 29.4     | -94.9     |                  3 |                   0 | FALSE              |                                  1 |             1 | 2004-08-23T04:00:00.000Z | 2006-08-24T04:00:00.000Z |        450 |           1 | 2017-08-24T04:00:00.000Z | 2018-08-24T04:00:00.000Z |                   1 | TRUE                          | TRUE                      | TX            | 77590           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                         100000 |                              348 | 613cae5af3de2d084b0c230e |                           0 |
| FALSE                         | 12009064124 | N                    | FALSE        | 12009      |            8 | 1                                  | 1                                  | FALSE                      |               20 | X         |              0 | FALSE                   | 28.2     | -80.7     |                 NA |                   0 | FALSE              |                                  1 |             1 | 1988-01-01T05:00:00.000Z | 1989-09-28T04:00:00.000Z |        333 |           1 | 2010-09-28T04:00:00.000Z | 2011-09-28T04:00:00.000Z |                   1 | TRUE                          | TRUE                      | FL            | 32935           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         200000 |                          80000 |                              313 | 613cae5af3de2d084b0c2305 |                          NA |
| FALSE                         | 12115002505 | N                    | FALSE        | 12115      |            5 | 1                                  | 1                                  | FALSE                      |               20 | X         |              0 | FALSE                   | 27.1     | -82.4     |                  3 |                   0 | FALSE              |                                  1 |             1 | 1970-07-01T04:00:00.000Z | 2009-08-24T04:00:00.000Z |        365 |           1 | 2012-08-24T04:00:00.000Z | 2013-08-24T04:00:00.000Z |                   1 | FALSE                         | TRUE                      | FL            | 34293           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                         100000 |                              345 | 613cae5af3de2d084b0c230b |                          NA |
| FALSE                         | 12081001703 | U                    | FALSE        | 12081      |            6 |                                    | G                                  | FALSE                      |               25 | AE        |             25 | FALSE                   | 27.4     | -82.7     |                  5 |                   0 | FALSE              |                                  2 |             3 | 1971-01-01T05:00:00.000Z | 2011-06-10T04:00:00.000Z |        204 |           1 | 2019-06-10T04:00:00.000Z | 2020-06-10T04:00:00.000Z |                   1 | FALSE                         | TRUE                      | FL            | 34228           | 1          | R                                | Temporarily Unavailable | FALSE                          |                              0 |                          93100 |                              134 | 613cae5af3de2d084b0c22ff |                           0 |
| FALSE                         | 51095080304 | N                    | FALSE        | 51095      |            5 | F                                  | F                                  | FALSE                      |               25 | X         |             25 | FALSE                   | 37.2     | -76.9     |                 NA |                   0 | FALSE              |                                  2 |             1 | 1994-01-01T05:00:00.000Z | 1994-08-21T04:00:00.000Z |        450 |           1 | 2018-08-21T04:00:00.000Z | 2019-08-21T04:00:00.000Z |                   1 | TRUE                          | TRUE                      | VA            | 23185           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                         100000 |                              348 | 613cae5af3de2d084b0c2313 |                          NA |
| FALSE                         | 48007950400 | N                    | FALSE        | 48007      |            7 | F                                  | F                                  | FALSE                      |               25 | X         |            250 | FALSE                   | 28.0     | -97.1     |                  3 |                   0 | FALSE              |                                  1 |             1 | 2010-09-10T04:00:00.000Z | 2021-08-06T04:00:00.000Z |        797 |           1 | 2021-08-06T04:00:00.000Z | 2022-08-06T04:00:00.000Z |                   1 | TRUE                          | FALSE                     | TX            | 78382           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         250000 |                         100000 |                              442 | 613cae5af3de2d084b0c22fe |                           0 |
| FALSE                         | 12009064124 | N                    | FALSE        | 12009      |            8 | F                                  | F                                  | FALSE                      |               25 | X         |             25 | FALSE                   | 28.2     | -80.7     |                 NA |                   0 | FALSE              |                                  1 |             1 | 1988-01-01T05:00:00.000Z | 1989-09-28T04:00:00.000Z |        425 |           1 | 2016-09-28T04:00:00.000Z | 2017-09-28T04:00:00.000Z |                   1 | TRUE                          | TRUE                      | FL            | 32935           | 7          | R                                | Temporarily Unavailable | FALSE                          |                         200000 |                          80000 |                              326 | 613cae5af3de2d084b0c2308 |                          NA |

If we wanted to limit the columns returned we could do so by passing a
character vector of data fields to be included in the returned data
frame. Again, the data fields for a given data set can be retrieved
using the fema\_data\_fields() function. In this case we will return
only the census tract and crs code columns. As can be seen, an id column
is always returned even if the select argument is used.

``` r
df <- openFema(data_set = "fimaNfipPolicies", top_n = 10, select = c("censusTract","crsClassCode"))
kable(df)
```

| censusTract | crsClassCode | id                       |
|:------------|-------------:|:-------------------------|
| 12103025203 |            3 | 613cae5af3de2d084b0c2324 |
| NA          |           NA | 613cae5af3de2d084b0c230c |
| 12009066200 |           NA | 613cae5af3de2d084b0c2300 |
| 48167722001 |           NA | 613cae5af3de2d084b0c230e |
| 12009064124 |            8 | 613cae5af3de2d084b0c2305 |
| 12115002505 |            5 | 613cae5af3de2d084b0c230b |
| 12081001703 |            6 | 613cae5af3de2d084b0c22ff |
| 51095080304 |            5 | 613cae5af3de2d084b0c2313 |
| 48007950400 |            7 | 613cae5af3de2d084b0c22fe |
| 12009064124 |            8 | 613cae5af3de2d084b0c2308 |

If we want to limit the rows returned rather than the columns, we can
also apply filters by specifying values of the columns to return. If we
want to quickly see the set of variables that can be used to filter API
queries with, we can use the valid\_parameters() function to return a
vector containing the variables that are “searchable” for a particular
data set.

``` r
params <- valid_parameters(data_set = "fimaNfipPolicies")
kable(params)
```

| x                                  |
|:-----------------------------------|
| baseFloodElevation                 |
| basementEnclosureCrawlspaceType    |
| cancellationDateOfFloodPolicy      |
| censusTract                        |
| condominiumIndicator               |
| countyCode                         |
| crsClassCode                       |
| deductibleAmountInBuildingCoverage |
| deductibleAmountInContentsCoverage |
| elevatedBuildingIndicator          |
| elevationCertificateIndicator      |
| elevationDifference                |
| federalPolicyFee                   |
| floodZone                          |
| hfiaaSurcharge                     |
| houseOfWorshipIndicator            |
| latitude                           |
| locationOfContents                 |
| longitude                          |
| lowestAdjacentGrade                |
| lowestFloorElevation               |
| nonProfitIndicator                 |
| numberOfFloorsInInsuredBuilding    |
| obstructionType                    |
| occupancyType                      |
| originalConstructionDate           |
| originalNBDate                     |
| policyCost                         |
| policyCount                        |
| policyEffectiveDate                |
| policyTeminationDate               |
| policyTermIndicator                |
| propertyState                      |
| reportedZipCode                    |
| rateMethod                         |
| regularEmergencyProgramIndicator   |
| reportedCity                       |
| totalBuildingInsuranceCoverage     |
| totalContentsInsuranceCoverage     |
| totalInsurancePremiumOfThePolicy   |
| id                                 |

We can see from the above that both censusTract and crsClassCode are
both searchable variables. Thus we can specify a list that contains the
values of each variable that we want returned in the data frame. Before
doing that however, it can be useful to see unique values of those
variables in the data set. We can do this by using the
parameter\_values() function. This function returns the unique values of
a variable contained in the first 1000 observations of a data set.
Notably, it does not return all unique values, as that would require
access to the entire data set, which as we saw above is almost 59
million records.

``` r
parameter_values(data_set = "fimaNfipPolicies",data_field = "crsClassCode")
```

    ## # A tibble: 9 × 1
    ##   crsClassCode
    ##          <int>
    ## 1            3
    ## 2           NA
    ## 3            8
    ## 4            5
    ## 5            6
    ## 6            7
    ## 7            9
    ## 8            4
    ## 9           10

We can see from the above that crsClassCode is an integer in the data
and there are 9 unique values in the first 1000 observations of the full
dataset. Lets go a head a define a filter to limit our results to
records with a crsClassCode that is either 5 or 6.

``` r
my_filters <- list(crsClassCode = c(5,6))

df <- openFema(data_set = "fimaNfipPolicies", top_n = 10, 
               select = c("censusTract","crsClassCode"), filters = my_filters)
kable(df)
```

| censusTract | crsClassCode | id                       |
|:------------|-------------:|:-------------------------|
| 12115002505 |            5 | 613cae5af3de2d084b0c230b |
| 51095080304 |            5 | 613cae5af3de2d084b0c2313 |
| 12115001201 |            5 | 613cae5af3de2d084b0c230d |
| 48113006100 |            5 | 613cae5af3de2d084b0c2318 |
| 48201522100 |            5 | 613cae5af3de2d084b0c2336 |
| 12115001201 |            5 | 613cae5af3de2d084b0c2327 |
| 48201522100 |            5 | 613cae5af3de2d084b0c2338 |
| 12115001201 |            5 | 613cae5af3de2d084b0c2328 |
| 48201522100 |            5 | 613cae5af3de2d084b0c2335 |
| 48113006100 |            5 | 613cae5af3de2d084b0c2317 |

## More Examples

TODO: add more examples here.

### Example: Return the first 100 NFIP claims for Autauga County, AL that happened between 2010 and 2020.

``` r
df <- openFema(data_set = "fimaNfipClaims",
                 top_n = 100,
                 filters = list(countyCode = "= 01001",
                                yearOfLoss = ">= 2010",
                                yearOfLoss = "<= 2020"))
```

### Example: Get data on all Hazard Mitigation Grants associated with Hurricanes in Florida.

``` r
#valid_parameters("HazardMitigationGrants") # see which parameter can be used for filtering the Hazard Mitigation Grants data set

#parameter_values(data_set = "HazardMitigationGrants", data_field = "incidentType") # check example values for "incidentType"


#parameter_values(data_set = "HazardMitigationGrants", data_field = "state") # check to see how "state" is formatted

# construct a list containing filters for Hurricane and Florida
#filter_list <- c(incidentType = c("Hurricane"),
#                 state = c("Florida")) 

# pass filter_list to the openFema function to retreieve data.
#df <- openFema(data_set = "HazardMitigationGrants", filters = filter_list, 
#               ask_before_call = FALSE)
#kable(head(df))
```

## Bulk Downloads

In some cases bulk downloading a full data set file may be preferred. In
this case, users can use the bulk\_dl() command to download a csv of the
full data file and save it to a specified directory.

``` r
bulk_dl("femaRegions") # download a csv file containing all info on FEMA regions
```

    ## [1] "Downloading file to /home/dylan/Dropbox/rfema/FemaRegions_2021-09-19 07:22:40.csv"
