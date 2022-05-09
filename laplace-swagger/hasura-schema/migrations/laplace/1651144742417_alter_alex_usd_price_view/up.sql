CREATE
OR REPLACE VIEW "laplace"."alex_usd_pricing" AS
SELECT
  'age000-governance-token' :: text AS token,
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
          (latest_pool_stats.oracle_instant) :: double precision / ('100000000' :: numeric) :: double precision
        )
      FROM
        laplace.latest_pool_stats
      WHERE
        (
            (latest_pool_stats.pool_token) :: text = 'fwp-wstx-alex-50-50-v1-01' :: text
        )
    )
  ) AS avg_price_usd;
