OMOPV4_PCORNetV1_ETL
====================

This repository contains the documentation and source code to transform an instance of OMOP CDMv 4 to an instance of PCORnet v1

### omop_pcornet_mappings.csv
This document contains the mappings from OMOP vocabulary to PCORnet vocabulary 

### ASSUMPTIONS.docx
This document describes all the assumptions made for the transformation process. 

### OMOPv4 to PCORnetv1 ETL Description 22-Sep-14.docx
This document describes the ETL process to populate each field of the PCORnet model. 

### cz_omop_pcornet_concept_map_ddl.txt
This document contains the DDL script to load the source-to-concept mapping table (i.e. OMOP->PCORnet vocabulary mapping) into database

### pcornet_schema_ddl.sql
This is the script to generate the pcornet schema in a PostgreSQL database. For this script to run without errors, the 'rosita' username must be replaced by the name of the user of your OMOP database. Important: running this script will permanently erase all data in the existing pcornet schema.

### OMOP-PCORNet r3.3.sql
This file contains the complete ETL source code, i.e. table-wise SQL queries to extract the PCORnet instance from a given OMOP instance and the source-to-concept mapping table 

### Changes.txt
This document describes changes made to each version of the repository
