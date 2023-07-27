{{ config(
    tags=["sumup_pay"],
    unique_key="id",
    on_schema_change='append_new_columns'
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
    )
select 
    transaction_id
    ,device_id
    ,product_name
    ,product_sku
    ,product_name_2
    ,amount
    ,status
    ,card_number
    ,cvv
    ,transaction_created_at
    ,transaction_happened_at
from 
    final
where
    rn = 1