DROP MATERIALIZED VIEW if exists "laplace"."liquidity_details";

DROP MATERIALIZED VIEW if exists "laplace"."farming_details";

DROP MATERIALIZED VIEW if exists "laplace"."fwp_liquidity";

CREATE MATERIALIZED VIEW "laplace"."fwp_liquidity" AS
WITH fwp_detail AS (
    SELECT pool_details_fwp.contract_name,
           pool_details_fwp.function_name,
           pool_details_fwp.block_height,
           pool_details_fwp.time_stamp,
           pool_details_fwp.token_x,
           pool_details_fwp.token_y,
           pool_details_fwp.weight_x,
           pool_details_fwp.weight_y,
           pool_details_fwp.pool_token,
           pool_details_fwp.fee_to_address,
           pool_details_fwp.oracle_enabled,
           pool_details_fwp.balance_x,
           pool_details_fwp.balance_y,
           pool_details_fwp.fee_rate_x,
           pool_details_fwp.fee_rate_y,
           pool_details_fwp.fee_rebate,
           pool_details_fwp.oracle_average,
           pool_details_fwp.oracle_resilient,
           pool_details_fwp.total_supply
    FROM laplace.pool_details_fwp
    WHERE (pool_details_fwp.block_height = (SELECT max(pool_details_fwp_1.block_height) AS max
                                            FROM laplace.pool_details_fwp pool_details_fwp_1))
),
     coin_gecko_view AS (
         SELECT coin_gecko.token,
                coin_gecko.avg_price_usd
         FROM laplace.coin_gecko
         UNION ALL
         SELECT 'age000-governance-token'::character varying          AS token,
                ((SELECT coin_gecko.avg_price_usd
                  FROM laplace.coin_gecko
                  WHERE ((coin_gecko.token)::text = 'token-wstx'::text)) /
                 (SELECT ((oracle_instant_fwp.value)::double precision / ('100000000'::numeric)::double precision)
                  FROM laplace.oracle_instant_fwp
                  WHERE (((oracle_instant_fwp.token_x)::text = 'token-wstx'::text) AND
                         ((oracle_instant_fwp.token_y)::text = 'age000-governance-token'::text) AND
                         (oracle_instant_fwp.block_height = (SELECT max(oracle_instant_fwp_1.block_height) AS max
                                                             FROM laplace.oracle_instant_fwp oracle_instant_fwp_1)) and
                         contract_name = 'fixed-weight-pool-v1-01'))) AS avg_price_usd
     )
SELECT fwp_detail.contract_name,
       fwp_detail.token_x,
       fwp_detail.token_y,
       ((fwp_detail.weight_x)::double precision / ('100000000'::numeric)::double precision) AS weight_x,
       ((fwp_detail.weight_y)::double precision / ('100000000'::numeric)::double precision) AS weight_y,
       ((((fwp_detail.balance_x)::double precision * (SELECT coin_gecko_view.avg_price_usd
                                                      FROM coin_gecko_view
                                                      WHERE ((coin_gecko_view.token)::text = (fwp_detail.token_x)::text))) +
         ((fwp_detail.balance_y)::double precision * (SELECT coin_gecko_view.avg_price_usd
                                                      FROM coin_gecko_view
                                                      WHERE ((coin_gecko_view.token)::text = (fwp_detail.token_y)::text)))) /
        ('100000000'::numeric)::double precision)                                           AS liquidity
FROM fwp_detail;

REFRESH MATERIALIZED VIEW laplace.wstx_alex_pool_volume;
REFRESH MATERIALIZED VIEW laplace.wstx_wbtc_pool_volume;

CREATE MATERIALIZED VIEW "laplace"."liquidity_details" AS
WITH liquidity_table AS (
    SELECT 'fwp-wstx-alex-50-50-v1-01' :: text AS token_name,
           (
               SELECT wstx_alex_pool_volume.total_volume
               FROM laplace.wstx_alex_pool_volume
               WHERE (wstx_alex_pool_volume.time_range = '24hrs' :: text)
           )                                   AS volume_24h,
           (
               SELECT wstx_alex_pool_volume.total_volume
               FROM laplace.wstx_alex_pool_volume
               WHERE (wstx_alex_pool_volume.time_range = '7days' :: text)
           )                                   AS volume_7d,
           (
                   (
                           (
                                   (
                                       (
                                           SELECT static_data_fwp.value
                                           FROM laplace.static_data_fwp
                                           WHERE (
                                                         (
                                                             (static_data_fwp.function_name) :: text = 'get-fee-rate-x' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_x) :: text = 'token-wstx' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_y) :: text = 'age000-governance-token' :: text
                                                             )
                                                         AND (
                                                                 (static_data_fwp.contract_name) :: text =
                                                                 'fixed-weight-pool-v1-01' :: text
                                                             )
                                                     )
                                       )
                                   ) :: double precision / (1000000) :: double precision
                               ) + (
                                   (
                                       (
                                           SELECT static_data_fwp.value
                                           FROM laplace.static_data_fwp
                                           WHERE (
                                                         (
                                                             (static_data_fwp.function_name) :: text = 'get-fee-rate-y' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_x) :: text = 'token-wstx' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_y) :: text = 'age000-governance-token' :: text
                                                             )
                                                         AND (
                                                                 (static_data_fwp.contract_name) :: text =
                                                                 'fixed-weight-pool-v1-01' :: text
                                                             )
                                                     )
                                       )
                                   ) :: double precision / (1000000) :: double precision
                               )
                       ) / (2) :: double precision
               )                               AS item_fees,
           (
               SELECT fwp_liquidity.liquidity
               FROM laplace.fwp_liquidity
               WHERE (
                             (
                                 (fwp_liquidity.token_x) :: text = 'token-wstx' :: text
                                 )
                             AND (
                                 (fwp_liquidity.token_y) :: text = 'age000-governance-token' :: text
                                 )
                             AND (
                                 (fwp_liquidity.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                                 )
                         )
           )                                   AS liquidity
    UNION
    SELECT 'fwp-wstx-wbtc-50-50-v1-01' :: text AS token_name,
           (
               SELECT wstx_wbtc_pool_volume.total_volume
               FROM laplace.wstx_wbtc_pool_volume
               WHERE (wstx_wbtc_pool_volume.time_range = '24hrs' :: text)
           )                                   AS volume_24h,
           (
               SELECT wstx_wbtc_pool_volume.total_volume
               FROM laplace.wstx_wbtc_pool_volume
               WHERE (wstx_wbtc_pool_volume.time_range = '7days' :: text)
           )                                   AS volume_7d,
           (
                   (
                           (
                                   (
                                       (
                                           SELECT static_data_fwp.value
                                           FROM laplace.static_data_fwp
                                           WHERE (
                                                         (
                                                             (static_data_fwp.function_name) :: text = 'get-fee-rate-x' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_x) :: text = 'token-wstx' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_y) :: text = 'token-wbtc' :: text
                                                             )
                                                         AND (
                                                                 (static_data_fwp.contract_name) :: text =
                                                                 'fixed-weight-pool-v1-01' :: text
                                                             )
                                                     )
                                       )
                                   ) :: double precision / (1000000) :: double precision
                               ) + (
                                   (
                                       (
                                           SELECT static_data_fwp.value
                                           FROM laplace.static_data_fwp
                                           WHERE (
                                                         (
                                                             (static_data_fwp.function_name) :: text = 'get-fee-rate-y' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_x) :: text = 'token-wstx' :: text
                                                             )
                                                         AND (
                                                             (static_data_fwp.token_y) :: text = 'token-wbtc' :: text
                                                             )
                                                         AND (
                                                                 (static_data_fwp.contract_name) :: text =
                                                                 'fixed-weight-pool-v1-01' :: text
                                                             )
                                                     )
                                       )
                                   ) :: double precision / (1000000) :: double precision
                               )
                       ) / (2) :: double precision
               )                               AS item_fees,
           (
               SELECT fwp_liquidity.liquidity
               FROM laplace.fwp_liquidity
               WHERE (
                             (
                                 (fwp_liquidity.token_x) :: text = 'token-wstx' :: text
                                 )
                             AND (
                                 (fwp_liquidity.token_y) :: text = 'token-wbtc' :: text
                                 )
                             AND (
                                 (fwp_liquidity.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                                 )
                         )
           )                                   AS liquidity
)
SELECT liquidity_table.token_name,
       liquidity_table.volume_24h,
       liquidity_table.volume_7d,
       liquidity_table.item_fees,
       liquidity_table.liquidity,
       (
               (
                   liquidity_table.item_fees / liquidity_table.liquidity
                   ) * (52) :: double precision
           ) AS apr
FROM liquidity_table;

CREATE MATERIALIZED VIEW "laplace"."farming_details" AS
SELECT 'fwp-wstx-alex-50-50-v1-01' :: text AS pool_token,
       (
           SELECT fwp_liquidity.liquidity
           FROM laplace.fwp_liquidity
           WHERE (
                         (
                             (fwp_liquidity.token_x) :: text = 'token-wstx' :: text
                             )
                         AND (
                             (fwp_liquidity.token_y) :: text = 'age000-governance-token' :: text
                             )
                         AND (
                             (fwp_liquidity.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                             )
                     )
       )                                   AS liquidity,
       (
           SELECT (
                      sum((aprs.apr) :: double precision) / (32) :: double precision
                      )
           FROM (
                    SELECT staking_data.apr
                    FROM laplace.staking_data
                    WHERE (
                                  staking_data.block_height = (
                                  SELECT max(staking_data_1.block_height) AS max
                                  FROM laplace.staking_data staking_data_1
                              )
                              )
                ) aprs
       )                                   AS apr,
       'ALEX' :: text                      AS reward
UNION
SELECT 'fwp-wstx-wbtc-50-50-v1-01' :: text AS pool_token,
       (
           SELECT fwp_liquidity.liquidity
           FROM laplace.fwp_liquidity
           WHERE (
                         (
                             (fwp_liquidity.token_x) :: text = 'token-wstx' :: text
                             )
                         AND (
                             (fwp_liquidity.token_y) :: text = 'token-wbtc' :: text
                             )
                         AND (
                             (fwp_liquidity.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                             )
                     )
       )                                   AS liquidity,
       (
           SELECT (
                      sum((aprs.apr) :: double precision) / (32) :: double precision
                      )
           FROM (
                    SELECT staking_data.apr
                    FROM laplace.staking_data
                    WHERE (
                                  staking_data.block_height = (
                                  SELECT max(staking_data_1.block_height) AS max
                                  FROM laplace.staking_data staking_data_1
                              )
                              )
                ) aprs
       )                                   AS apr,
       'ALEX' :: text                      AS reward;
