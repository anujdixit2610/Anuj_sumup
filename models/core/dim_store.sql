{{ config(
  materialized='view',
  tags=["sumup_pay", "daily"],
) }}

select
   store_id,
   store_name,
   store_address,
   store_city,
   store_country,
   store_created_at,
   store_typology,
   customer_id

from {{ ref('stage_store') }}