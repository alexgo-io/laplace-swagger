DROP MATERIALIZED VIEW  IF EXISTS laplace.wstx_alex_pool_volume CASCADE;

create materialized view laplace.wstx_alex_pool_volume as

with stx_in_alex_out_txs as (
  select
    t.sender_address,
    encode(t.tx_id, 'hex') as tx_id,
    (t.function_args -> 'args' -> 4 ->> 'value') :: float / 100000000 as input_amount,
    case
      when (t.transaction_result -> 'value' ->> 'type') :: text = 'UInt' then (t.transaction_result -> 'value' ->> 'value') :: float / 100000000
      when (t.transaction_result -> 'value' ->> 'type') :: text = 'Tuple' then (
        t.transaction_result -> 'value' -> 'value' -> 'dy' ->> 'value'
      ) :: float / 100000000
      else 0
    end as output_amount,
    t.transaction_result,
    t.id,
    to_timestamp(t.burn_block_time) :: timestamp with time zone at time zone 'CCT' as burn_block_time,
    t.block_height
  from
    public_transform.txs_view t
  where
    (t.transaction_result ->> 'type') :: text = 'ResponseOk'
    and t.contract_call_contract_id = (select full_name from laplace.config_contracts where contract = 'fixed-weight-pool-v1-01')
    and (
      (
        t.contract_call_function_name = 'swap-helper' -- alex-wstx swapping
        and (t.function_args -> 'args' -> 1 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'age000-governance-token')
        and (t.function_args -> 'args' -> 0 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'token-wstx')
      )
      or (
        t.contract_call_function_name = 'swap-x-for-y' -- this is only for wstx-wbtc exchange but keep it for maintenance
        and (t.function_args -> 'args' -> 1 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'age000-governance-token')
        and (t.function_args -> 'args' -> 0 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'token-wstx')
      )
    )
    and t.canonical = true
    and t.microblock_canonical = true
    and t.status = 1
),
stx_out_alex_in_txs as (
  select
    t.sender_address,
    encode(t.tx_id, 'hex') as tx_id,
    (t.function_args -> 'args' -> 4 ->> 'value') :: float / 100000000 as input_amount,
    case
      when (t.transaction_result -> 'value' ->> 'type') :: text = 'UInt' then (t.transaction_result -> 'value' ->> 'value') :: float / 100000000
      when (t.transaction_result -> 'value' ->> 'type') :: text = 'Tuple' then (
        t.transaction_result -> 'value' -> 'value' -> 'dy' ->> 'value'
      ) :: float / 100000000
      else 0
    end as output_amount,
    t.transaction_result,
    t.id,
    to_timestamp(t.burn_block_time) :: timestamp with time zone at time zone 'CCT' as burn_block_time,
    t.block_height
  from
    public_transform.txs_view t
  where
    (t.transaction_result ->> 'type') :: text = 'ResponseOk'
    and t.contract_call_contract_id = (select full_name from laplace.config_contracts where contract = 'fixed-weight-pool-v1-01')
    and (
      (
        t.contract_call_function_name = 'swap-helper'
        and (t.function_args -> 'args' -> 1 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'token-wstx')
        and (t.function_args -> 'args' -> 0 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'age000-governance-token')
      )
      or (
        t.contract_call_function_name = 'swap-y-for-x'
        and (t.function_args -> 'args' -> 1 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'token-wstx')
        and (t.function_args -> 'args' -> 0 ->> 'value') :: text = (select full_name from laplace.config_contracts where contract = 'age000-governance-token')
      )
    )
    and t.canonical = true
    and t.microblock_canonical = true
    and t.status = 1
)
select
  'wstx-alex-pool' as pool_name,
  time_range,
  sum(wstx_volume) as wstx_volume,
  sum(alex_volume) as alex_volume,
  sum(wstx_volume + alex_volume) as total_volume
from
  (
    (
      (
        select
          sum(
            stx_in_alex_out_txs.input_amount * (
              select
                avg_price_usd
              from
                laplace.coin_gecko
              where
                token = 'token-wstx'
            )
          ) as wstx_volume,
          sum(
            stx_in_alex_out_txs.output_amount * (
              select
                avg_price_usd
              from
                laplace.alex_usd_pricing
              where
                token = 'age000-governance-token'
            )
          ) as alex_volume,
          '24hrs' as time_range
        from
          stx_in_alex_out_txs
        where
          stx_in_alex_out_txs.burn_block_time > (select max(burn_block_time) from stx_in_alex_out_txs) - INTERVAL '24 hours'
      )
      union
      (
        select
          sum(
            stx_in_alex_out_txs.input_amount * (
              select
                avg_price_usd
              from
                laplace.coin_gecko
              where
                token = 'token-wstx'
            )
          ) as wstx_volume,
          sum(
            stx_in_alex_out_txs.output_amount * (
              select
                avg_price_usd
              from
                laplace.alex_usd_pricing
              where
                token = 'age000-governance-token'
            )
          ) as alex_volume,
          '7days' as time_range
        from
          stx_in_alex_out_txs
        where
          stx_in_alex_out_txs.burn_block_time >  (select max(burn_block_time) from stx_in_alex_out_txs) - INTERVAL '7 days'
      )
    )
    union
    all (
      (
        select
          sum(
            stx_out_alex_in_txs.output_amount * (
              select
                avg_price_usd
              from
                laplace.coin_gecko
              where
                token = 'token-wstx'
            )
          ) as wstx_volume,
          sum(
            stx_out_alex_in_txs.input_amount * (
              select
                avg_price_usd
              from
                laplace.alex_usd_pricing
              where
                token = 'age000-governance-token'
            )
          ) as alex_volume,
          '24hrs' as time_range
        from
          stx_out_alex_in_txs
        where
          stx_out_alex_in_txs.burn_block_time >  (select max(burn_block_time) from stx_in_alex_out_txs) - INTERVAL '24 hours'
      )
      union
      (
        select
          sum(
            stx_out_alex_in_txs.output_amount * (
              select
                avg_price_usd
              from
                laplace.coin_gecko
              where
                token = 'token-wstx'
            )
          ) as wstx_volume,
          sum(
            stx_out_alex_in_txs.input_amount * (
              select
                avg_price_usd
              from
                laplace.alex_usd_pricing
              where
                token = 'age000-governance-token'
            )
          ) as alex_volume,
          '7days' as time_range
        from
          stx_out_alex_in_txs
        where
          stx_out_alex_in_txs.burn_block_time > (select max(burn_block_time) from stx_in_alex_out_txs) - INTERVAL '7days'
      )
    )
  ) as volume
group by
  time_range;
