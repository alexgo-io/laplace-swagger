DROP MATERIALIZED VIEW if EXISTS "laplace"."wstx_wbtc_pool_volume" CASCADE;
 CREATE MATERIALIZED VIEW "laplace"."wstx_wbtc_pool_volume" AS
 WITH stx_in_btc_out_txs AS (
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
          stx_in_btc_out_txs.burn_block_time > ((select max(burn_block_time) from stx_in_btc_out_txs) - '24:00:00' :: interval)
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
          stx_in_btc_out_txs.burn_block_time > ((select max(burn_block_time) from stx_in_btc_out_txs) - '7 days' :: interval)
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
            stx_out_btc_in_txs.burn_block_time > ((select max(burn_block_time) from stx_out_btc_in_txs) - '24:00:00' :: interval)
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
            stx_out_btc_in_txs.burn_block_time > ((select max(burn_block_time) from stx_out_btc_in_txs) - '7 days' :: interval)
          )
      )
  ) volume
GROUP BY
  volume.time_range;
