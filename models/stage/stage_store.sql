{{ config(
    tags=["sumup_pay"],
    unique_key="id",
    on_schema_change='sync_all_columns'
)}}
with final as (
    SELECT
        id as store_id,
        name as store_name,
        address as store_address,
        city as store_city,
        country as store_country,
        cast(created_at as timestamp) as store_created_at,
        typology as store_typology,
        customer_id as customer_id,
        row_number() over (partition by id order by created_at desc) as rn
    FROM 
        FROM `supple-hangout-394013.dbt_adixit.raw_store`
)
select
   store_id,
   store_name,
   store_address,
   store_city,
   store_country,
   store_created_at,
   store_typology,
   customer_id
from
    base
where
    rn = 1