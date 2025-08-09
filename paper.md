---
title: 'rfema: An R Package for accessing data from the U.S. Federal Emergency Management Agency API'
tags:
  - R
  - FEMA
  - natural disasters
  - flood insurance
  - API
authors:
  - name: Dylan Turner
    orcid: 0000-0002-0915-7384
    affiliation: 1
affiliations:
 - name: North Dakota State University, Agricultural Risk Policy Center
   index: 1
date: 9 August 2025
bibliography: paper.bib 
---

# Summary

The `rfema` R package provides a simplified interface for accessing data from the U.S. Federal Emergency Management Agency (FEMA) open API. FEMA maintains extensive datasets related to disaster risk management, flood insurance claims, hazard mitigation projects, and individual assistance programs that are crucial for research on natural hazards, policy analysis, and emergency management planning. However, accessing these datasets directly through FEMA's API can be challenging for researchers without technical API experience, particularly given the API's 1000-record-per-call limit that requires iterative requests for complete datasets.

The `rfema` package abstracts away the complexity of API interactions by providing intuitive R functions that handle authentication-free API calls, automatic pagination through large datasets, and data cleaning operations including date parsing and data type conversions. The package enables researchers to easily discover available datasets through metadata functions, apply filters to retrieve specific subsets of data, and obtain research-ready tibbles with properly formatted columns. Key functionality includes accessing National Flood Insurance Program (NFIP) claims and policies data, disaster declarations, hazard mitigation assistance records, and housing assistance data, among others. By eliminating technical barriers to FEMA data access, `rfema` supports reproducible research related to natural hazards, flood risk analysis, and emergency management.

# Statement of need

Research on natural hazards increasingly relies on comprehensive historical data to understand patterns in natural hazard impacts, evaluate policy effectiveness, and inform risk mitigation strategies. FEMA's open data represents one of the most extensive repositories of disaster-related information in the United States, containing over 50 datasets with millions of records spanning decades of disaster response, flood insurance claims, and hazard mitigation activities. Historically, FEMA hosted bulk CSV files for download, but as of 2025, data can only be accessed using the FEMA API. However, the technical complexity of API interactions creates a significant barrier for researchers who need this data for scientific analysis.

Existing R packages for general API access, such as `httr` [@Wickham2020] and `jsonlite` [@Ooms2014], provide low-level functionality but require substantial programming expertise to handle FEMA's specific API structure, pagination requirements, and data format inconsistencies. Researchers often spend considerable time writing custom scripts to manage API calls, handle errors, and clean returned data.

The `rfema` package fills this gap by providing a domain-specific solution that handles FEMA API complexities automatically. Unlike general-purpose API packages, `rfema` is specifically designed for FEMA's data structure and includes built-in knowledge of available datasets, searchable parameters, and appropriate data transformations. This enables researchers focusing on natural hazards, flood risk assessment, climate adaptation, and emergency management to focus on their research questions rather than data acquisition mechanics.

The package supports reproducible research practices by providing consistent, documented methods for data retrieval that can be easily shared and replicated across studies. This is particularly important for natural hazards research, where data consistency and transparency are crucial for policy recommendations and risk assessments that protect lives and property.

# Acknowledgements

The author thanks the rOpenSci community for their thorough peer review process, with particular appreciation to reviewers François Michonneau and Marcus Beck for their valuable feedback and contributions to code quality. 

# References
