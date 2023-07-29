{{ config(
  materialized='view',
  tags=["sumup_pay", "daily"],
) }}

select 
    device_id, 
    device_type, 
    store_id

from {{ ref('stage_device') }}