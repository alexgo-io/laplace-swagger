CREATE
OR REPLACE VIEW "laplace"."current_token_price" AS (
  WITH coin_geiko AS (
    SELECT
      CASE
        WHEN (
          (coin_gecko.token) :: text = 'token-usda' :: text
        ) THEN 'token-wusda' :: character varying
        WHEN ((coin_gecko.token) :: text = 'token-mia' :: text) THEN 'token-wmia' :: character varying
        WHEN (
          (coin_gecko.token) :: text = 'token-diko' :: text
        ) THEN 'token-wdiko' :: character varying
        ELSE coin_gecko.token
      END AS token,
      coin_gecko.avg_price_usd
    FROM
      laplace.coin_gecko
  ),
  alex AS (
    SELECT
      alex_usd_pricing.token,
      alex_usd_pricing.avg_price_usd
    FROM
      laplace.alex_usd_pricing
    WHERE
      (
        alex_usd_pricing.token = 'age000-governance-token' :: text
      )
  ),
  at_alex AS (
    SELECT
      'auto-alex' as token,
      (
        SELECT
          est_token_y_price
        FROM
          laplace.simple_weight_pool_alex
        WHERE
          pool_token = 'fwp-alex-autoalex'
        ORDER BY
          block_height DESC
        LIMIT
          1
      ) * alex.avg_price_usd / 100000000 as avg_price_usd
    FROM
      alex
  ),
  wban AS (
    SELECT
      oracle_token_price.token,
      COALESCE(
        oracle_token_price.avg_price_usd,
        (1) :: double precision
      ) AS avg_price_usd
    FROM
      laplace.oracle_token_price
  ),
  usda AS (
    SELECT
      case
        WHEN (
          (external_token_price.token_name) :: text = 'USDA' :: text
        ) THEN 'token-usda' :: character varying
        else token_name
      end as token,
      COALESCE(
        external_token_price.value,
        (1) :: double precision
      ) AS avg_price_usd
    FROM
      laplace.external_token_price
  ),
  all_result AS (
    SELECT
      coin_geiko.token,
      coin_geiko.avg_price_usd
    FROM
      coin_geiko
    UNION
    ALL
    SELECT
      alex.token,
      alex.avg_price_usd
    FROM
      alex
    UNION
    ALL
    SELECT
      at_alex.token,
      at_alex.avg_price_usd
    FROM
      at_alex
    UNION
    ALL
    SELECT
      wban.token,
      wban.avg_price_usd
    FROM
      wban
    UNION
    ALL
    SELECT
      usda.token,
      usda.avg_price_usd
    FROM
      usda
  )
  SELECT
    all_result.token,
    all_result.avg_price_usd
  FROM
    all_result
);
