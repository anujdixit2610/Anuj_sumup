{{ config(
    tags=["sumup_pay", "daily"],
    materialized='incremental',
    unique_key="transaction_id",
    on_schema_change='sync_all_columns'
)}}
with final as 
    (
        SELECT
            id as transaction_id,
            device_id,
            product_name,
            product_sku,
            product_name_2,
            amount,
            status,
            --removing white spaces in the column to avoid any misinterpretations. 
            card_number,
            cvv,
            PARSE_TIMESTAMP('%m.%d.%Y %H:%M:%S', created_at) as transaction_created_at,
            PARSE_TIMESTAMP('%m.%d.%Y %H:%M:%S', happened_at) as transaction_happened_at,
            row_number() over (partition by id order by created_at desc) as rn
        FROM `supple-hangout-394013.dbt_adixit.raw_transaction`

        {% if is_incremental() %}

        -- this filter will only be applied on an incremental run
        where PARSE_TIMESTAMP('%m.%d.%Y %H:%M:%S', created_at) >= (select max(transaction_created_at) from {{ this }})

        {% endif %}
    )
select 
    transaction_id,
    device_id,
    product_name,
    product_sku,
    product_name_2,
    amount,
    status,
    card_number,
    cvv,
    transaction_created_at,
    transaction_happened_at
from 
    final
where
    rn = 1