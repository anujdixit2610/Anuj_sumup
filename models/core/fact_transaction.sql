{{ config(
  materialized='table',
  tags=["sumup_pay", "daily"],
) }}

select 
    trx.transaction_id,
    trx.device_id,
    device.device_type,
    trx.product_name,
    trx.product_sku,
    trx.amount,
    trx.status,
    trx.transaction_happened_at,
    store.store_id,
    store.store_name,
    store.store_typology,
    store.store_country

from 
    {{ ref('stage_transaction') }} trx
    left join  {{ ref('stage_device') }} device ON trx.device_id = device.device_id
    left join  {{ ref('stage_store') }} store ON device.store_id = store.store_id