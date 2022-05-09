CREATE
OR REPLACE VIEW "laplace"."latest_pool_stats" AS
SELECT
  pool_stats.pool_token,
  pool_stats.token_x,
  pool_stats.token_y,
  pool_stats.balance_x, 
  pool_stats.balance_y,
  pool_stats.total_supply,
  pool_stats.fee_rate_x, 
  pool_stats.fee_rate_y, 
  pool_stats.fee_rebate, 
  pool_stats.block_height,
  pool_stats.volume_x_24h,
  pool_stats.volume_y_24h,
  pool_stats.volume_24h,
  pool_stats.volume_x_7d,
  pool_stats.volume_y_7d,
  pool_stats.volume_7d,
  pool_stats.fee_rebate_x_24h,
  pool_stats.fee_rebate_y_24h,
  pool_stats.fee_rebate_24h,
  pool_stats.fee_rebate_x_7d,
  pool_stats.fee_rebate_y_7d,
  pool_stats.fee_rebate_7d,
    pool_stats.liquidity,
      pool_stats.apr_7d,
        pool_stats.burn_block_time,
          pool_stats.sync_at
FROM
  (
    laplace.pool_stats
    JOIN (
      SELECT
        pool_stats_1.pool_token,
        max(pool_stats_1.block_height) AS block_height
      FROM
        laplace.pool_stats pool_stats_1
      GROUP BY
        pool_stats_1.pool_token
    ) latest_by_pool_token ON (
      (
        (
          (pool_stats.pool_token) :: text = (latest_by_pool_token.pool_token) :: text
        )
        AND (
          pool_stats.block_height :: numeric = latest_by_pool_token.block_height ::numeric
        )
      )
    )
  );
