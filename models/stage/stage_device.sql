{{ config(
    tags=["sumup_pay"],
    unique_key="id",
    on_schema_change='append_new_columns'
)}}
with final as 
    (
        SELECT  
            id as device_id, 
            type as device_type, 
            store_id
        FROM `supple-hangout-394013.dbt_adixit.raw_device`
    )
select 
    device_id, 
    device_type, 
    store_id
from 
    final
where 
    qualify row_number() over (partition by id order by id desc) = 1