{{ config(
    tags=["sumup_pay", "daily"],
    materialized='incremental',
    unique_key="store_id",
    on_schema_change='sync_all_columns'
)}}
with final as (
    SELECT
        id as store_id,
        name as store_name,
        address as store_address,
        city as store_city,
        country as store_country,
        PARSE_TIMESTAMP('%m.%d.%Y %H:%M:%S', created_at) as store_created_at,
        typology as store_typology,
        customer_id as customer_id,
        row_number() over (partition by id order by created_at desc) as rn
    FROM `supple-hangout-394013.dbt_adixit.raw_store`

    {% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    where PARSE_TIMESTAMP('%m.%d.%Y %H:%M:%S', created_at) >= (select max(store_created_at) from {{ this }})

    {% endif %}
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
    final
where
    rn = 1