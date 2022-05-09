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
        pool_liquidity.token_name = 'fwp-alex-wban'
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
