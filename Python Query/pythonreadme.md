# Python Program for Uploading CSV Data to BigQuery

This Python program is designed to facilitate the process of uploading CSV data into Google BigQuery. It provides functions to create tables in BigQuery and upload data from CSV files into those tables. The program is designed to work with a predefined schema for three types of data: "device," "transaction," and "store." The main purpose of this program is to automate the process of setting up the schema and uploading data to the specified BigQuery dataset and tables.

#### 1. Setting Up Table Schemas:

The program defines three schemas, one for each type of data:

* STORE_SCHEMA: Represents the schema for the "store" table, containing fields such as ID, name, address, city, country, created_at, typology, and customer_id.
* DEVICE_SCHEMA: Represents the schema for the "device" table, containing fields like ID, type, and store_id.
* TRANSACTION_SCHEMA: Represents the schema for the "transaction" table, containing fields such as ID, device_id, product_name, product_sku, product_name_2, amount, status, card_number, cvv, created_at, and happened_at.

#### 2. Uploading Data to BigQuery:

The program provides two essential functions for interacting with BigQuery:

* a. create_table_if_not_exists: This function checks if a table already exists in the specified dataset and creates it if it does not exist. It takes the following parameters:

client: The BigQuery client used to interact with the service.
dataset_ref: A reference to the dataset where the table should be created.
table_id: The ID of the table to create.
schema: The schema of the table to be created.
b. upload_csv_to_bigquery: This function reads data from a CSV file and uploads it to the specified BigQuery table. It takes the following parameters:

* client: The BigQuery client used to interact with the service.
dataset_ref: A reference to the dataset where the data should be uploaded.
table_id: The ID of the table where the data should be uploaded.
schema: The schema of the table where the data should be uploaded.
csv_file: The path to the CSV file containing the data to be uploaded.

#### 3. Main Execution:

The main function orchestrates the entire process. It iterates through the table_config dictionary, which contains information about each table type and its corresponding CSV file. For each table, it does the following:

Determines the dataset ID and table ID.
Creates the table in BigQuery if it does not already exist.
Uploads data from the corresponding CSV file into the table.

#### 4. Usage:

Before running the program, ensure you have set up the necessary credentials to access Google BigQuery. Additionally, ensure that you have the required CSV files in the same directory as the Python script, with filenames specified in the table_config dictionary.
