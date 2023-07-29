{{ config(
    tags=["sumup_pay", "daily"],
    materialized='incremental',
    unique_key="device_id",
    on_schema_change='sync_all_columns'
)}}
with final as 
    (
        SELECT  
            id as device_id, 
            type as device_type, 
            store_id,
            row_number() over (partition by id order by id desc) as rn
        FROM `supple-hangout-394013.dbt_adixit.raw_device`
    )
select 
    device_id, 
    device_type, 
    store_id
from 
    final
where 
    rn = 1