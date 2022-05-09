DROP MATERIALIZED VIEW "laplace"."fwp_liquidity";
CREATE MATERIALIZED VIEW "laplace"."fwp_liquidity" AS WITH fwp_detail AS (
  SELECT
    pool_details_fwp.contract_name,
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
  FROM
    laplace.pool_details_fwp
  WHERE
    (
      pool_details_fwp.block_height = (
        SELECT
          max(pool_details_fwp_1.block_height) AS max
        FROM
          laplace.pool_details_fwp pool_details_fwp_1
      )
    )
),
coin_gecko_view AS (
  SELECT
    coin_gecko.token,
    coin_gecko.avg_price_usd
  FROM
    laplace.coin_gecko
  UNION ALL
  SELECT
    'age000-governance-token' :: character varying AS token,
    (
      (
        SELECT
          coin_gecko.avg_price_usd
        FROM
          laplace.coin_gecko
        WHERE
          ((coin_gecko.token) :: text = 'token-wstx' :: text)
      ) / (
        SELECT
          (
            (oracle_instant_fwp.value) :: double precision / ('100000000' :: numeric) :: double precision
          )
        FROM
          laplace.oracle_instant_fwp
        WHERE
          (
            (
              (oracle_instant_fwp.token_x) :: text = 'token-wstx' :: text
            )
            AND (
              (oracle_instant_fwp.token_y) :: text = 'age000-governance-token' :: text
            )
            AND (
              oracle_instant_fwp.block_height = (
                SELECT
                  max(oracle_instant_fwp_1.block_height) AS max
                FROM
                  laplace.oracle_instant_fwp oracle_instant_fwp_1
              )
            )
            AND (
              (oracle_instant_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
            )
          )
      )
    ) AS avg_price_usd
)
SELECT
  fwp_detail.contract_name,
  fwp_detail.token_x,
  fwp_detail.token_y,
  (
    (fwp_detail.weight_x) :: double precision / ('100000000' :: numeric) :: double precision
  ) AS weight_x,
  (
    (fwp_detail.weight_y) :: double precision / ('100000000' :: numeric) :: double precision
  ) AS weight_y,
  (
    (
      (
        (fwp_detail.balance_x) :: double precision * (
          SELECT
            coin_gecko_view.avg_price_usd
          FROM
            coin_gecko_view
          WHERE
            (
              (coin_gecko_view.token) :: text = (fwp_detail.token_x) :: text
            )
        )
      ) + (
        (fwp_detail.balance_y) :: double precision * (
          SELECT
            coin_gecko_view.avg_price_usd
          FROM
            coin_gecko_view
          WHERE
            (
              (coin_gecko_view.token) :: text = (fwp_detail.token_y) :: text
            )
        )
      )
    ) / ('100000000' :: numeric) :: double precision
  ) AS liquidity
FROM
  fwp_detail;

DROP MATERIALIZED VIEW "laplace"."farming_details";
CREATE MATERIALIZED VIEW "laplace"."farming_details" AS
SELECT
  'fwp-wstx-alex-50-50-v1-01' :: text AS pool_token,
  (
    SELECT
      fwp_liquidity.liquidity
    FROM
      laplace.fwp_liquidity
    WHERE
      (
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
  ) AS liquidity,
  (
    SELECT
      (
        sum((aprs.apr) :: double precision) / (32) :: double precision
      )
    FROM
      (
        SELECT
          staking_data.apr
        FROM
          laplace.staking_data
        WHERE
          (
            (
              staking_data.block_height = (
                SELECT
                  max(staking_data_1.block_height) AS max
                FROM
                  laplace.staking_data staking_data_1
              )
            )
            AND (
              (staking_data.token) :: text = 'fwp-wstx-alex-50-50-v1-01' :: text
            )
          )
      ) aprs
  ) AS apr,
  'ALEX' :: text AS reward
UNION
SELECT
  'fwp-wstx-wbtc-50-50-v1-01' :: text AS pool_token,
  (
    SELECT
      fwp_liquidity.liquidity
    FROM
      laplace.fwp_liquidity
    WHERE
      (
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
  ) AS liquidity,
  (
    SELECT
      (
        sum((aprs.apr) :: double precision) / (32) :: double precision
      )
    FROM
      (
        SELECT
          staking_data.apr
        FROM
          laplace.staking_data
        WHERE
          (
            (
              staking_data.block_height = (
                SELECT
                  max(staking_data_1.block_height) AS max
                FROM
                  laplace.staking_data staking_data_1
              )
            )
            AND (
              (staking_data.token) :: text = 'fwp-wstx-wbtc-50-50-v1-01' :: text
            )
          )
      ) aprs
  ) AS apr,
  'ALEX' :: text AS reward
UNION
SELECT
  'fwp-alex-wban' :: text AS pool_token,
  (
    SELECT
      pool_liquidity.liquidity
    FROM
      laplace.pool_liquidity
    WHERE
      (
        (pool_liquidity.token_name) :: text = 'fwp-alex-wban' :: text
      )
  ) AS liquidity,
  (
    SELECT
      (
        sum((aprs.apr) :: double precision) / (32) :: double precision
      )
    FROM
      (
        SELECT
          staking_data.apr
        FROM
          laplace.staking_data
        WHERE
          (
            (
              staking_data.block_height = (
                SELECT
                  max(staking_data_1.block_height) AS max
                FROM
                  laplace.staking_data staking_data_1
              )
            )
            AND (
              (staking_data.token) :: text = 'fwp-alex-wban' :: text
            )
          )
      ) aprs
  ) AS apr,
  'ALEX' :: text AS reward;

DROP MATERIALIZED VIEW "laplace"."liquidity_details";
CREATE MATERIALIZED VIEW "laplace"."liquidity_details" AS WITH liquidity_table AS (
  SELECT
    'fwp-wstx-alex-50-50-v1-01' :: text AS token_name,
    (
      SELECT
        wstx_alex_pool_volume.total_volume
      FROM
        laplace.wstx_alex_pool_volume
      WHERE
        (wstx_alex_pool_volume.time_range = '24hrs' :: text)
    ) AS volume_24h,
    (
      SELECT
        wstx_alex_pool_volume.total_volume
      FROM
        laplace.wstx_alex_pool_volume
      WHERE
        (wstx_alex_pool_volume.time_range = '7days' :: text)
    ) AS volume_7d,
    (
      (
        (
          (
            (
              SELECT
                wstx_alex_pool_volume.wstx_volume
              FROM
                laplace.wstx_alex_pool_volume
              WHERE
                (wstx_alex_pool_volume.time_range = '7days' :: text)
            ) * (
              SELECT
                (static_data_fwp.value) :: double precision AS value
              FROM
                laplace.static_data_fwp
              WHERE
                (
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
                    (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                  )
                )
            )
          ) / (100000000) :: double precision
        ) + (
          (
            SELECT
              wstx_alex_pool_volume.alex_volume
            FROM
              laplace.wstx_alex_pool_volume
            WHERE
              (wstx_alex_pool_volume.time_range = '7days' :: text)
          ) * (
            (
              SELECT
                (static_data_fwp.value) :: double precision AS value
              FROM
                laplace.static_data_fwp
              WHERE
                (
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
                    (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                  )
                )
            ) / (100000000) :: double precision
          )
        )
      ) / (2) :: double precision
    ) AS item_fees,
    (
      SELECT
        fwp_liquidity.liquidity
      FROM
        laplace.fwp_liquidity
      WHERE
        (
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
    ) AS liquidity
  UNION
  SELECT
    'fwp-wstx-wbtc-50-50-v1-01' :: text AS token_name,
    (
      SELECT
        wstx_wbtc_pool_volume.total_volume
      FROM
        laplace.wstx_wbtc_pool_volume
      WHERE
        (wstx_wbtc_pool_volume.time_range = '24hrs' :: text)
    ) AS volume_24h,
    (
      SELECT
        wstx_wbtc_pool_volume.total_volume
      FROM
        laplace.wstx_wbtc_pool_volume
      WHERE
        (wstx_wbtc_pool_volume.time_range = '7days' :: text)
    ) AS volume_7d,
    (
      (
        (
          (
            (
              SELECT
                wstx_wbtc_pool_volume.wstx_volume
              FROM
                laplace.wstx_wbtc_pool_volume
              WHERE
                (wstx_wbtc_pool_volume.time_range = '7days' :: text)
            ) * (
              SELECT
                (static_data_fwp.value) :: double precision AS value
              FROM
                laplace.static_data_fwp
              WHERE
                (
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
                    (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                  )
                )
            )
          ) / (100000000) :: double precision
        ) + (
          (
            (
              SELECT
                wstx_wbtc_pool_volume.alex_volume
              FROM
                laplace.wstx_wbtc_pool_volume
              WHERE
                (wstx_wbtc_pool_volume.time_range = '7days' :: text)
            ) * (
              SELECT
                (static_data_fwp.value) :: double precision AS value
              FROM
                laplace.static_data_fwp
              WHERE
                (
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
                    (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
                  )
                )
            )
          ) / (100000000) :: double precision
        )
      ) / (2) :: double precision
    ) AS item_fees,
    (
      SELECT
        fwp_liquidity.liquidity
      FROM
        laplace.fwp_liquidity
      WHERE
        (
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
    ) AS liquidity
)
SELECT
  liquidity_table.token_name,
  liquidity_table.volume_24h,
  liquidity_table.volume_7d,
  liquidity_table.item_fees,
  liquidity_table.liquidity,
  (
    (
      liquidity_table.item_fees / liquidity_table.liquidity
    ) * (52) :: double precision
  ) AS apr
FROM
  liquidity_table;

CREATE
OR REPLACE VIEW "laplace"."liquidity_provider_fee" AS
SELECT
  'age000-governance-token' :: text AS token_to,
  'token-wbtc' :: text AS token_from,
  (
    SELECT
      (oracle_resilient_fwp.value) :: numeric AS value
    FROM
      laplace.oracle_resilient_fwp
    WHERE
      (
        (
          (oracle_resilient_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (oracle_resilient_fwp.token_y) :: text = 'age000-governance-token' :: text
        )
        AND (
          (oracle_resilient_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          oracle_resilient_fwp.block_height = (
            SELECT
              max(oracle_resilient_fwp_1.block_height) AS max
            FROM
              laplace.oracle_resilient_fwp oracle_resilient_fwp_1
          )
        )
      )
  ) AS wstx_to,
  (
    SELECT
      (oracle_resilient_fwp.value) :: numeric AS value
    FROM
      laplace.oracle_resilient_fwp
    WHERE
      (
        (
          (oracle_resilient_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (oracle_resilient_fwp.token_y) :: text = 'token-wbtc' :: text
        )
        AND (
          (oracle_resilient_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          oracle_resilient_fwp.block_height = (
            SELECT
              max(oracle_resilient_fwp_1.block_height) AS max
            FROM
              laplace.oracle_resilient_fwp oracle_resilient_fwp_1
          )
        )
      )
  ) AS wstx_from,
  (
    SELECT
      (static_data_fwp.value) :: numeric AS value
    FROM
      laplace.static_data_fwp
    WHERE
      (
        (
          (static_data_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (static_data_fwp.token_y) :: text = 'age000-governance-token' :: text
        )
        AND (
          (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          (static_data_fwp.function_name) :: text = 'get-fee-rate-x' :: text
        )
      )
  ) AS fee_details_to,
  (
    SELECT
      (static_data_fwp.value) :: numeric AS value
    FROM
      laplace.static_data_fwp
    WHERE
      (
        (
          (static_data_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (static_data_fwp.token_y) :: text = 'token-wbtc' :: text
        )
        AND (
          (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          (static_data_fwp.function_name) :: text = 'get-fee-rate-y' :: text
        )
      )
  ) AS fee_details_from
UNION
SELECT
  'token-wbtc' :: text AS token_to,
  'age000-governance-token' :: text AS token_from,
  (
    SELECT
      (oracle_resilient_fwp.value) :: numeric AS value
    FROM
      laplace.oracle_resilient_fwp
    WHERE
      (
        (
          (oracle_resilient_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (oracle_resilient_fwp.token_y) :: text = 'token-wbtc' :: text
        )
        AND (
          (oracle_resilient_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          oracle_resilient_fwp.block_height = (
            SELECT
              max(oracle_resilient_fwp_1.block_height) AS max
            FROM
              laplace.oracle_resilient_fwp oracle_resilient_fwp_1
          )
        )
      )
  ) AS wstx_to,
  (
    SELECT
      (oracle_resilient_fwp.value) :: numeric AS value
    FROM
      laplace.oracle_resilient_fwp
    WHERE
      (
        (
          (oracle_resilient_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (oracle_resilient_fwp.token_y) :: text = 'age000-governance-token' :: text
        )
        AND (
          (oracle_resilient_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          oracle_resilient_fwp.block_height = (
            SELECT
              max(oracle_resilient_fwp_1.block_height) AS max
            FROM
              laplace.oracle_resilient_fwp oracle_resilient_fwp_1
          )
        )
      )
  ) AS wstx_from,
  (
    SELECT
      (static_data_fwp.value) :: numeric AS value
    FROM
      laplace.static_data_fwp
    WHERE
      (
        (
          (static_data_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (static_data_fwp.token_y) :: text = 'token-wbtc' :: text
        )
        AND (
          (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          (static_data_fwp.function_name) :: text = 'get-fee-rate-y' :: text
        )
      )
  ) AS fee_details_to,
  (
    SELECT
      (static_data_fwp.value) :: numeric AS value
    FROM
      laplace.static_data_fwp
    WHERE
      (
        (
          (static_data_fwp.token_x) :: text = 'token-wstx' :: text
        )
        AND (
          (static_data_fwp.token_y) :: text = 'age000-governance-token' :: text
        )
        AND (
          (static_data_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
        )
        AND (
          (static_data_fwp.function_name) :: text = 'get-fee-rate-x' :: text
        )
      )
  ) AS fee_details_from;

DROP MATERIALIZED VIEW "laplace"."wstx_alex_pool_volume";
CREATE MATERIALIZED VIEW "laplace"."wstx_alex_pool_volume" AS WITH stx_in_alex_out_txs AS (
  SELECT
    t.sender_address,
    encode(t.tx_id, 'hex' :: text) AS tx_id,
    (
      (
        (
          ((t.function_args -> 'args' :: text) -> 4) ->> 'value' :: text
        )
      ) :: double precision / (100000000) :: double precision
    ) AS input_amount,
    CASE
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'UInt' :: text
      ) THEN (
        (
          (
            (t.transaction_result -> 'value' :: text) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'Tuple' :: text
      ) THEN (
        (
          (
            (
              (
                (t.transaction_result -> 'value' :: text) -> 'value' :: text
              ) -> 'dy' :: text
            ) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      ELSE (0) :: double precision
    END AS output_amount,
    t.transaction_result,
    t.id,
    (
      to_timestamp((t.burn_block_time) :: double precision) AT TIME ZONE 'CCT' :: text
    ) AS burn_block_time,
    t.block_height
  FROM
    public_transform.txs_view t
  WHERE
    (
      (
        (t.transaction_result ->> 'type' :: text) = 'ResponseOk' :: text
      )
      AND (
        t.contract_call_contract_id = (
          (
            SELECT
              config_contracts.full_name
            FROM
              laplace.config_contracts
            WHERE
              (
                (config_contracts.contract) :: text = 'fixed-weight-pool-v1-01' :: text
              )
          )
        ) :: text
      )
      AND (
        (
          (
            t.contract_call_function_name = 'swap-helper' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'age000-governance-token' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
        )
        OR (
          (
            t.contract_call_function_name = 'swap-x-for-y' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'age000-governance-token' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
        )
      )
      AND (t.canonical = true)
      AND (t.microblock_canonical = true)
      AND (t.status = 1)
    )
),
stx_out_alex_in_txs AS (
  SELECT
    t.sender_address,
    encode(t.tx_id, 'hex' :: text) AS tx_id,
    (
      (
        (
          ((t.function_args -> 'args' :: text) -> 4) ->> 'value' :: text
        )
      ) :: double precision / (100000000) :: double precision
    ) AS input_amount,
    CASE
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'UInt' :: text
      ) THEN (
        (
          (
            (t.transaction_result -> 'value' :: text) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'Tuple' :: text
      ) THEN (
        (
          (
            (
              (
                (t.transaction_result -> 'value' :: text) -> 'value' :: text
              ) -> 'dy' :: text
            ) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      ELSE (0) :: double precision
    END AS output_amount,
    t.transaction_result,
    t.id,
    (
      to_timestamp((t.burn_block_time) :: double precision) AT TIME ZONE 'CCT' :: text
    ) AS burn_block_time,
    t.block_height
  FROM
    public_transform.txs_view t
  WHERE
    (
      (
        (t.transaction_result ->> 'type' :: text) = 'ResponseOk' :: text
      )
      AND (
        t.contract_call_contract_id = (
          (
            SELECT
              config_contracts.full_name
            FROM
              laplace.config_contracts
            WHERE
              (
                (config_contracts.contract) :: text = 'fixed-weight-pool-v1-01' :: text
              )
          )
        ) :: text
      )
      AND (
        (
          (
            t.contract_call_function_name = 'swap-helper' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'age000-governance-token' :: text
                  )
              )
            ) :: text
          )
        )
        OR (
          (
            t.contract_call_function_name = 'swap-y-for-x' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'age000-governance-token' :: text
                  )
              )
            ) :: text
          )
        )
      )
      AND (t.canonical = true)
      AND (t.microblock_canonical = true)
      AND (t.status = 1)
    )
)
SELECT
  'wstx-alex-pool' :: text AS pool_name,
  volume.time_range,
  sum(volume.wstx_volume) AS wstx_volume,
  sum(volume.alex_volume) AS alex_volume,
  sum((volume.wstx_volume + volume.alex_volume)) AS total_volume
FROM
  (
    (
      SELECT
        sum(
          (
            stx_in_alex_out_txs.input_amount * (
              SELECT
                coin_gecko.avg_price_usd
              FROM
                laplace.coin_gecko
              WHERE
                ((coin_gecko.token) :: text = 'token-wstx' :: text)
            )
          )
        ) AS wstx_volume,
        sum(
          (
            stx_in_alex_out_txs.output_amount * (
              SELECT
                alex_usd_pricing.avg_price_usd
              FROM
                laplace.alex_usd_pricing
              WHERE
                (
                  alex_usd_pricing.token = 'age000-governance-token' :: text
                )
            )
          )
        ) AS alex_volume,
        '24hrs' :: text AS time_range
      FROM
        stx_in_alex_out_txs
      WHERE
        (
          stx_in_alex_out_txs.burn_block_time > (
            (
              SELECT
                max(stx_in_alex_out_txs_1.burn_block_time) AS max
              FROM
                stx_in_alex_out_txs stx_in_alex_out_txs_1
            ) - '24:00:00' :: interval
          )
        )
      UNION
      SELECT
        sum(
          (
            stx_in_alex_out_txs.input_amount * (
              SELECT
                coin_gecko.avg_price_usd
              FROM
                laplace.coin_gecko
              WHERE
                ((coin_gecko.token) :: text = 'token-wstx' :: text)
            )
          )
        ) AS wstx_volume,
        sum(
          (
            stx_in_alex_out_txs.output_amount * (
              SELECT
                alex_usd_pricing.avg_price_usd
              FROM
                laplace.alex_usd_pricing
              WHERE
                (
                  alex_usd_pricing.token = 'age000-governance-token' :: text
                )
            )
          )
        ) AS alex_volume,
        '7days' :: text AS time_range
      FROM
        stx_in_alex_out_txs
      WHERE
        (
          stx_in_alex_out_txs.burn_block_time > (
            (
              SELECT
                max(stx_in_alex_out_txs_1.burn_block_time) AS max
              FROM
                stx_in_alex_out_txs stx_in_alex_out_txs_1
            ) - '7 days' :: interval
          )
        )
    )
    UNION ALL
      (
        SELECT
          sum(
            (
              stx_out_alex_in_txs.output_amount * (
                SELECT
                  coin_gecko.avg_price_usd
                FROM
                  laplace.coin_gecko
                WHERE
                  ((coin_gecko.token) :: text = 'token-wstx' :: text)
              )
            )
          ) AS wstx_volume,
          sum(
            (
              stx_out_alex_in_txs.input_amount * (
                SELECT
                  alex_usd_pricing.avg_price_usd
                FROM
                  laplace.alex_usd_pricing
                WHERE
                  (
                    alex_usd_pricing.token = 'age000-governance-token' :: text
                  )
              )
            )
          ) AS alex_volume,
          '24hrs' :: text AS time_range
        FROM
          stx_out_alex_in_txs
        WHERE
          (
            stx_out_alex_in_txs.burn_block_time > (
              (
                SELECT
                  max(stx_in_alex_out_txs.burn_block_time) AS max
                FROM
                  stx_in_alex_out_txs
              ) - '24:00:00' :: interval
            )
          )
        UNION
        SELECT
          sum(
            (
              stx_out_alex_in_txs.output_amount * (
                SELECT
                  coin_gecko.avg_price_usd
                FROM
                  laplace.coin_gecko
                WHERE
                  ((coin_gecko.token) :: text = 'token-wstx' :: text)
              )
            )
          ) AS wstx_volume,
          sum(
            (
              stx_out_alex_in_txs.input_amount * (
                SELECT
                  alex_usd_pricing.avg_price_usd
                FROM
                  laplace.alex_usd_pricing
                WHERE
                  (
                    alex_usd_pricing.token = 'age000-governance-token' :: text
                  )
              )
            )
          ) AS alex_volume,
          '7days' :: text AS time_range
        FROM
          stx_out_alex_in_txs
        WHERE
          (
            stx_out_alex_in_txs.burn_block_time > (
              (
                SELECT
                  max(stx_in_alex_out_txs.burn_block_time) AS max
                FROM
                  stx_in_alex_out_txs
              ) - '7 days' :: interval
            )
          )
      )
  ) volume
GROUP BY
  volume.time_range;
DROP MATERIALIZED VIEW "laplace"."wstx_wbtc_pool_volume";
CREATE MATERIALIZED VIEW "laplace"."wstx_wbtc_pool_volume" AS WITH stx_in_btc_out_txs AS (
  SELECT
    t.sender_address,
    encode(t.tx_id, 'hex' :: text) AS tx_id,
    (
      (
        (
          ((t.function_args -> 'args' :: text) -> 4) ->> 'value' :: text
        )
      ) :: double precision / (100000000) :: double precision
    ) AS input_amount,
    CASE
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'UInt' :: text
      ) THEN (
        (
          (
            (t.transaction_result -> 'value' :: text) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'Tuple' :: text
      ) THEN (
        (
          (
            (
              (
                (t.transaction_result -> 'value' :: text) -> 'value' :: text
              ) -> 'dy' :: text
            ) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      ELSE (0) :: double precision
    END AS output_amount,
    t.transaction_result,
    t.id,
    (
      to_timestamp((t.burn_block_time) :: double precision) AT TIME ZONE 'CCT' :: text
    ) AS burn_block_time,
    t.block_height
  FROM
    public_transform.txs_view t
  WHERE
    (
      (
        (t.transaction_result ->> 'type' :: text) = 'ResponseOk' :: text
      )
      AND (
        t.contract_call_contract_id = (
          (
            SELECT
              config_contracts.full_name
            FROM
              laplace.config_contracts
            WHERE
              (
                (config_contracts.contract) :: text = 'fixed-weight-pool-v1-01' :: text
              )
          )
        ) :: text
      )
      AND (
        (
          (
            t.contract_call_function_name = 'swap-helper' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wbtc' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
        )
        OR (
          (
            t.contract_call_function_name = 'swap-x-for-y' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wbtc' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
        )
      )
      AND (t.canonical = true)
      AND (t.microblock_canonical = true)
      AND (t.status = 1)
    )
),
stx_out_btc_in_txs AS (
  SELECT
    t.sender_address,
    encode(t.tx_id, 'hex' :: text) AS tx_id,
    (
      (
        (
          ((t.function_args -> 'args' :: text) -> 4) ->> 'value' :: text
        )
      ) :: double precision / (100000000) :: double precision
    ) AS input_amount,
    CASE
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'UInt' :: text
      ) THEN (
        (
          (
            (t.transaction_result -> 'value' :: text) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      WHEN (
        (
          (t.transaction_result -> 'value' :: text) ->> 'type' :: text
        ) = 'Tuple' :: text
      ) THEN (
        (
          (
            (
              (
                (t.transaction_result -> 'value' :: text) -> 'value' :: text
              ) -> 'dy' :: text
            ) ->> 'value' :: text
          )
        ) :: double precision / (100000000) :: double precision
      )
      ELSE (0) :: double precision
    END AS output_amount,
    t.transaction_result,
    t.id,
    (
      to_timestamp((t.burn_block_time) :: double precision) AT TIME ZONE 'CCT' :: text
    ) AS burn_block_time,
    t.block_height
  FROM
    public_transform.txs_view t
  WHERE
    (
      (
        (t.transaction_result ->> 'type' :: text) = 'ResponseOk' :: text
      )
      AND (
        t.contract_call_contract_id = (
          (
            SELECT
              config_contracts.full_name
            FROM
              laplace.config_contracts
            WHERE
              (
                (config_contracts.contract) :: text = 'fixed-weight-pool-v1-01' :: text
              )
          )
        ) :: text
      )
      AND (
        (
          (
            t.contract_call_function_name = 'swap-helper' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wbtc' :: text
                  )
              )
            ) :: text
          )
        )
        OR (
          (
            t.contract_call_function_name = 'swap-y-for-x' :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 1) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wstx' :: text
                  )
              )
            ) :: text
          )
          AND (
            (
              ((t.function_args -> 'args' :: text) -> 0) ->> 'value' :: text
            ) = (
              (
                SELECT
                  config_contracts.full_name
                FROM
                  laplace.config_contracts
                WHERE
                  (
                    (config_contracts.contract) :: text = 'token-wbtc' :: text
                  )
              )
            ) :: text
          )
        )
      )
      AND (t.canonical = true)
      AND (t.microblock_canonical = true)
      AND (t.status = 1)
    )
)
SELECT
  'wstx-wbtc-pool' :: text AS pool_name,
  volume.time_range,
  sum(volume.wstx_volume) AS wstx_volume,
  sum(volume.alex_volume) AS alex_volume,
  sum((volume.wstx_volume + volume.alex_volume)) AS total_volume
FROM
  (
    (
      SELECT
        sum(
          (
            stx_in_btc_out_txs.input_amount * (
              SELECT
                coin_gecko.avg_price_usd
              FROM
                laplace.coin_gecko
              WHERE
                ((coin_gecko.token) :: text = 'token-wstx' :: text)
            )
          )
        ) AS wstx_volume,
        sum(
          (
            stx_in_btc_out_txs.output_amount * (
              SELECT
                coin_gecko.avg_price_usd
              FROM
                laplace.coin_gecko
              WHERE
                ((coin_gecko.token) :: text = 'token-xbtc' :: text)
            )
          )
        ) AS alex_volume,
        '24hrs' :: text AS time_range
      FROM
        stx_in_btc_out_txs
      WHERE
        (
          stx_in_btc_out_txs.burn_block_time > (
            (
              SELECT
                max(stx_in_btc_out_txs_1.burn_block_time) AS max
              FROM
                stx_in_btc_out_txs stx_in_btc_out_txs_1
            ) - '24:00:00' :: interval
          )
        )
      UNION
      SELECT
        sum(
          (
            stx_in_btc_out_txs.input_amount * (
              SELECT
                coin_gecko.avg_price_usd
              FROM
                laplace.coin_gecko
              WHERE
                ((coin_gecko.token) :: text = 'token-wstx' :: text)
            )
          )
        ) AS wstx_volume,
        sum(
          (
            stx_in_btc_out_txs.output_amount * (
              SELECT
                coin_gecko.avg_price_usd
              FROM
                laplace.coin_gecko
              WHERE
                ((coin_gecko.token) :: text = 'token-xbtc' :: text)
            )
          )
        ) AS alex_volume,
        '7days' :: text AS time_range
      FROM
        stx_in_btc_out_txs
      WHERE
        (
          stx_in_btc_out_txs.burn_block_time > (
            (
              SELECT
                max(stx_in_btc_out_txs_1.burn_block_time) AS max
              FROM
                stx_in_btc_out_txs stx_in_btc_out_txs_1
            ) - '7 days' :: interval
          )
        )
    )
    UNION ALL
      (
        SELECT
          sum(
            (
              stx_out_btc_in_txs.output_amount * (
                SELECT
                  coin_gecko.avg_price_usd
                FROM
                  laplace.coin_gecko
                WHERE
                  ((coin_gecko.token) :: text = 'token-wstx' :: text)
              )
            )
          ) AS wstx_volume,
          sum(
            (
              stx_out_btc_in_txs.input_amount * (
                SELECT
                  coin_gecko.avg_price_usd
                FROM
                  laplace.coin_gecko
                WHERE
                  ((coin_gecko.token) :: text = 'token-xbtc' :: text)
              )
            )
          ) AS alex_volume,
          '24hrs' :: text AS time_range
        FROM
          stx_out_btc_in_txs
        WHERE
          (
            stx_out_btc_in_txs.burn_block_time > (
              (
                SELECT
                  max(stx_out_btc_in_txs_1.burn_block_time) AS max
                FROM
                  stx_out_btc_in_txs stx_out_btc_in_txs_1
              ) - '24:00:00' :: interval
            )
          )
        UNION
        SELECT
          sum(
            (
              stx_out_btc_in_txs.output_amount * (
                SELECT
                  coin_gecko.avg_price_usd
                FROM
                  laplace.coin_gecko
                WHERE
                  ((coin_gecko.token) :: text = 'token-wstx' :: text)
              )
            )
          ) AS wstx_volume,
          sum(
            (
              stx_out_btc_in_txs.input_amount * (
                SELECT
                  coin_gecko.avg_price_usd
                FROM
                  laplace.coin_gecko
                WHERE
                  ((coin_gecko.token) :: text = 'token-xbtc' :: text)
              )
            )
          ) AS alex_volume,
          '7days' :: text AS time_range
        FROM
          stx_out_btc_in_txs
        WHERE
          (
            stx_out_btc_in_txs.burn_block_time > (
              (
                SELECT
                  max(stx_out_btc_in_txs_1.burn_block_time) AS max
                FROM
                  stx_out_btc_in_txs stx_out_btc_in_txs_1
              ) - '7 days' :: interval
            )
          )
      )
  ) volume
GROUP BY
  volume.time_range;
DROP MATERIALIZED VIEW "laplace"."ytp_liquidity";
CREATE MATERIALIZED VIEW "laplace"."ytp_liquidity" AS WITH ytp_detail AS (
  SELECT
    pool_details_ytp.contract_name,
    pool_details_ytp.function_name,
    pool_details_ytp.block_height,
    pool_details_ytp.time_stamp,
    pool_details_ytp.yield_token,
    pool_details_ytp.expiry,
    pool_details_ytp.balance_token,
    pool_details_ytp.balance_virtual,
    pool_details_ytp.balance_yield_token,
    pool_details_ytp.fee_rate_token,
    pool_details_ytp.fee_rate_yield_token,
    pool_details_ytp.fee_rebate,
    pool_details_ytp.fee_to_address,
    pool_details_ytp.listed,
    pool_details_ytp.oracle_average,
    pool_details_ytp.oracle_enabled,
    pool_details_ytp.oracle_resilient,
    pool_details_ytp.pool_token,
    pool_details_ytp.token_trait,
    pool_details_ytp.total_supply
  FROM
    laplace.pool_details_ytp
  WHERE
    (
      (
        (pool_details_ytp.function_name) :: text = 'get-pool-details' :: text
      )
      AND (
        pool_details_ytp.block_height = (
          SELECT
            max(pool_details_ytp_1.block_height) AS max
          FROM
            laplace.pool_details_ytp pool_details_ytp_1
        )
      )
    )
)
SELECT
  ytp_detail.yield_token,
  coin_gecko.token,
  (
    (
      (
        (
          (ytp_detail.balance_token) :: bigint + (ytp_detail.balance_yield_token) :: bigint
        )
      ) :: double precision * coin_gecko.avg_price_usd
    ) / ('100000000' :: numeric) :: double precision
  ) AS liquidity
FROM
  (
    ytp_detail
    JOIN laplace.coin_gecko ON (
      (
        (ytp_detail.token_trait) :: text = (coin_gecko.token) :: text
      )
    )
  );
