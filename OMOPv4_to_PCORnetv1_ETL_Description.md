<h1>Overview</h1>
This document describes the ETL specifications/conventions that enable data stored in the [OMOP CDM v4.0] (http://omop.org/CDM) model to be mapped to the [PCORnet v1](http://pcornet.org/wp-content/uploads/2014/07/2014-05-30g-PCORnet-Common-Data-Model-v1-0-RELEASE.pdf) model. In particular, this document describes the business logic corresponding to the ETL code in the [OMOP-PCORNet r3.1.sql](https://github.com/OHDSI/OMOPV4_PCORNetV1_ETL/blob/master/OMOP-PCORNet%20r3.3.sql) file. In this process, we assume that an OMOP CDM v4 instance is already available for transformation to the PCORnet model instance. 

This document should be used in conjunction with the [omop_pcornet_mappings.csv](https://github.com/OHDSI/OMOPV4_PCORNetV1_ETL/blob/master/omop_pcornet_mappings.csv) file (referred to as the *vocabulary mapping document* hereafter). The vocabulary mapping document is implemented into the table “cz_omop_pcornet_concept_map,”
referred to as the *source-to-concept mapping table* hereafter. 

Each (destination) field in the target PCORnet table is described based on the following dimensions: 

1. Source Table: the OMOP table to be referred 
2. Source Field(s): the field(s) in the source table that is used for deriving the value of the destination field; the value could also be a concatenation of values from multiple source fields, e.g. the value for the BIRTH_DATE field in the PCORnet table DEMOGRAPHIC. 
3.	Transformation Logic:  the following dimensions describe the logic to map the OMOP field to PCORnet field: 
  - General: Any general comment on transformation, such as formatting or re-computation
  - Concept Class for mapping to PCORnet vocabulary: the concept class for the destination field in the vocabulary mapping document that maps the OMOP concept identifiers to PCORnet values; this dimension is only applicable for the destination fields that are required to be coded in the PCORnet vocabulary. If empty, the source value should be copied to the destination value without any transformation.
  - OMOP Concept ID for Observations: The OMOP concept identifier for any destination field that represents an observable concept, e.g. height, weight, etc. 
  - Required Joins: The SQL JOIN operations required to derive the correct value for the destination field, e.g. total five join operations are required to generate the DEMOGRAPHIC table. 
