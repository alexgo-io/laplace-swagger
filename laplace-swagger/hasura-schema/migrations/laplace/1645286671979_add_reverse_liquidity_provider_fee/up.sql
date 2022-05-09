DROP VIEW IF EXISTS laplace.liquidity_provider_fee;

CREATE VIEW laplace.liquidity_provider_fee AS
select
      'age000-governance-token' as token_to,
      'token-wbtc' as token_from,
      (
            select
                  value :: numeric
            from
                  laplace.oracle_resilient_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'age000-governance-token'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and block_height = (
                        select
                              max(laplace.oracle_resilient_fwp.block_height)
                        from
                              laplace.oracle_resilient_fwp
                  )
      ) as wstx_to,
      (
            select
                  value :: numeric
            from
                  laplace.oracle_resilient_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'token-wbtc'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and block_height = (
                        select
                              max(laplace.oracle_resilient_fwp.block_height)
                        from
                              laplace.oracle_resilient_fwp
                  )
      ) as wstx_from,
      (
            select
                  value :: numeric
            from
                  laplace.static_data_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'age000-governance-token'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and function_name = 'get-fee-rate-x'
      ) as fee_details_to,
      (
            select
                  value :: numeric
            from
                  laplace.static_data_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'token-wbtc'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and function_name = 'get-fee-rate-y'
      ) as fee_details_from
union
select
      'token-wbtc' as token_to,
      'age000-governance-token' as token_from,
      (
            select
                  value :: numeric
            from
                  laplace.oracle_resilient_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'token-wbtc'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and block_height = (
                        select
                              max(laplace.oracle_resilient_fwp.block_height)
                        from
                              laplace.oracle_resilient_fwp
                  )
      ) as wstx_to,
      (
            select
                  value :: numeric
            from
                  laplace.oracle_resilient_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'age000-governance-token'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and block_height = (
                        select
                              max(laplace.oracle_resilient_fwp.block_height)
                        from
                              laplace.oracle_resilient_fwp
                  )
      ) as wstx_from,
      (
            select
                  value :: numeric
            from
                  laplace.static_data_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'token-wbtc'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and function_name = 'get-fee-rate-y'
      ) as fee_details_to,
      (
            select
                  value :: numeric
            from
                  laplace.static_data_fwp
            where
                  token_x = 'token-wstx'
                  and token_y = 'age000-governance-token'
                  and contract_name = 'fixed-weight-pool-v1-01'
                  and function_name = 'get-fee-rate-x'
      ) as fee_details_from;
