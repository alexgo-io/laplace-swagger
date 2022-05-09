CREATE MATERIALIZED VIEW laplace.liquidity_details AS
 WITH liquidity_table AS (
         SELECT 'fwp-wstx-alex-50-50-v1-01'::text AS token_name,
            ( SELECT wstx_alex_pool_volume.total_volume
                   FROM laplace.wstx_alex_pool_volume
                  WHERE (wstx_alex_pool_volume.time_range = '24hrs'::text)) AS volume_24h,
            ( SELECT wstx_alex_pool_volume.total_volume
                   FROM laplace.wstx_alex_pool_volume
                  WHERE (wstx_alex_pool_volume.time_range = '7days'::text)) AS volume_7d,
            ((((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-x'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'age000-governance-token'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision) + ((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-y'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'age000-governance-token'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision)) / (2)::double precision) AS item_fees,
            ( SELECT fwp_liquidity.liquidity
                   FROM laplace.fwp_liquidity
                  WHERE (((fwp_liquidity.token_x)::text = 'token-wstx'::text) AND ((fwp_liquidity.token_y)::text = 'age000-governance-token'::text) AND ((fwp_liquidity.contract_name)::text = 'fixed-weight-pool-v1-01'::text))) AS liquidity
        UNION
         SELECT 'fwp-wstx-wbtc-50-50-v1-01'::text AS token_name,
            ( SELECT wstx_wbtc_pool_volume.total_volume
                   FROM laplace.wstx_wbtc_pool_volume
                  WHERE (wstx_wbtc_pool_volume.time_range = '24hrs'::text)) AS volume_24h,
            ( SELECT wstx_wbtc_pool_volume.total_volume
                   FROM laplace.wstx_wbtc_pool_volume
                  WHERE (wstx_wbtc_pool_volume.time_range = '7days'::text)) AS volume_7d,
            ((((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-x'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'token-wbtc'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision) + ((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-y'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'token-wbtc'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision)) / (2)::double precision) AS item_fees,
            ( SELECT fwp_liquidity.liquidity
                   FROM laplace.fwp_liquidity
                  WHERE (((fwp_liquidity.token_x)::text = 'token-wstx'::text) AND ((fwp_liquidity.token_y)::text = 'token-wbtc'::text) AND ((fwp_liquidity.contract_name)::text = 'fixed-weight-pool-v1-01'::text))) AS liquidity
        )
 SELECT liquidity_table.token_name,
    liquidity_table.volume_24h,
    liquidity_table.volume_7d,
    liquidity_table.item_fees,
    liquidity_table.liquidity,
    ((liquidity_table.item_fees / liquidity_table.liquidity) * (52)::double precision) AS apr
   FROM liquidity_table
  WITH NO DATA;
