# Analytics Engineer Technical Test (Take Home Challenge)

#### Description

This project aims to create a robust End-to-End ELT (Extract, Load, Transform) pipeline using Python, SQL, and DBT to process data from a data source and load it into a data warehouse. The goal is to efficiently answer specific business questions by designing and implementing effective data models. The pipeline is designed to handle large volumes of data, ensuring scalability and optimal performance.

#### Business Questions
The project seeks to answer the following business questions using the data provided in three CSV files:
* Top 10 stores per transacted amount
* Top 10 products sold
* Average transacted amount per store typology and country
* Percentage of transactions per device type
* Average time for a store to perform its 5 first transactions

#### Deliverables: 
Please share the source code, data model design, SQLs to answer the above questions via public git repository including a readme file explaining your assumptions, design and solution implementation details


> Usage of pandas libraries and python notebooks are not permitted and for any data manipulations please use SQL

#### Assumptions:

* Each of our customers have one or multiple stores, which are physical locations where their business happens, those stores are classified by different typology. 
* We also provide them with different types of devices (1 to 5), those devices are hardware needed to perform any kind of transactions, each of them are tied up to a specific store. 
* A transaction is a payment made using the provided devices, currently our devices only handle payment made by card and in euros. Those transactions are made to pay for products sold inside the store, each product got a name and a SKU (stock keeping unit) which is unique.
* Everyday, our customer’s customer walk into their favorite stores to buy products and pay for them using the devices that we provide.

We now want to target customers that will use our devices efficiently and benefit the most of our product. That’s why we need to answer the above questions to know which stores, products and devices are the most efficient and also to know how long it takes for a store to adopt our devices.

In order to solve this problem, we have provided the following three datasets in csv format
* Stores
* Devices
* Transactions

#### ER Diagram
<img width="700" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/65bcb204-74f4-4e41-bdde-62fccd2c984b">



# Implementation Details

#### 1. Python Data Loading
To facilitate the data loading process into Google BigQuery, a custom Python program has been developed. The Python program offers essential functionalities to create tables in BigQuery and load data from CSV files into the respective tables.
The process of data loading involves the following steps:
*	Connection to Google BigQuery: The Python program establishes a connection to the designated Google BigQuery project and dataset.
*	Schema and Table Creation: The program reads the CSV files and dynamically creates the necessary schema and tables in the BigQuery dataset to store the data.
*	Data Upload: The data from the CSV files is uploaded into the corresponding BigQuery tables.
<img width="400" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/10a2da01-1f26-4aa8-8af0-387d81636d10">

#### 2. Data Warehouse Design and Dimensional Modeling

The project starts with three CSV files as the data source. These files contain transactional data, store information, and product details. The data is assumed to be well-structured without any missing values.
To organize and process the data efficiently, the project follows an ideal modeling architecture that consists of three main layers:

* Raw Layer: The raw layer holds the original, unaltered data as received from the data source. It serves as the initial storage before data transformation.

* Stage Layer: In the stage layer, data transformation and cleaning occur. Data from the raw layer is processed, ensuring consistency, data integrity, and standardization. The cleaned data is then ready to be loaded into the core data warehouse.

* Core Layer (Data Warehouse): The core data warehouse layer uses Kimball's dimensional modeling principles. Here, facts and dimensions are created to support effective and optimized querying, reporting, and analytics. The dimensional model enables easy navigation through the data, providing business users with actionable insights.

  Screenshot of the whole dbt project

<img width="1000" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/65869cce-d605-4971-afa0-f2686a48f69d">

Dimensional Modeling (Kimball's Dimensional Modeling Technique)
Kimball's dimensional modeling is a widely accepted and proven technique for designing data warehouses. It is based on the principle of organizing data into two types of tables: fact tables and dimension tables, forming a star schema or snowflake schema. This design optimizes querying and reporting performance while enabling users to easily understand and navigate the data.

* Fact Tables: Fact tables represent business metrics and measurable events, such as transactions. The fact table contains foreign keys to various dimension tables, enabling relationships and joining data efficiently.

* Dimension Tables: Dimension tables contain descriptive attributes related to the business process, such as store information, product details, and country data. These tables are linked to the fact table, forming a star schema. The star schema allows for quick and straightforward querying, making it easier to aggregate data and apply filters.

  Screenshots of the dimension tables from dbt project

<img width="272" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/09bc7396-e580-4837-9c4c-5b06391910b3">
<img width="264" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/145ab60b-679c-4701-81fe-bc7edf0e8cea">

<img width="307" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/f719503c-000e-4286-b348-d9fda5f5d9cc">

I am creating a fact transaction table by joining the stage tables that will answer most of the business questions, it could be used as a data mart for the core layer data consumers.

<img width="316" alt="image" src="https://github.com/anujdixit2610/Anuj_sumup/assets/56278203/cc930997-4701-4d04-a28f-2e89b92e577d">

#### 3. Scalability and Performance
* To address the challenge of handling larger volumes of data, ranging from millions to billions of records, the project utilizes DBT (Data Build Tool) incremental models.

* DBT incremental models are a powerful feature that allows us to optimize data processing by only updating the changed or new data, rather than reprocessing the entire dataset. This approach significantly improves the performance and efficiency of the ELT pipeline, making it suitable for handling substantial data growth.

* By leveraging DBT incremental models, we ensure that the data warehouse design and implementation can scale effortlessly. As new data is ingested into the system, only the incremental changes are processed, reducing the processing time and eliminating the need to reprocess the entire dataset each time.


The python script to load the data and SQL queries to answer the business questions have been included in a separate file within the Git repository.







