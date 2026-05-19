# dataengineering_course_dbt

For this project I am using FDA drug application (https://www.kaggle.com/datasets/protobioengineering/united-states-fda-drugs-feb-2024?select=drugs.csv) and WHO health systems and disease metrics data (https://www.kaggle.com/datasets/utkarshxy/who-worldhealth-statistics-2020-complete). Note that both datasets were modified for project purposes, thus data coming from this project does not represents reality. To test dbt incrementals and snapshots this data were additionally modified with new rows.

The idea of using this data is to answer the following questions:
  -  Which diseases have a lower number of drugs approved
  -  Which companies have more approved drugs for a specific disease and will earn more benefit
  -  Which disease is more frequent in each country for each of the periods
  -  Which countries present an appropriate health system in order to develop clinical trials
  -  Within countries with an appropriate health system, which are the most frequent diseases, and for this diseases, which have less approved drugs, to determine potential R&D in a specific disease
  -  Which FDA drug applications that were in tentative of approval have been recently approved, and within these, for which company and disease


The project followed a medallion architecture. Bronze layer and update process was donde in snowflake using procedures (see files in folder 'bronze_snowflake').
  -  Pre-update process files are:

    -  FDA_drugs.csv
    -  infc_diseases.csv
    -  non_infc_diseases.csv
    -  medicalDoctors.csv
    -  pharmacists.csv
    -  uhcCoverage.csv
     
  -  Post-update process files have the same name but with the '_updated' sufix.
  -  stg_csv.sql is a file for creating appropriate stages and csv format in snowflake. Note that files should be uploaded manually to each stage before running procedures
  -  procedure_first_charge.sql is a file for the charge of the first files
  -  procedure_updated.sql is a file for updating the files

Rest of the project was done in dbt and can be found in the rest of the folders. 
  Important folders are:
    Snapshots, containing unique snapshot for tracking historic changes in FDA applications marketing status
    Models, containing:
    
      -  Intermediate: previous transformations and incrementals before arriving to silver layer
      -  Silver: normalized models before arriving to gold
      -  Gold: with distinct fct and dim tables
      
    Overall, within each folder data was grouped according to the origin table or tables (which I will refer later as lineages):
    
      -  Health: tables comming from medicalDoctors.csv, pharmacists.csv and uhcCoverage.csv
      -  Drug: tables coming from FDA_drugs.csv
      -  Disease: tables coming from infc_diseases.csv and non_infc_diseases.csv
      
    More information about each model can be found in each of this folders within the corresponding __model.yml file

For each of the lineages the diagram for the distinct layers can be found in the following image (from top to bottom: lineage health; lineage disease; lineage drug):

<img width="1624" height="2944" alt="Lineages relationships" src="https://github.com/user-attachments/assets/7b15cec3-cb62-4e10-92a6-e7acb9da1677" />

Additionally, in slides folder a .pdf file named "presentacion_proyecto.pdf" can be found with a short presentation and description about the main characteristics of the project.

