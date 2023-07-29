{{ config(
  materialized='view',
  tags=["sumup_pay", "daily"],
) }}

select
    distinct
    product_name,
    product_sku,
    product_name_2

from {{ ref('stage_transaction') }}