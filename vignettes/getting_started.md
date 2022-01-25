

## Introduction

This vignette provides a brief overview on using the `rfema` package to obtain data from the Open FEMA API. The rest of this vignette covers how to install the package, followed by examples on using the package to obtain data for various objectives. 

## Installation
Right now, the best way to install and use the `rfema` package is by installing directly from rOpenSci using `install.packages("rfema", repos = "https://ropensci.r-universe.dev")`. The FEMA API does not require and API key, meaning no further setup steps need be taken to start using the package

## Available Datasets
For those unfamiliar with the data sets available through the FEMA API, a good starting place is to visit the [FEMA API documentation page](https://www.fema.gov/about/openfema/data-sets). However, if you are already familiar with the data and want to quickly reference the data set names or another piece of meta data, using the `fema_data_sets()` function to obtain a tibble of available data sets along with associated meta data is a convenient option.

```r
# store the avaliable data sets as an object in your R environment that can be referenced later
data_sets <- fema_data_sets() 

# view data 
data_sets
#> # A tibble: 37 × 64
#>    identifier  name     title    description      distribution.acces… distribution.fo… distribution.da…
#>    <chr>       <chr>    <chr>    <chr>            <chr>               <chr>            <chr>           
#>  1 openfema-1  PublicA… Public … FEMA provides s… https://www.fema.g… csv              small (10MB - 5…
#>  2 openfema-1  PublicA… Public … FEMA provides s… https://www.fema.g… csv              small (10MB - 5…
#>  3 openfema-26 FemaWeb… FEMA We… This data set c… https://www.fema.g… csv              medium (50MB - …
#>  4 openfema-28 HazardM… Hazard … This dataset co… https://www.fema.g… csv              small (10MB - 5…
#>  5 openfema-36 FemaReg… FEMA Re… Provides the li… https://www.fema.g… csv              tiny (< 10 MB)  
#>  6 openfema-22 Emergen… Emergen… This dataset co… https://www.fema.g… csv              tiny (< 10MB)   
#>  7 openfema-45 HazardM… Hazard … The dataset con… https://www.fema.g… csv              small (10MB - 5…
#>  8 openfema-12 Housing… Housing… This dataset wa… https://www.fema.g… csv              small (10MB - 5…
#>  9 openfema-8  DataSet… OpenFEM… Metadata for th… https://www.fema.g… csv              tiny (< 10MB)   
#> 10 openfema-37 HazardM… Hazard … This dataset co… https://www.fema.g… csv              small (10MB - 5…
#> # … with 27 more rows, and 57 more variables: distribution.accessURL.1 <chr>,
#> #   distribution.format.1 <chr>, distribution.datasetSize.1 <chr>, distribution.accessURL.2 <chr>,
#> #   distribution.format.2 <chr>, distribution.datasetSize.2 <chr>, webService <chr>,
#> #   dataDictionary <chr>, keyword <chr>, modified <chr>, publisher <chr>, contactPoint <chr>,
#> #   mbox <chr>, accessLevel <chr>, landingPage <chr>, temporal <chr>, api <chr>, version <chr>,
#> #   bureauCode <chr>, programCode <chr>, accessLevelComment <chr>, license <chr>, spatial <chr>,
#> #   theme <chr>, dataQuality <chr>, accrualPeriodicity <chr>, language <chr>, …
```


## Example Workflow
Once we know what data set we want to access, or perhaps if we want to know more about what data is available in a given data set, we can use the `fema_data_fields()` function to get a look at the available data fields in a given data set by setting the "data_set" parameter to one of the "name" columns in the data frame returned by the `fema_data_sets()` function.

```r
# obtain all the data fields for the NFIP Policies data set
df <- fema_data_fields(data_set = "fimaNfipPolicies")

# Note: the data set field is not case sensative, meaning you do not need to 
# use camel case names despite that being the convention in the FEMA documentation.
df <- fema_data_fields(data_set = "fimanfippolicies")

# view the data fields 
df
#> # A tibble: 46 × 15
#>    datasetId   openFemaDataSet name  title description type  sortOrder datasetVersion hash  lastRefresh
#>    <chr>       <chr>           <chr> <chr> <chr>       <chr> <chr>     <chr>          <chr> <chr>      
#>  1 openfema-32 FimaNfipPolici… 1     agri… Agricultur… Yes … boolean   1              FALSE FALSE      
#>  2 openfema-32 FimaNfipPolici… 1     base… Base Flood… Base… number    2              TRUE  FALSE      
#>  3 openfema-32 FimaNfipPolici… 1     base… Basement E… Base… number    3              TRUE  FALSE      
#>  4 openfema-32 FimaNfipPolici… 1     canc… Cancellati… The … date      4              TRUE  FALSE      
#>  5 openfema-32 FimaNfipPolici… 1     cond… Condominiu… This… string    6              TRUE  FALSE      
#>  6 openfema-32 FimaNfipPolici… 1     cens… Census Tra… US C… string    5              TRUE  FALSE      
#>  7 openfema-32 FimaNfipPolici… 1     coun… County Code FIPS… string    8              TRUE  FALSE      
#>  8 openfema-32 FimaNfipPolici… 1     crsC… CRS Classi… The … number    9              TRUE  FALSE      
#>  9 openfema-32 FimaNfipPolici… 1     cons… Constructi… Is t… boolean   7              FALSE FALSE      
#> 10 openfema-32 FimaNfipPolici… 1     dedu… Deductible… The … number    10             TRUE  FALSE      
#> # … with 36 more rows, and 5 more variables: isNestedObject <chr>, isNullable <chr>,
#> #   isSearchable <chr>, primaryKey <chr>, id <chr>
```



The FEMA API limits the number of records that can be returned in a single query to 1000, meaning if we want more observations than that, a loop is necessary to iterate over multiple API calls. The `open_fema` function handles this process automatically, but by default will issue a warning letting you know how many records match your criteria and how many API calls it will take to retrieve all those records and ask you to confirm the request before it starts retrieving data (this behavior can be turned off by setting the `ask_before_call` argument to `FALSE`). Additionally an estimated time will be issued to give you a sense of how long it will take to complete the request. For example, requesting the entire NFIP claims data set via `open_fema(data_set = "fimaNfipClaims")` will yield the following output in the R console.


```
#> Calculating estimated API call time...
#> 2564279 matching records found. At 1000 records per call, it will take 2565 individual API calls to get all matching records. It's estimated that this will take approximately 57.12 minutes. Continue?
#> [1] 1 - Yes, get that data!, 0 - No, let me rethink my API call:
```

Note that the estimated time is based on network conditions at the initial time the call is being made and may not be accurate for large data requests that take long enough for network conditions to potential change significantly during the request. As an aside, for large data requests, like downloading the entire data set, it will usually be faster to perform a bulk download using the `bulk_dl` function. 


Alternatively, we could specify the top_n argument to limit the number of records returned. Specifying top_n greater than 1000 will initiate the same message letting you know how many iterations it will take to get your data. If top_n is less than 1000, the API call will automatically be carried out. In the case below, we will return the first 10 records from the NFIP Claims data.

```r
df <- open_fema(data_set = "fimaNfipClaims", top_n = 10)

df
#> # A tibble: 10 × 40
#>    agricultureStru… asOfDate            baseFloodElevat… basementEnclosu… reportedCity condominiumIndi…
#>    <chr>            <dttm>              <chr>            <chr>            <chr>        <chr>           
#>  1 FALSE            2021-07-25 00:00:00 NULL             1                Temporarily… N               
#>  2 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#>  3 FALSE            2021-11-21 00:00:00 8                NULL             Temporarily… N               
#>  4 FALSE            2021-11-21 00:00:00 50               NULL             Temporarily… N               
#>  5 FALSE            2021-11-21 00:00:00 NULL             NULL             Temporarily… N               
#>  6 FALSE            2021-11-21 00:00:00 15               2                Temporarily… N               
#>  7 FALSE            2021-11-21 00:00:00 NULL             NULL             Temporarily… N               
#>  8 FALSE            2021-11-21 00:00:00 NULL             NULL             Temporarily… N               
#>  9 FALSE            2021-11-21 00:00:00 8                NULL             Temporarily… N               
#> 10 FALSE            2021-11-21 00:00:00 9                NULL             Temporarily… N               
#> # … with 34 more variables: policyCount <chr>, countyCode <chr>, communityRatingSystemDiscount <chr>,
#> #   dateOfLoss <dttm>, elevatedBuildingIndicator <chr>, elevationCertificateIndicator <chr>,
#> #   elevationDifference <chr>, censusTract <chr>, floodZone <chr>, houseWorship <chr>, latitude <chr>,
#> #   longitude <chr>, locationOfContents <chr>, lowestAdjacentGrade <chr>, lowestFloorElevation <chr>,
#> #   numberOfFloorsInTheInsuredBuilding <chr>, nonProfitIndicator <chr>, obstructionType <chr>,
#> #   occupancyType <chr>, originalConstructionDate <dttm>, originalNBDate <dttm>,
#> #   amountPaidOnBuildingClaim <chr>, amountPaidOnContentsClaim <chr>, …
```

If we wanted to limit the columns returned we could do so by passing a character vector of data fields to be included in the returned data frame. The data fields for a given data set can be retrieved using the `fema_data_fields()` function.


```r
data_fields <- fema_data_fields("fimanfipclaims")

data_fields
#> # A tibble: 40 × 15
#>    datasetId   openFemaDataSet name  title description type  sortOrder datasetVersion hash  lastRefresh
#>    <chr>       <chr>           <chr> <chr> <chr>       <chr> <chr>     <chr>          <chr> <chr>      
#>  1 openfema-31 FimaNfipClaims  1     "agr… "Agricultu… Yes … boolean   1              FALSE FALSE      
#>  2 openfema-31 FimaNfipClaims  1     "asO… "As Of Dat… The … date      2              TRUE  FALSE      
#>  3 openfema-31 FimaNfipClaims  1     "bas… "Base Floo… Base… number    3              TRUE  FALSE      
#>  4 openfema-31 FimaNfipClaims  1     "bas… "Basement … Base… number    4              TRUE  FALSE      
#>  5 openfema-31 FimaNfipClaims  1     "rep… "Reported … This… string    5              TRUE  FALSE      
#>  6 openfema-31 FimaNfipClaims  1     "con… "Condomini… This… string    6              TRUE  FALSE      
#>  7 openfema-31 FimaNfipClaims  1     "pol… "Policy Co… Insu… number    7              TRUE  FALSE      
#>  8 openfema-31 FimaNfipClaims  1     "cou… "County Co… FIPS… string    8              TRUE  FALSE      
#>  9 openfema-31 FimaNfipClaims  1     "com… "Community… The … number    9              TRUE  FALSE      
#> 10 openfema-31 FimaNfipClaims  1     "dat… "Date Of L… Date… date      10             TRUE  FALSE      
#> # … with 30 more rows, and 5 more variables: isNestedObject <chr>, isNullable <chr>,
#> #   isSearchable <chr>, primaryKey <chr>, id <chr>
```


In this case we will return only the `policyCount` and `floodZone` columns. As can be seen, an id column is always returned even if the select argument is used. 

```r
df <- open_fema(data_set = "fimaNfipClaims", top_n = 10, select = c("policyCount","floodZone"))

df
#> # A tibble: 10 × 3
#>    policyCount floodZone id                      
#>    <chr>       <chr>     <chr>                   
#>  1 1           X         61eb2db1b54c2b9a4db56b04
#>  2 1           AE        61eb2db1b54c2b9a4db56b05
#>  3 1           AE        61eb2db1b54c2b9a4db56b06
#>  4 1           AE        61eb2db1b54c2b9a4db56b07
#>  5 1           AE        61eb2db1b54c2b9a4db56b08
#>  6 1           VE        61eb2db1b54c2b9a4db56b09
#>  7 1           A         61eb2db1b54c2b9a4db56b0a
#>  8 1           A02       61eb2db1b54c2b9a4db56b0b
#>  9 1           AE        61eb2db1b54c2b9a4db56b0c
#> 10 1           AE        61eb2db1b54c2b9a4db56b0d
```

If we want to limit the rows returned rather than the columns, we can also apply filters by specifying values of the columns to return. If we want to quickly see the set of variables that can be used to filter API queries with, we can use the valid_parameters() function to return a tibble containing the variables that are "searchable" for a particular data set. 

```r
params <- valid_parameters(data_set = "fimaNfipClaims")

params
#> # A tibble: 40 × 1
#>    title                          
#>    <chr>                          
#>  1 agricultureStructureIndicator  
#>  2 asOfDate                       
#>  3 baseFloodElevation             
#>  4 basementEnclosureCrawlspaceType
#>  5 reportedCity                   
#>  6 condominiumIndicator           
#>  7 policyCount                    
#>  8 countyCode                     
#>  9 communityRatingSystemDiscount  
#> 10 dateOfLoss                     
#> # … with 30 more rows
```

We can see from the above that both `policyCount` and `floodZone` are both searchable variables. Thus we can specify a list that contains the values of each variable that we want returned. Before doing that however, it can be useful to learn a bit more about each parameter by using the `parameter_values()` function. 


```r
# get more information onf the "floodZone" parameter from the NFIP Claims data set
parameter_values(data_set = "fimaNfipClaims",data_field = "floodZone")
#> Data Set: FimaNfipClaims
#> Data Field: floodZone
#> Data Field Description: Flood zone derived from the Flood Insurance Rate Map (FIRM) used to rate the insured property.A - Special Flood with no Base Flood Elevation on FIRM; AE, A1-A30 - Special Flood with Base Flood Elevation on FIRM; A99 - Special Flood with Protection Zone; AH, AHB* - Special Flood with Shallow Ponding; AO, AOB* - Special Flood with Sheet Flow; X, B - Moderate Flood from primary water source.  Pockets of areas subject to drainage problems; X, C - Minimal Flood from primary water source.  Pockets of areas subject to drainage problems; D - Possible Flood; V - Velocity Flood with no Base Flood Elevation on FIRM; VE, V1-V30 - Velocity Flood with Base Flood Elevation on FIRM; AE, VE, X - New zone designations used on new maps starting January 1, 1986, in lieu of A1-A30, V1-V30, and B and C; AR - A Special Flood Hazard Area that results from the decertification of a previously accredited flood protection system that is determined to be in the process of being restored to provide base flood protection;AR Dual Zones - (AR/AE, AR/A1-A30, AR/AH, AR/AO, AR/A) Areas subject to flooding from failure of the flood protection system (Zone AR) which also overlap an existing Special Flood Hazard Area as a dual zone; *AHB, AOB, ARE, ARH, ARO, and ARA are not risk zones shown on a map, but are acceptable values for rating purposes
#> Data Field Example Values: c("X", "AE", "VE", "A", "A02", "AOB")
#> More Information Available at: https://www.fema.gov/about/openfema/data-sets
```

As can be seen `parameter_values()` returns the data set name, the data field (i.e. the searchable parameter), a description of the data field, and a vector of examples of the data field values which can be useful for seeing how the values are formatted in the data. 

```r
parameter_values(data_set = "fimaNfipClaims",data_field = "floodZone")
```


We can see from the above that `floodZone` is a character in the data and from the description we know that "AE" and "X" are both valid values for the `floodZone` parameter. We can thus define a filter to return only records from AE or X flood zones.

```r
# construct a filter that limits records to those in AE or X flood zones
my_filters <- list(floodZone = c("AE","X"))

# pass the filter to the open_fema function.
df <- open_fema(data_set = "fimaNfipPolicies", top_n = 10, 
               select = c("policyCount","floodZone"), filters = my_filters)
#> Error in (function (data_set, top_n = NULL, filters = NULL, select = NULL, : Server error: (503) Service Unavailable

df
#> # A tibble: 10 × 3
#>    policyCount floodZone id                      
#>    <chr>       <chr>     <chr>                   
#>  1 1           X         61eb2db1b54c2b9a4db56b04
#>  2 1           AE        61eb2db1b54c2b9a4db56b05
#>  3 1           AE        61eb2db1b54c2b9a4db56b06
#>  4 1           AE        61eb2db1b54c2b9a4db56b07
#>  5 1           AE        61eb2db1b54c2b9a4db56b08
#>  6 1           VE        61eb2db1b54c2b9a4db56b09
#>  7 1           A         61eb2db1b54c2b9a4db56b0a
#>  8 1           A02       61eb2db1b54c2b9a4db56b0b
#>  9 1           AE        61eb2db1b54c2b9a4db56b0c
#> 10 1           AE        61eb2db1b54c2b9a4db56b0d
```






## More Examples

### Example: Return the first 100 NFIP claims for Autauga County, AL that happened between 2010 and 2020.

```r
df <- open_fema(data_set = "fimaNfipClaims",
                 top_n = 100,
                 filters = list(countyCode = "= 01001",
                                yearOfLoss = ">= 2010",
                                yearOfLoss = "<= 2020"))

df
#> # A tibble: 20 × 40
#>    agricultureStru… asOfDate            baseFloodElevat… basementEnclosu… reportedCity condominiumIndi…
#>    <chr>            <dttm>              <chr>            <chr>            <chr>        <chr>           
#>  1 FALSE            2021-11-21 00:00:00 NULL             0                Temporarily… N               
#>  2 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#>  3 FALSE            2021-07-25 00:00:00 NULL             1                Temporarily… N               
#>  4 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#>  5 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#>  6 FALSE            2021-11-21 00:00:00 NULL             NULL             Temporarily… N               
#>  7 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#>  8 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#>  9 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#> 10 FALSE            2021-11-21 00:00:00 164              0                Temporarily… N               
#> 11 FALSE            2021-07-25 00:00:00 184              0                Temporarily… N               
#> 12 FALSE            2021-07-25 00:00:00 184              0                Temporarily… N               
#> 13 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#> 14 FALSE            2021-07-25 00:00:00 NULL             NULL             Temporarily… N               
#> 15 FALSE            2022-01-14 00:00:00 NULL             NULL             Temporarily… N               
#> 16 FALSE            2021-07-25 00:00:00 NULL             1                Temporarily… N               
#> 17 FALSE            2021-07-25 00:00:00 NULL             1                Temporarily… N               
#> 18 FALSE            2021-11-21 00:00:00 164              NULL             Temporarily… N               
#> 19 FALSE            2021-10-25 00:00:00 NULL             NULL             Temporarily… N               
#> 20 FALSE            2021-12-25 00:00:00 NULL             0                Temporarily… N               
#> # … with 34 more variables: policyCount <chr>, countyCode <chr>, communityRatingSystemDiscount <chr>,
#> #   dateOfLoss <dttm>, elevatedBuildingIndicator <chr>, elevationCertificateIndicator <chr>,
#> #   elevationDifference <chr>, censusTract <chr>, floodZone <chr>, houseWorship <chr>, latitude <chr>,
#> #   longitude <chr>, locationOfContents <chr>, lowestAdjacentGrade <chr>, lowestFloorElevation <chr>,
#> #   numberOfFloorsInTheInsuredBuilding <chr>, nonProfitIndicator <chr>, obstructionType <chr>,
#> #   occupancyType <chr>, originalConstructionDate <dttm>, originalNBDate <dttm>,
#> #   amountPaidOnBuildingClaim <chr>, amountPaidOnContentsClaim <chr>, …
```


### Example: Get data on all Hazard Mitigation Grants associated with Hurricanes in Florida.

```r
# see which parameter can be used for filtering the Hazard Mitigation Grants data set
valid_parameters("HazardMitigationGrants") 
#> # A tibble: 19 × 1
#>    params             
#>    <chr>              
#>  1 id                 
#>  2 projectType        
#>  3 projectCounties    
#>  4 status             
#>  5 subgrantee         
#>  6 disasterNumber     
#>  7 state              
#>  8 projectAmount      
#>  9 region             
#> 10 declarationDate    
#> 11 projectNumber      
#> 12 disasterTitle      
#> 13 projectDescription 
#> 14 lastRefresh        
#> 15 costSharePercentage
#> 16 subgranteeFIPSCode 
#> 17 projectTitle       
#> 18 incidentType       
#> 19 hash

# see how values of "incidentType" are formatted
parameter_values(data_set = "HazardMitigationGrants", data_field = "incidentType") 
#> Data Set: HazardMitigationGrants
#> Data Field: incidentType
#> Data Field Description: 
#> Data Field Example Values: c("Flood", "Severe Storm(s)", "Tornado", "Freezing", "Hurricane", "Earthquake")
#> More Information Available at: https://www.fema.gov/about/openfema/data-sets

# check to see how "state" is formatted
parameter_values(data_set = "HazardMitigationGrants", data_field = "state") 
#> Data Set: HazardMitigationGrants
#> Data Field: state
#> Data Field Description: string
#> Data Field Example Values: c("Kentucky", "Utah", "North Dakota", "Texas", "North Carolina", "Alaska")
#> More Information Available at: https://www.fema.gov/about/openfema/data-sets

# construct a list containing filters for Hurricane and Florida
filter_list <- c(incidentType = c("Hurricane"),
                 state = c("Florida")) 

# pass filter_list to the open_fema function to retreieve data.
df <- open_fema(data_set = "HazardMitigationGrants", filters = filter_list, 
               ask_before_call = FALSE)
#> Obtaining Data: 1 out of 2 iterations (50% complete)
#> Obtaining Data: 2 out of 2 iterations (100% complete)


df
#> # A tibble: 1,671 × 19
#>    region state disasterNumber declarationDate     incidentType disasterTitle projectNumber projectType
#>    <chr>  <chr> <chr>          <dttm>              <chr>        <chr>         <chr>         <chr>      
#>  1 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0004          401.1: Wat…
#>  2 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0002          205.8: Ret…
#>  3 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0003          501.1: Oth…
#>  4 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0001          602.1: Oth…
#>  5 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0019          205.8: Ret…
#>  6 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0014          601.1: Gen…
#>  7 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0018          205.8: Ret…
#>  8 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0049          601.1: Gen…
#>  9 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0029          205.8: Ret…
#> 10 4      Flor… 955            1992-08-24 00:00:00 Hurricane    HURRICANE AN… 0023          602.1: Oth…
#> # … with 1,661 more rows, and 11 more variables: projectTitle <chr>, projectDescription <chr>,
#> #   projectCounties <chr>, status <chr>, subgrantee <chr>, subgranteeFIPSCode <chr>,
#> #   projectAmount <chr>, costSharePercentage <chr>, hash <chr>, lastRefresh <chr>, id <chr>
```


### Example: Determine how much money was awarded by FEMA for rental assistance following Hurricane Irma.

Get a dataset description for the `HousingAssistanceRenters` data set to see if this is the right data set for the question

```r
# get meta data for the `HousingAssistanceRenters`
ds <- fema_data_sets() %>% filter(name == "HousingAssistanceRenters")

# there are two entries corresponding to two versions of the data set, 
# we want the most recent one
nrow(ds)
#> [1] 2
ds <- ds %>% filter(version == max(as.numeric(ds$version)))

# now print out the data set description and make sure its the data set 
# that applicable or our research question
print(ds$description)
#> [1] "The dataset was generated by FEMA's Enterprise Coordination & Information Management (ECIM) Reporting team and is primarily composed of data from Housing Assistance Program reporting authority from FEMA registration renters and owners within the state, county, zip where the registration is valid. This dataset contains aggregated, non-PII data on FEMA's Housing Assistance Program within the state, county, zip where the registration is valid for the declarations, starting with disaster declarations number 4116.  The data is divided into data for renters and data for property owners. Additional core data elements include number of applicants, county, zip code, severity of damage, owner or renter. Data is self-reported and as such is subject to human error. To learn more about disaster assistance please visit https://www.fema.gov/individual-disaster-assistance.This is raw, unedited data from FEMA's National Emergency Management Information System (NEMIS) and as such is subject to a small percentage of human error. For example, when an applicant registers they enter their street and city address.  The system runs a check and suggests a county.  The applicant, if registering online can override that choice.  If they are registering via the call center the Human Services Specialist (HSS) representatives are instructed to ask (not offer) what county they live in.  So even though the system might suggest County A,  an applicant has the right to choose County B.  The financial information is derived from NEMIS and not FEMA's official financial systems.  Due to differences in reporting periods, status of obligations and how business rules are applied, this financial information may differ slightly from official publication on public websites such as usaspending.gov;  this dataset is not intended to be used for any official federal financial reporting.Citation: The Agency's preferred citation for datasets (API usage or file downloads) can be found on the OpenFEMA Terms and Conditions page, Citing Data section: https://www.fema.gov/about/openfema/terms-conditions.If you have media inquiries about this dataset, please email the FEMA News Desk FEMA-News-Desk@dhs.gov or call (202) 646-3272.  For inquiries about FEMA's data and Open government program please contact the OpenFEMA team via email OpenFEMA@fema.dhs.gov."
```

See which columns we can filter on to select just Hurricane Irma related grants

```r
# see which parameter can be used for filtering the Housing Assistance for Renters 
valid_parameters("HousingAssistanceRenters") 
#> # A tibble: 44 × 1
#>    params                    
#>    <chr>                     
#>  1 city                      
#>  2 validRegistrations        
#>  3 disasterNumber            
#>  4 zipCode                   
#>  5 repairReplaceAmount       
#>  6 totalInspected            
#>  7 approvedForFemaAssistance 
#>  8 totalWithSubstantialDamage
#>  9 rentalAmount              
#> 10 otherNeedsAmount          
#> # … with 34 more rows
```

All we have in this data set is the `disasterNumber`. Thus, to filter on a specific disaster we have to load the `FemaWebDisasterDeclarations` data find the disaster number associated with the event we are interested in.

```r
# call the disaster declarations
dd <- rfema::open_fema(data_set = "FemaWebDisasterDeclarations", ask_before_call = F)
#> Obtaining Data: 1 out of 5 iterations (20% complete) Obtaining Data: 2 out of 5 iterations (40%
#> complete) Obtaining Data: 3 out of 5 iterations (60% complete) Obtaining Data: 4 out of 5 iterations
#> (80% complete) Obtaining Data: 5 out of 5 iterations (100% complete)

# filter disaster declarations to those with "hurricane" in the name
hurricanes <- distinct(dd %>% filter(grepl("hurricane",tolower(disasterName))) %>% select(disasterName, disasterNumber))
hurricanes
#> # A tibble: 381 × 2
#>    disasterName                               disasterNumber
#>    <chr>                                      <chr>         
#>  1 HURRICANE MARIA                            3390          
#>  2 HURRICANE IRMA                             3388          
#>  3 HURRICANE NATE                             3395          
#>  4 HURRICANE HARVEY                           4332          
#>  5 HURRICANE IRMA                             3384          
#>  6 HURRICANE IRMA - SEMINOLE TRIBE OF FLORIDA 4341          
#>  7 HURRICANE NATE                             3394          
#>  8 HURRICANE IRMA                             4336          
#>  9 HURRICANE NATE                             4349          
#> 10 HURRICANE IRMA                             3385          
#> # … with 371 more rows
```

We can see immediately that disaster numbers do not uniquely identify an event, since multiple disaster declarations may be declared for the same event, but in different locations. Thus to filter on a particular event, we need to collect all the disaster declaration numbers corresponding to that event (in this case Hurricane Irma). 

```r
# get all disaster declarations associated with hurricane irma. 
# notice the use of grepl() which picked up a disaster declaration name 
# that was different than all the others.
dd_irma <- hurricanes %>% filter(grepl("irma",tolower(disasterName)))
dd_irma
#> # A tibble: 13 × 2
#>    disasterName                               disasterNumber
#>    <chr>                                      <chr>         
#>  1 HURRICANE IRMA                             3388          
#>  2 HURRICANE IRMA                             3384          
#>  3 HURRICANE IRMA - SEMINOLE TRIBE OF FLORIDA 4341          
#>  4 HURRICANE IRMA                             4336          
#>  5 HURRICANE IRMA                             3385          
#>  6 HURRICANE IRMA                             4346          
#>  7 HURRICANE IRMA                             3383          
#>  8 HURRICANE IRMA                             3389          
#>  9 HURRICANE IRMA                             4338          
#> 10 HURRICANE IRMA                             3386          
#> 11 HURRICANE IRMA                             4335          
#> 12 HURRICANE IRMA                             3387          
#> 13 HURRICANE IRMA                             4337

# get a vector of just the disaster declaration numbers
dd_nums_irma <- dd_irma$disasterNumber
```

Now we are read to filter our API call for the `HousingAssistanceRenters` data set.

```r
# construct filter list
filter_list <- list(disasterNumber = dd_nums_irma)


# make the API call to get individual assistance grants awarded to renters for hurricane Irma damages.
assistance_irma <- open_fema(data_set = "HousingAssistanceRenters", filters = filter_list, ask_before_call = F)
#> Obtaining Data: 1 out of 6 iterations (16.67% complete) Obtaining Data: 2 out of 6 iterations (33.33%
#> complete) Obtaining Data: 3 out of 6 iterations (50% complete) Obtaining Data: 4 out of 6 iterations
#> (66.67% complete) Obtaining Data: 5 out of 6 iterations (83.33% complete) Obtaining Data: 6 out of 6
#> iterations (100% complete)
```

Check out the returned data

```r
# check out the returned data
assistance_irma
#> # A tibble: 5,353 × 21
#>    state validRegistrations totalInspected totalInspectedWithNoDamage totalWithModera… totalWithMajorD…
#>    <chr> <chr>              <chr>          <chr>                      <chr>            <chr>           
#>  1 VI    1                  1              1                          0                0               
#>  2 VI    6                  4              4                          2                0               
#>  3 VI    1                  1              0                          1                0               
#>  4 VI    267                203            186                        63               18              
#>  5 VI    4                  4              2                          1                0               
#>  6 VI    1                  0              1                          0                0               
#>  7 VI    1                  1              1                          0                0               
#>  8 VI    1                  1              1                          0                0               
#>  9 VI    1                  0              1                          0                0               
#> 10 VI    1                  1              1                          0                0               
#> # … with 5,343 more rows, and 15 more variables: totalWithSubstantialDamage <chr>,
#> #   approvedForFemaAssistance <chr>, totalApprovedIhpAmount <chr>, repairReplaceAmount <chr>,
#> #   rentalAmount <chr>, otherNeedsAmount <chr>, approvedBetween1And10000 <chr>,
#> #   approvedBetween10001And25000 <chr>, approvedBetween25001AndMax <chr>, totalMaxGrants <chr>,
#> #   disasterNumber <chr>, zipCode <chr>, county <chr>, city <chr>, id <chr>
```


Now we can answer our original question: How much did FEMA awarded for rental assistance following Hurricane Irma?

```r
# sum the rentalAmount Column
rent_assistance <- sum(as.numeric(assistance_irma$rentalAmount))

# scale to millions
rent_assistance <- rent_assistance/1000000

print(paste0("$",round(rent_assistance,2),
             " million was awarded by FEMA for rental assistance following Hurricane Irma"))
#> [1] "$314.64 million was awarded by FEMA for rental assistance following Hurricane Irma"
```



## Bulk Downloads
In some cases bulk downloading a full data set file may be preferred. For particularly large data requests, its usually faster to bulk download the entire data set as a csv file and then load it into the R environment. In this case, users can use the bulk_dl() command to download a csv of the full data file and save it to a specified directory.

```r
bulk_dl("femaRegions") # download a csv file containing all info on FEMA regions
```


