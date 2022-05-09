DROP MATERIALIZED VIEW IF EXISTS laplace.farming_details;

create materialized view laplace.farming_details as (
  select
    'fwp-wstx-alex-50-50-v1-01' as pool_token,
    (
      select
        liquidity
      from
        laplace.fwp_liquidity
      where
        token_x = 'token-wstx'
        and token_y = 'age000-governance-token'
        and contract_name = 'fixed-weight-pool-v1-01'
    ) as liquidity,
    (
      select
        sum(apr :: double precision) / 32
      from
        (
          select
            apr
          from
            laplace.staking_data
          where
            block_height = (
              select
                max(laplace.staking_data.block_height)
              from
                laplace.staking_data
            )
            and token = 'fwp-wstx-alex-50-50-v1-01'
        ) as aprs
    ) as apr,
    'ALEX' as reward
  union
  select
    'fwp-wstx-wbtc-50-50-v1-01' as pool_token,
    (
      select
        liquidity
      from
        laplace.fwp_liquidity
      where
        token_x = 'token-wstx'
        and token_y = 'token-wbtc'
        and contract_name = 'fixed-weight-pool-v1-01'
    ) as liquidity,
    (
      select
        sum(apr :: double precision) / 32
      from
        (
          select
            apr
          from
            laplace.staking_data
          where
            block_height = (
              select
                max(laplace.staking_data.block_height)
              from
                laplace.staking_data
            )
            and token = 'fwp-wstx-wbtc-50-50-v1-01'
        ) as aprs
    ) as apr,
    'ALEX' as reward
);
