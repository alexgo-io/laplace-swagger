CREATE
OR REPLACE VIEW "laplace"."oracle_token_price" AS
SELECT
  'token-wban' :: text AS token,
  (
    (
      SELECT
        alex_usd_pricing.avg_price_usd
      FROM
        laplace.alex_usd_pricing
      WHERE
        (
          alex_usd_pricing.token = 'age000-governance-token' :: text
        )
    ) / (
      SELECT
        (
          (latest_pool_stats.oracle_instant) :: double precision / ('100000000' :: numeric) :: double precision
        )
      FROM
        laplace.latest_pool_stats
      WHERE
        (
            (latest_pool_stats.pool_token) :: text = 'fwp-alex-wban' :: text
        )
    )
  ) AS avg_price_usd
UNION
SELECT
  'token-wslm' :: text AS token,
  (
    (
      SELECT
        alex_usd_pricing.avg_price_usd
      FROM
        laplace.alex_usd_pricing
      WHERE
        (
          alex_usd_pricing.token = 'age000-governance-token' :: text
        )
    ) / (
      SELECT
        (
          (latest_pool_stats.oracle_instant) :: double precision / ('100000000' :: numeric) :: double precision
        )
      FROM
        laplace.latest_pool_stats
      WHERE
        (
            (latest_pool_stats.pool_token) :: text = 'fwp-alex-wslm' :: text
        )
    )
  ) AS avg_price_usd;
