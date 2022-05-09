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
          (alex_usd_pricing.token) :: text = 'age000-governance-token' :: text
        )
    ) / (
      SELECT 
        (
          (oracle_instant_swp.value) :: double precision / ('100000000' :: numeric) :: double precision
        ) 
      FROM 
        laplace.oracle_instant_swp 
      WHERE 
        (
          (
            (oracle_instant_swp.token_x) :: text = 'age000-governance-token' :: text
          ) 
          AND (
            (oracle_instant_swp.token_y) :: text = 'token-wban' :: text
          ) 
          AND (
            (
              oracle_instant_swp.contract_name
            ) :: text = 'simple-weight-pool-alex' :: text
          ) 
          AND (
            oracle_instant_swp.block_height = (
              SELECT 
                max (
                  oracle_instant_swp_1.block_height
                ) AS max 
              FROM 
                laplace.oracle_instant_swp oracle_instant_swp_1
            )
          )
        )
    )
  ) AS avg_price_usd;
