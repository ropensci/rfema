
## rfema (R FEMA)

![R-CMD-check](https://github.com/ropensci/ijtiff/workflows/R-CMD-check/badge.svg)
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

    ## lifecycle (1.0.0 -> 1.0.1) [CRAN]

    ## Installing 1 packages: lifecycle
    ## Installing package into '/home/dylan/R/x86_64-pc-linux-gnu-library/4.1'
    ## (as 'lib' is unspecified)

    ##      checking for file ‘/tmp/RtmprwS7Eu/remotes381645ed966bf/dylan-turner25-rfema-0d62dda/DESCRIPTION’ ...  ✓  checking for file ‘/tmp/RtmprwS7Eu/remotes381645ed966bf/dylan-turner25-rfema-0d62dda/DESCRIPTION’
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

## Avaliable Datasets

To see the all of the datasets avaliable through `rfema`, we can run the
`fema_data_sets()` function which calls the FEMA API endpoint:
<https://www.fema.gov/api/open/v1/DataSets>

``` r
data_sets <- fema_data_sets() 
data_sets$description <- paste0(substr(data_sets$description,1,50),"...") # description shortened in this case to make table smaller

kable(head(data_sets)) # only displaying first few data sets
```

| identifier  | name                                          | title                                             | description                                         | distribution.accessURL                                                               | distribution.format | distribution.datasetSize | distribution.accessURL.1                                                              | distribution.format.1 | distribution.datasetSize.1 | distribution.accessURL.2                                                               | distribution.format.2 | distribution.datasetSize.2 | webService                                                                       | dataDictionary                                                                                 | keyword                                                                                               | modified                 | publisher                           | contactPoint | mbox                | accessLevel | landingPage                                                                                                                                                          | temporal    | api  | version | bureauCode | programCode | accessLevelComment | license | spatial | theme                | dataQuality | accrualPeriodicity | language | primaryITInvestmentUII | issued                   | systemOfRecords | deprecated | hash                                     | lastRefresh              | recordCount | depApiMessage                                                                                                                                                                                       | depNewURL                                                                                      | depWebMessage                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | lastDataSetRefresh       | id                       | accessUrl | format | depDate                  | keyword1 | keyword2            | keyword3 | keyword4 | keyword5 | keyword6 | keyword7 | keyword8 | keyword9 | keyword10 | keyword11 | keyword12 | keyword13 | keyword14 | references |
|:------------|:----------------------------------------------|:--------------------------------------------------|:----------------------------------------------------|:-------------------------------------------------------------------------------------|:--------------------|:-------------------------|:--------------------------------------------------------------------------------------|:----------------------|:---------------------------|:---------------------------------------------------------------------------------------|:----------------------|:---------------------------|:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------|:-------------------------|:------------------------------------|:-------------|:--------------------|:------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------|:-----|:--------|:-----------|:------------|:-------------------|:--------|:--------|:---------------------|:------------|:-------------------|:---------|:-----------------------|:-------------------------|:----------------|:-----------|:-----------------------------------------|:-------------------------|:------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------|:-------------------------|:----------|:-------|:-------------------------|:---------|:--------------------|:---------|:---------|:---------|:---------|:---------|:---------|:---------|:----------|:----------|:----------|:----------|:----------|:-----------|
| openfema-1  | PublicAssistanceFundedProjectsSummaries       | Public Assistance Funded Project Summaries        | FEMA provides supplemental Federal disaster grant … | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.csv>       | csv                 | small (10MB - 50MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.json>       | json                  | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.jsona>       | jsona                 | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries>       | <https://www.fema.gov/openfema-data-page/public-assistance-funded-projects-summaries-v1>       | public, assistance, disaster, grant, funding, sub-grantees                                            | 2019-05-30T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/assistance/public>                                                                                                                             | 1980-02-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Public Assistance    | true        | R/P1D              | en-US    |                        | 2010-01-21T05:00:00.000Z |                 | FALSE      | bd507ed0181bba91866372a0a5d3c3e4         | 2021-09-25T16:35:28.371Z | 169879      |                                                                                                                                                                                                     |                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 2021-09-25T16:35:28.371Z | 5dd723598ca22d24d423eb6f | NA        | NA     | NA                       | NA       | NA                  | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-1  | PublicAssistanceFundedProjectsSummaries       | Public Assistance Funded Project Summaries        | FEMA provides supplemental Federal disaster grant … | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.csv>       | csv                 | small (10MB - 50MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.json>       | json                  | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries.jsona>       | jsona                 | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries>       | <https://www.fema.gov/openfema-data-page/public-assistance-funded-projects-summaries-v1>       | public, assistance, disaster, grant, funding, sub-grantees                                            | 2019-05-30T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/assistance/public>                                                                                                                             | 1980-02-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Public Assistance    | true        | R/P1D              | en-US    |                        | 2010-01-21T05:00:00.000Z |                 | FALSE      | bd507ed0181bba91866372a0a5d3c3e4         | 2021-09-25T16:35:28.371Z | 169879      |                                                                                                                                                                                                     |                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 2021-09-25T16:35:28.371Z | 5dd723598ca22d24d423eb6f | NA        | NA     | NA                       | NA       | NA                  | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-26 | FemaWebDeclarationAreas                       | FEMA Web Declaration Areas                        | This data set contains general information on decl… | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.csv>                       | csv                 | medium (50MB - 500MB)    | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.json>                       | json                  | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.jsona>                       | jsona                 | medium (50MB - 500MB)      | <https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas>                       | <https://www.fema.gov/openfema-data-page/fema-web-declaration-areas-v1>                        | disaster, declaration, fema website                                                                   | 2019-09-26T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/disasters>                                                                                                                                     | 1960-11-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Disaster Information | true        | R/PT20M            | en-US    |                        | NA                       |                 | FALSE      | 89eaca0ba42130ddbd5477ed92fee30b         | 2021-09-26T09:52:46.268Z | 437476      |                                                                                                                                                                                                     |                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 2021-09-26T09:52:46.268Z | 5dd723598ca22d24d423eb73 | NA        | NA     | NA                       | NA       | NA                  | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-28 | HazardMitigationAssistanceMitigatedProperties | Hazard Mitigation Assistance Mitigated Properties | This dataset contains the properties that were mit… | <https://www.fema.gov/api/open/v1/HazardMitigationAssistanceMitigatedProperties.csv> | csv                 | small (10MB - 50MB)      | <https://www.fema.gov/api/open/v1/HazardMitigationAssistanceMitigatedProperties.json> | json                  | small (10MB - 50MB)        | <https://www.fema.gov/api/open/v1/HazardMitigationAssistanceMitigatedProperties.jsona> | jsona                 | small (10MB - 50MB)        | <https://www.fema.gov/api/open/v1/HazardMitigationAssistanceMitigatedProperties> | <https://www.fema.gov/openfema-data-page/hazard-mitigation-assistance-mitigated-properties-v1> | hazard, mitigation, disaster, property, project, assistance, hmgp, grant, fma, flood pdm pre-disaster | NA                       | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://www.fema.gov/grants/mitigation>                                                                                                                             | 1989-01-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Hazard Mitigation    | true        | R/P1D              | en-US    |                        | 2018-03-09T05:00:00.000Z |                 | TRUE       | bccd9bde7f6722a223cd15150cc0f5e9         | 2021-09-25T16:33:55.865Z | 64208       | This dataset has been deprecated and will no longer be available by the date specified. It is recommended that the new endpoint be used. See the OpenFEMA documentation for additional information. | <https://www.fema.gov/openfema-data-page/hazard-mitigation-assistance-mitigated-properties-v2> | A newer version of this OpenFEMA data set has been released. This older dataset version will no longer be updated and will be archived by the end of April 2020. The following page details the latest version of this data set: <https://www.fema.gov/openfema-data-page/hazard-mitigation-assistance-mitigated-properties-v2>. CSV and JSON Files can be downloaded from the ‘Full Data’ section.To access the dataset through an API endpoint, visit the ‘API Endpoint’ section of the above page. Accessing data in this fashion permits data filtering, sorting, and field selection. The OpenFEMA API Documentation page provides information on API usage. | 2021-09-25T16:33:55.865Z | 5dd723598ca22d24d423eb77 |           |        | 2020-04-30T04:00:00.000Z | NA       | NA                  | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-36 | FemaRegions                                   | FEMA Regions                                      | Provides the list of FEMA Regions. The dataset in…  | <https://www.fema.gov/api/open/v1/FemaRegions.csv>                                   | csv                 | tiny (&lt; 10 MB)        | <https://www.fema.gov/api/open/v1/FemaRegions.json>                                   | json                  | tiny (&lt; 10 MB)          | <https://www.fema.gov/api/open/v1/FemaRegions.jsona>                                   | jsona                 | tiny (&lt; 10 MB)          | <https://www.fema.gov/api/open/v1/FemaRegions>                                   | <https://www.fema.gov/openfema-data-page/fema-regions-v1>                                      | regions                                                                                               | 2020-06-12T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      |                                                                                                                                                                      |             | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Miscellaneous        | true        | irregular          | en-US    |                        | NA                       |                 | TRUE       | 282c8b7a2bb6e7f54ab43e5b726f7511         | 2021-03-26T17:50:27.502Z | 11          | This dataset has been deprecated and will no longer be available by the date specified. It is recommended that the new endpoint be used. See the OpenFEMA documentation for additional information. | <https://www.fema.gov/openfema-data-page/fema-regions-v2>                                      | A newer version of this OpenFEMA data set has been released. This older dataset version will no longer be updated and will be archived by the date specified. The following page details the latest version of this data set: <https://www.fema.gov/openfema-data-page/fema-regions-v2>. CSV and JSON Files can be downloaded from the ‘Full Data’ section.To access the dataset through an API endpoint, visit the ‘API Endpoint’ section of the above page. Accessing data in this fashion permits data filtering, sorting, and field selection. The OpenFEMA API Documentation page provides information on API usage.                                         | 2021-03-26T17:50:27.502Z | 5dd723598ca22d24d423eb7f | NA        | NA     | 2020-09-12T04:00:00.000Z | NA       | NA                  | NA       | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |
| openfema-22 | EmergencyManagementPerformanceGrants          | Emergency Management Performance Grants           | This dataset contains EMPG recipients as reported … | <https://www.fema.gov/api/open/v1/EmergencyManagementPerformanceGrants.csv>          | csv                 | tiny (&lt; 10MB)         | <https://www.fema.gov/api/open/v1/EmergencyManagementPerformanceGrants.json>          | json                  | tiny (&lt; 10MB)           | <https://www.fema.gov/api/open/v1/EmergencyManagementPerformanceGrants.jsona>          | jsona                 | tiny (&lt; 10MB)           | <https://www.fema.gov/api/open/v1/EmergencyManagementPerformanceGrants>          | <https://www.fema.gov/openfema-data-page/emergency-management-performance-grants-v1>           | NA                                                                                                    | 2019-09-26T04:00:00.000Z | Federal Emergency Management Agency | OpenFEMA     | <openfema@fema.gov> | public      | <https://beta.sam.gov/fal/cd60f4b3664041838fd94e1482b5de24/view?keywords=emergency%20management%20performance%20grants&sort=-relevance&index=&is_active=true&page=1> | 2010-10-01/ | TRUE | 1       | 024:70     | 024:039     |                    |         |         | Disaster Information | true        | R/P6M              | en-US    |                        | 10/31/2016               |                 | NA         | c70215e88c4aeaa2922798aa69e52e25f6c2ca60 | 2021-09-01T15:01:28.247Z |             |                                                                                                                                                                                                     |                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | NA                       | 5dd723598ca22d24d423eb9f | NA        | NA     | NA                       | grants   | emergencymanagement | empg     | NA       | NA       | NA       | NA       | NA       | NA       | NA        | NA        | NA        | NA        | NA        | NA         |

## Example Workflow

Once we know what data set we want to access, or perhaps if we want to
know more about what data is avaliable in a given data set, we can use
the `fema_data_fields()` function to get a look at the available data
fields in a given data set by setting the “data\_set” parameter to one
of the “name” columns in the data frame returned by the
`fema_data_sets()` function.

``` r
df <- fema_data_fields(data_set = "fimaNfipPolicies")
df$Description <- paste0(substr(df$Description,1,50),"...") # description shortened in this case to make table smaller
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
National Flood Insurance Programs’s Policies data set and includes the
name of each variable in the data set, a “Title” for each variable, the
variable type, a description of the variable, and a column indicating if
the variable is “Searchable”. Searchable variables are those than can be
used to filter API queries. If we decide to pull some of this data, we
can do so using the `openFema()` function.

The FEMA API limits the number of records that can be returned in a
single query to 1000, meaning if we want more observations than that, a
loop is necessary to itterate over multiple API calls. The function
handles this automatically, but will warn you before iterating by
letting you know how many records there are and how many individual API
calls it will take to get all the records. At that point you can enter
“1” to continue or “0” to abort the operation. As can be seen below,
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
the same message letting you know how many iterations it will take to
get your data. If top\_n is less than 1000, the API call will be
automatically be carried out. In the case below, we will return the
first 10 records from the NFIP Policies data.

``` r
df <- openFema(data_set = "fimaNfipPolicies", top_n = 10)
kable(df)
```

| agricultureStructureIndicator | basementEnclosureCrawlspace | censusTract | condominiumIndicator | construction | countyCode | crsClassCode | deductibleAmountInBuildingCoverage | deductibleAmountInContentsCoverage | elevationBuildingIndicator | federalPolicyFee | floodZone | hfiaaSurcharge | houseOfWorshipIndicator | latitude | longitude | locationOfContents | lowestAdjacentGrade | nonProfitIndicator | numberOfFloorsInTheInsuredBuilding | occupancyType | originalConstructionDate | originalNBDate           | policyCost | policyCount | policyEffectiveDate      | policyTerminationDate    | policyTermIndicator | postFIRMConstructionIndicator | primaryResidenceIndicator | propertyState | reportedZipCode | rateMethod | regularEmergencyProgramIndicator | reportedCity            | smallBusinessIndicatorBuilding | totalBuildingInsuranceCoverage | totalContentsInsuranceCoverage | totalInsurancePremiumOfThePolicy | id                       |
|:------------------------------|:----------------------------|:------------|:---------------------|:-------------|:-----------|:-------------|:-----------------------------------|:-----------------------------------|:---------------------------|:-----------------|:----------|:---------------|:------------------------|:---------|:----------|:-------------------|:--------------------|:-------------------|:-----------------------------------|:--------------|:-------------------------|:-------------------------|:-----------|:------------|:-------------------------|:-------------------------|:--------------------|:------------------------------|:--------------------------|:--------------|:----------------|:-----------|:---------------------------------|:------------------------|:-------------------------------|:-------------------------------|:-------------------------------|:---------------------------------|:-------------------------|
| FALSE                         | 0                           | 48007950400 | N                    | FALSE        | 48007      | 7            | F                                  | F                                  | FALSE                      | 25               | X         | 250            | FALSE                   | 28.0     | -97.1     | 3                  | 0                   | FALSE              | 1                                  | 1             | 2010-09-10T04:00:00.000Z | 2021-08-06T04:00:00.000Z | 797        | 1           | 2021-08-06T04:00:00.000Z | 2022-08-06T04:00:00.000Z | 1                   | TRUE                          | FALSE                     | TX            | 78382           | 7          | R                                | Temporarily Unavailable | FALSE                          | 250000                         | 100000                         | 442                              | 613cae5af3de2d084b0c22fe |
| FALSE                         | 0                           | 12081001703 | U                    | FALSE        | 12081      | 6            |                                    | G                                  | FALSE                      | 25               | AE        | 25             | FALSE                   | 27.4     | -82.7     | 5                  | 0                   | FALSE              | 2                                  | 3             | 1971-01-01T05:00:00.000Z | 2011-06-10T04:00:00.000Z | 204        | 1           | 2019-06-10T04:00:00.000Z | 2020-06-10T04:00:00.000Z | 1                   | FALSE                         | TRUE                      | FL            | 34228           | 1          | R                                | Temporarily Unavailable | FALSE                          | 0                              | 93100                          | 134                              | 613cae5af3de2d084b0c22ff |
| FALSE                         | NA                          | 12009066200 | N                    | FALSE        | 12009      | NA           | F                                  | F                                  | FALSE                      | 22               | X         | 25             | FALSE                   | 28.1     | -80.6     | 3                  | 0                   | FALSE              | 1                                  | 1             | 1964-07-01T04:00:00.000Z | 1977-10-13T04:00:00.000Z | 430        | 1           | 2015-10-28T04:00:00.000Z | 2016-10-28T04:00:00.000Z | 1                   | FALSE                         | TRUE                      | FL            | 32903           | 7          | R                                | Temporarily Unavailable | FALSE                          | 250000                         | 100000                         | 348                              | 613cae5af3de2d084b0c2300 |
| FALSE                         | NA                          | 12009066200 | N                    | FALSE        | 12009      | NA           | F                                  | F                                  | FALSE                      | 25               | X         | 25             | FALSE                   | 28.1     | -80.6     | 3                  | 0                   | FALSE              | 1                                  | 1             | 1964-07-01T04:00:00.000Z | 1977-10-13T04:00:00.000Z | 450        | 1           | 2016-10-28T04:00:00.000Z | 2017-10-28T04:00:00.000Z | 1                   | FALSE                         | TRUE                      | FL            | 32903           | 7          | R                                | Temporarily Unavailable | FALSE                          | 250000                         | 100000                         | 348                              | 613cae5af3de2d084b0c2301 |
| FALSE                         | NA                          | 12009066200 | N                    | FALSE        | 12009      | NA           | F                                  | F                                  | FALSE                      | 25               | X         | 25             | FALSE                   | 28.1     | -80.6     | 3                  | 0                   | FALSE              | 1                                  | 1             | 1964-07-01T04:00:00.000Z | 1977-10-13T04:00:00.000Z | 450        | 1           | 2017-10-28T04:00:00.000Z | 2018-10-28T04:00:00.000Z | 1                   | FALSE                         | TRUE                      | FL            | 32903           | 7          | R                                | Temporarily Unavailable | FALSE                          | 250000                         | 100000                         | 348                              | 613cae5af3de2d084b0c2302 |
| FALSE                         | NA                          | 12009066200 | N                    | FALSE        | 12009      | NA           | F                                  | F                                  | FALSE                      | 25               | X         | 25             | FALSE                   | 28.1     | -80.6     | 3                  | 0                   | FALSE              | 1                                  | 1             | 1964-07-01T04:00:00.000Z | 1977-10-13T04:00:00.000Z | 450        | 1           | 2018-10-28T04:00:00.000Z | 2019-10-28T04:00:00.000Z | 1                   | FALSE                         | TRUE                      | FL            | 32903           | 7          | R                                | Temporarily Unavailable | FALSE                          | 250000                         | 100000                         | 348                              | 613cae5af3de2d084b0c2303 |
| FALSE                         | NA                          | 12021010210 | N                    | FALSE        | 12021      | 5            | F                                  | F                                  | FALSE                      | 25               | X         | 25             | FALSE                   | 26.2     | -81.8     | NA                 | 0                   | FALSE              | 1                                  | 1             | 1984-01-01T05:00:00.000Z | 2000-06-18T04:00:00.000Z | 482        | 1           | 2019-06-18T04:00:00.000Z | 2020-06-18T04:00:00.000Z | 1                   | TRUE                          | TRUE                      | FL            | 34105           | 7          | R                                | Temporarily Unavailable | FALSE                          | 250000                         | 100000                         | 376                              | 613cae5af3de2d084b0c2304 |
| FALSE                         | NA                          | 12009064124 | N                    | FALSE        | 12009      | 8            | 1                                  | 1                                  | FALSE                      | 20               | X         | 0              | FALSE                   | 28.2     | -80.7     | NA                 | 0                   | FALSE              | 1                                  | 1             | 1988-01-01T05:00:00.000Z | 1989-09-28T04:00:00.000Z | 333        | 1           | 2010-09-28T04:00:00.000Z | 2011-09-28T04:00:00.000Z | 1                   | TRUE                          | TRUE                      | FL            | 32935           | 7          | R                                | Temporarily Unavailable | FALSE                          | 200000                         | 80000                          | 313                              | 613cae5af3de2d084b0c2305 |
| FALSE                         | NA                          | 12009064124 | N                    | FALSE        | 12009      | 8            | 1                                  | 1                                  | FALSE                      | 20               | X         | 0              | FALSE                   | 28.2     | -80.7     | NA                 | 0                   | FALSE              | 1                                  | 1             | 1988-01-01T05:00:00.000Z | 1989-09-28T04:00:00.000Z | 343        | 1           | 2011-09-28T04:00:00.000Z | 2012-09-28T04:00:00.000Z | 1                   | TRUE                          | TRUE                      | FL            | 32935           | 7          | R                                | Temporarily Unavailable | FALSE                          | 200000                         | 80000                          | 323                              | 613cae5af3de2d084b0c2306 |
| FALSE                         | NA                          | 12009064124 | N                    | FALSE        | 12009      | 8            | F                                  | F                                  | FALSE                      | 22               | X         | 25             | FALSE                   | 28.2     | -80.7     | NA                 | 0                   | FALSE              | 1                                  | 1             | 1988-01-01T05:00:00.000Z | 1989-09-28T04:00:00.000Z | 405        | 1           | 2015-09-28T04:00:00.000Z | 2016-09-28T04:00:00.000Z | 1                   | TRUE                          | TRUE                      | FL            | 32935           | 7          | R                                | Temporarily Unavailable | FALSE                          | 200000                         | 80000                          | 326                              | 613cae5af3de2d084b0c2307 |

If we wanted to limit the columns returned we could do so by passing a
character vector of data fields to be included in the returned data
frame. Again, the data fields for a given data set can be retrieved
using the `fema_data_fields()` function. In this case we will return
only the census tract and CRScode columns. As can be seen, an id column
is always returned even if the select argument is used.

``` r
df <- openFema(data_set = "fimaNfipPolicies", top_n = 10, select = c("censusTract","crsClassCode"))
kable(df)
```

| censusTract | crsClassCode | id                       |
|:------------|:-------------|:-------------------------|
| 48007950400 | 7            | 613cae5af3de2d084b0c22fe |
| 12081001703 | 6            | 613cae5af3de2d084b0c22ff |
| 12009066200 | NA           | 613cae5af3de2d084b0c2300 |
| 12009066200 | NA           | 613cae5af3de2d084b0c2301 |
| 12009066200 | NA           | 613cae5af3de2d084b0c2302 |
| 12009066200 | NA           | 613cae5af3de2d084b0c2303 |
| 12021010210 | 5            | 613cae5af3de2d084b0c2304 |
| 12009064124 | 8            | 613cae5af3de2d084b0c2305 |
| 12009064124 | 8            | 613cae5af3de2d084b0c2306 |
| 12009064124 | 8            | 613cae5af3de2d084b0c2307 |

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

    ## [1] "7"  "6"  NA   "5"  "8"  "9"  "3"  "10" "4"

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
|:------------|:-------------|:-------------------------|
| 12021010210 | 5            | 613cae5af3de2d084b0c2304 |
| 12115002505 | 5            | 613cae5af3de2d084b0c230b |
| 12115001201 | 5            | 613cae5af3de2d084b0c230d |
| 51095080304 | 5            | 613cae5af3de2d084b0c2313 |
| 48113006100 | 5            | 613cae5af3de2d084b0c2317 |
| 48113006100 | 5            | 613cae5af3de2d084b0c2318 |
| 12115001908 | 5            | 613cae5af3de2d084b0c231d |
| 12115001908 | 5            | 613cae5af3de2d084b0c231e |
| 12115001908 | 5            | 613cae5af3de2d084b0c2320 |
| 12115001201 | 5            | 613cae5af3de2d084b0c2327 |

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
# see which parameter can be used for filtering the Hazard Mitigation Grants data set
valid_parameters("HazardMitigationGrants") 
```

    ##  [1] "region"              "state"               "disasterNumber"     
    ##  [4] "declarationDate"     "incidentType"        "disasterTitle"      
    ##  [7] "projectNumber"       "projectType"         "projectTitle"       
    ## [10] "projectDescription"  "projectCounties"     "status"             
    ## [13] "subgrantee"          "subgranteeFIPSCode"  "projectAmount"      
    ## [16] "costSharePercentage" "id"                  "lastRefresh"        
    ## [19] "hash"

``` r
# check example values for "incidentType"
parameter_values(data_set = "HazardMitigationGrants", data_field = "incidentType") 
```

    ##  [1] "Flood"            "Severe Storm(s)"  "Tornado"          "Freezing"        
    ##  [5] "Hurricane"        "Earthquake"       "Typhoon"          "Volcano"         
    ##  [9] "Fire"             "Snow"             "Severe Ice Storm" "Coastal Storm"

``` r
# check to see how "state" is formatted
parameter_values(data_set = "HazardMitigationGrants", data_field = "state") 
```

    ##  [1] "Kentucky"                       "Utah"                          
    ##  [3] "North Dakota"                   "Texas"                         
    ##  [5] "North Carolina"                 "Alaska"                        
    ##  [7] "Connecticut"                    "Virgin Islands of the U.S."    
    ##  [9] "Louisiana"                      "Vermont"                       
    ## [11] "Puerto Rico"                    "South Carolina"                
    ## [13] "Maine"                          "Maryland"                      
    ## [15] "Minnesota"                      "Washington"                    
    ## [17] "District of Columbia"           "California"                    
    ## [19] "Virginia"                       "Alabama"                       
    ## [21] "Mississippi"                    "Northern Mariana Islands"      
    ## [23] "Tennessee"                      "Oregon"                        
    ## [25] "Georgia"                        "Hawaii"                        
    ## [27] "American Samoa"                 "Arkansas"                      
    ## [29] "Oklahoma"                       "Missouri"                      
    ## [31] "Iowa"                           "Nebraska"                      
    ## [33] "New Hampshire"                  "Wisconsin"                     
    ## [35] "Illinois"                       "Indiana"                       
    ## [37] "Palau"                          "Ohio"                          
    ## [39] "Federated States of Micronesia" "Arizona"                       
    ## [41] "Guam"                           "New York"                      
    ## [43] "Rhode Island"                   "Massachusetts"                 
    ## [45] "Marshall Islands"

``` r
# construct a list containing filters for Hurricane and Florida
filter_list <- c(incidentType = c("Hurricane"),
                 state = c("Florida")) 

# pass filter_list to the openFema function to retreieve data.
df <- openFema(data_set = "HazardMitigationGrants", filters = filter_list, 
               ask_before_call = FALSE)
```

    ## [1] 1 out of 2 itterations completed
    ## [1] 2 out of 2 itterations completed

``` r
kable(head(df))
```

| region | state   | disasterNumber | declarationDate          | incidentType | disasterTitle    | projectNumber | projectType                                                | projectTitle                                  | projectDescription                                                                                                                                                                                                                                                  | projectCounties | status                | subgrantee           | subgranteeFIPSCode | projectAmount | costSharePercentage | hash                             | lastRefresh              | id                       |
|:-------|:--------|:---------------|:-------------------------|:-------------|:-----------------|:--------------|:-----------------------------------------------------------|:----------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------|:----------------------|:---------------------|:-------------------|:--------------|:--------------------|:---------------------------------|:-------------------------|:-------------------------|
| 4      | Florida | 955            | 1992-08-24T00:00:00.000Z | Hurricane    | HURRICANE ANDREW | 0004          | 401.1: Water and Sanitary Sewer System Protective Measures | GIS UTILITY RESPONSE DATA FILES               | Load all water and sewer lines onto a GIS and field locate essential facilities to shorten repair crew response time.                                                                                                                                               | BROWARD         | Not Approved / Denied | BROWARD COUNTY       | 1100000            | 0             | 0                   | bd8da6fb6e52916e3c822f4aca8b7f82 | 2017-12-11T16:09:24.558Z | 5a2eadb4758c6e4347f37aa1 |
| 4      | Florida | 955            | 1992-08-24T00:00:00.000Z | Hurricane    | HURRICANE ANDREW | 0002          | 205.8: Retrofitting Public Structures - Wind               | WIND RETROFIT BLDG - REINFORCE GLASS WALLS    | Protect building with laminated glass, shuttering, bracing, rollup doors, and skylight retrofit . See Comments section for further description.                                                                                                                     | BROWARD         | Closed                | PERFORMING ARTS CENT | 1190704            | 1687412       | 50                  | 7662a07458802ded73f1e5555c16d06e | 2017-12-11T16:12:06.413Z | 5a2eadb4758c6e4347f37ac1 |
| 4      | Florida | 955            | 1992-08-24T00:00:00.000Z | Hurricane    | HURRICANE ANDREW | 0003          | 501.1: Other Major Structural Projects                     | REPLACE TRAFFIC SIGNALS/ELEVATE CONTROL BOXES | Replace span wire traffic signals with mast arm installations. Raise control cabinets to prevent water intrusion and flooding.                                                                                                                                      | BROWARD         | Withdrawn             | BROWARD COUNTY       | 1100000            | 0             | 0                   | cbe2884b62ee5a92052adcd72b7548ad | 2017-12-11T16:09:24.575Z | 5a2eadb4758c6e4347f37ad4 |
| 4      | Florida | 955            | 1992-08-24T00:00:00.000Z | Hurricane    | HURRICANE ANDREW | 0001          | 602.1: Other Equipment Purchase and Installation           | RECOVERY MANAGEMENT PROJECT                   | Proposed system funding levels: Hardware: $670,000, Software: $55,000, Training: $60,000; system customization: $200,000; maintenance: $110,000; data acquistion: $325,000; Miami DFO and four county disaster area support: $180,000, for a total of : $1,600,000. | STATEWIDE       | Closed                | DEPARTMENT OF COMMUN | 92040              | 1600000       | 50                  | 2a1e5ea264fb4ec92c8244db0829e09a | 2017-12-11T16:09:24.586Z | 5a2eadb4758c6e4347f37af5 |
| 4      | Florida | 955            | 1992-08-24T00:00:00.000Z | Hurricane    | HURRICANE ANDREW | 0019          | 205.8: Retrofitting Public Structures - Wind               | WIND RETROFIT BLDGS - SHUTTERS                | Install shutters over all openings to public works maintenance building to prevent damage from hurricane winds. This project plans to install 183 SF of shutters at all window openings for an estimated cost of $1,400.                                            | BROWARD         | Closed                | LIGHTHOUSE POINT     | 1140450            | 1500          | 50                  | 55eaf4535a6f0a5264991d722469054a | 2017-12-11T16:09:24.849Z | 5a2eadb4758c6e4347f37af9 |
| 4      | Florida | 955            | 1992-08-24T00:00:00.000Z | Hurricane    | HURRICANE ANDREW | 0014          | 601.1: Generators                                          | ELEVATE/RELOCATE EMERGENCY GENERATOR          | Construct engine / generator set enclosure at an alternative location above minimum floodplain elevation, together with extension of primary feeders to emergency switch gear, to prevent flooding during a storm event.                                            | BROWARD         | Withdrawn             | DAVIE                | 1116475            | 0             | 0                   | 9986bc5b602bc4b7c2450514d62ce5e2 | 2017-12-11T16:09:24.849Z | 5a2eadb4758c6e4347f37af8 |

## Bulk Downloads

In some cases bulk downloading a full data set file may be preferred. In
this case, users can use the bulk\_dl() command to download a csv of the
full data file and save it to a specified directory.

``` r
bulk_dl("femaRegions") # download a csv file containing all info on FEMA regions
```

    ## [1] "Downloading file to /home/dylan/Dropbox/rfema/FemaRegions_2021-09-19 07:47:15.csv"
