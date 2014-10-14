The ETL repository for OMOP CDM V4 to PCORnet CDM V1 transformation
===============================================================================

This repository contains the documentation and source code to transform an instance of OMOP CDM v4 to an instance of PCORnet CDM v1. The documentation and source code (in PostgreSQL) are designed for the PEDSnet project but may also be useful for other CDRNs. 

### omop_pcornet_mappings.csv
This document contains the mappings from OMOP vocabulary to PCORnet vocabulary. Each column in this file denotes the following: 
- Source_Concept_Class: Concept class in the OMOP vocabulary (refers to the name of a field in PCORnet model that needs to be encoded into the PCORnet vocabulary) 
- PCORNET_Concept: value as represented in the PCORnet vocabulary
- Standard_Concept_ID: concept_id in the OMOP vocabulary (this columns refers to the observation_concept_id field of the Observation table, in case of PCORnet fields that are recorded as observations in the OMOP model) 
- Value_as_concept: value_as_concept_id field in the the Observation table in OMOP (only applicable for fields that are recorded as observations in the OMOP model)
- Concept_Description: Natural language description of the value


### ASSUMPTIONS.docx
This document describes all the assumptions made for the transformation process. 

### OMOPv4_to_PCORnetv1_ETL_Description.md
This document describes the ETL process to populate each field of the PCORnet model. 

### cz_omop_pcornet_concept_map_ddl.sql
This document contains the DDL script to create the source-to-concept mapping table (i.e. OMOP->PCORnet vocabulary mapping) into database. In addition, each site is required to manually load the [omop_pcornet_mappings.csv file] (https://github.com/OHDSI/OMOPV4_PCORNetV1_ETL/blob/master/omop_pcornet_mappings.csv) into this table. The PostgreSQL setting for importing the file include: format=csv, header=check.

### pcornet_schema_ddl.sql
This is the script to generate the pcornet schema in a PostgreSQL database. For this script to run without errors, the 'rosita' username must be replaced by the name of the user of your OMOP database. Important: running this script will permanently erase all data in the existing pcornet schema.

### OMOP-PCORNet r3.3.sql
This file contains the complete ETL source code, i.e. table-wise SQL queries to extract the PCORnet instance from a given OMOP instance and the source-to-concept mapping table 

### Changes.txt
This document describes changes made to each version of the repository
