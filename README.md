
## rfema (R FEMA)

rfema allows users to access The Federal Emergency Management Agency’s
(FEMA) publicly available data through their API. The package provides a
set of functions to easily navigate and access data from the National
Flood Insurance Program along with FEMA’s various disaster aid programs,
including the Hazard Mitigation Grant Program, the Public Assistance
Grant Program, and the Individual Assistance Grant Program.

FEMA data is publicly available at the open FEMA website
(<https://www.fema.gov/about/openfema/data-sets>) and is avaliable for
bulk download, however, the files are sometimes very large (multiple
gigabytes) and many times users do not need all records for a data
series (ex: may only want a single state for several years). Using
FEMA’s API is a good option to circumvent working with the bulk data
files, but can be intimidating for those not used to working with APIs.
This package contains a set of functions that allows users to identify
the data they need and query the API to get that data.

## Installation

``` r
#install.packages("devtools") # install if not already in library
devtools::install_github("dylan-turner25/rfema")
```

    ## Skipping install of 'rfema' from a github remote, the SHA1 (22305bc0) has not changed since last install.
    ##   Use `force = TRUE` to force installation

``` r
library(rfema)
```

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
many iterations to collect the full data set.

``` r
#openFema(data_set = "fimaNfipPolicies")

"[1] 59341663 matching records found. At 1000 records per call, it will take 59342 individual API calls to get all matching records. Continue?"
```

    ## [1] "[1] 59341663 matching records found. At 1000 records per call, it will take 59342 individual API calls to get all matching records. Continue?"

If we want to quickly see the set of variables that can be used to
filter API queries with, we can use the valid\_parameters() function to
return a vector containing the variables that are “searchable” for a
particular data set.

``` r
params <- valid_parameters(data_set = "fimaNfipPolicies")
kable(head(params))
```

| x                               |
|:--------------------------------|
| baseFloodElevation              |
| basementEnclosureCrawlspaceType |
| cancellationDateOfFloodPolicy   |
| censusTract                     |
| condominiumIndicator            |
| countyCode                      |
