import csv
import os

from google.cloud import bigquery

STORE_SCHEMA = [
    ("id", "INT64"),
    ("name", "STRING"),
    ("address", "STRING"),
    ("city", "STRING"),
    ("country", "STRING"),
    ("created_at", "STRING"),
    ("typology", "STRING"),
    ("customer_id", "INT64"),
]

DEVICE_SCHEMA = [
   ("id", "INT64"),
   ("type", "INT64"),
   ("store_id", "INT64"),
]

TRANSACTION_SCHEMA = [
    ("id", "INT64"),
    ("device_id", "INT64"),
    ("product_name", "STRING"),
    ("product_sku", "STRING"),
    ("product_name_2", "STRING"),
    ("amount", "FLOAT64"), 
    ("status", "STRING"),
    ("card_number", "STRING"),
    ("cvv", "INT64"),
    ("created_at", "STRING"),
    ("happened_at", "STRING"),
]

table_config = {
    "device": {
        "table_name": "raw_device",
        "schema": DEVICE_SCHEMA,
        "file_name": "device.csv"
    },
    "transaction": {
        "table_name": "raw_transaction",
        "schema": TRANSACTION_SCHEMA,
        "file_name": "transaction.csv"
    },
    "store":{
        "table_name": "raw_store",
        "schema": STORE_SCHEMA,
        "file_name": "store.csv"
    }
}

def create_table_if_not_exists(client, dataset_ref, table_id, schema):
    """Checks if the table exists and creates it if it doesn't.

    Args:
        client: A BigQuery client.
        dataset_ref: A reference to the dataset to create the table in.
        table_id: The ID of the table to create.
        schema: The schema of the table to create.
    """

    table_ref = dataset_ref.table(table_id)

    try:
        client.get_table(table_ref)
    except Exception as exc:
        print(exc)
        table = bigquery.Table(table_ref)
        table.schema = [
           bigquery.SchemaField(key, value)
           for key, value in schema
        ]
        client.create_table(table)


def upload_csv_to_bigquery(client, dataset_ref, table_id, schema, csv_file):
    """Uploads a CSV file to BigQuery using insert_rows_json.

    Args:
        client: A BigQuery client.
        dataset_ref: A reference to the dataset to upload the data to.
        table_id: The ID of the table to upload the data to.
        schema: The schema of the table to upload the data to.
        csv_file: The path to the CSV file.
    """

    table_ref = dataset_ref.table(table_id)
    print(table_ref)

    with open(csv_file, "r", encoding='utf-8-sig') as csvfile:
        data = []
        reader = csv.DictReader(csvfile, delimiter=";")
        for row in reader:
            data.append(row)
    print(data)
    resp = client.insert_rows_json(table_ref, data)
    print(resp)


def main():

    for config, table_data in table_config.items():
        print(config,table_data)
        csv_file = os.path.join(os.path.dirname(__file__), table_data["file_name"])
        dataset_id = "my_dataset_id" # should be coming from env variable
        table_id = table_data["table_name"]
        client = bigquery.Client()
        project = client.project

        dataset_ref = bigquery.DatasetReference(project, dataset_id)

        create_table_if_not_exists(client, dataset_ref, table_id, table_data["schema"])
        upload_csv_to_bigquery(client, dataset_ref, table_id, table_data["schema"], csv_file)


if __name__ == "__main__":
    main()

