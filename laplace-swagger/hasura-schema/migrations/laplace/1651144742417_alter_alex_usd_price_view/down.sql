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
            (oracle_instant_fwp.contract_name) :: text = 'fixed-weight-pool-v1-01' :: text
          )
          AND (
            oracle_instant_fwp.block_height = (
              SELECT
                max(oracle_instant_fwp_1.block_height) AS max
              FROM
                laplace.oracle_instant_fwp oracle_instant_fwp_1
            )
          )
        )
    )
  ) AS avg_price_usd;
