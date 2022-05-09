CREATE TABLE laplace.oracle_instant_ytp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  yield_token character varying NOT NULL,
  expiry character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_instant_ytp IS 'ALEX yield-token-pool oracle-instant price time series data';

CREATE TABLE laplace.oracle_instant_fwp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  yield_token character varying NOT NULL,
  expiry character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_instant_fwp IS 'ALEX fixed-weight-pool oracle-instant price time series data';

CREATE TABLE laplace.oracle_instant_swp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  yield_token character varying NOT NULL,
  expiry character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_instant_swp IS 'ALEX simple-weight-pool oracle-instant price time series data';

CREATE TABLE laplace.oracle_instant_ytp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  yield_token character varying NOT NULL,
  expiry character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_instant_ytp IS 'ALEX yield-token-pool oracle-instant price time series data';

CREATE TABLE laplace.oracle_resilient_fwp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  token_x character varying NOT NULL,
  token_y character varying NOT NULL,
  weight_x character varying NOT NULL,
  weight_y character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_resilient_fwp IS 'ALEX fixed-weight-pool oracle-resilient price time series data';

CREATE TABLE laplace.oracle_resilient_swp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  token_x character varying NOT NULL,
  token_y character varying NOT NULL,
  weight_x character varying NOT NULL,
  weight_y character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_resilient_swp IS 'ALEX simple-weight-pool oracle-resilient price time series data';

CREATE TABLE laplace.oracle_resilient_ytp (
  contract_name character varying NOT NULL,
  function_name character varying NOT NULL,
  yield_token character varying NOT NULL,
  expiry character varying NOT NULL,
  value character varying NOT NULL,
  block_height integer NOT NULL
);

COMMENT ON TABLE laplace.oracle_resilient_fwp IS 'ALEX yield-token-pool oracle-resilient price time series data';

CREATE TABLE laplace.staking_data (
  token character varying NOT NULL,
  current_cycle integer NOT NULL,
  cycle integer NOT NULL,
  block_height integer NOT NULL,
  staking_stats bigint NOT NULL,
  coinbase_amount bigint NOT NULL,
  apr numeric NOT NULL
);

COMMENT ON TABLE laplace.staking_data IS 'ALEX staking time series data';

CREATE
OR REPLACE VIEW "laplace"."latest_staking_data" AS
SELECT
  staking_data.token,
  staking_data.current_cycle,
  staking_data.cycle,
  staking_data.block_height,
  staking_data.staking_stats,
  staking_data.coinbase_amount,
  staking_data.apr
FROM
  (
    laplace.staking_data
    JOIN (
      SELECT
        staking_data_1.token,
        max(staking_data_1.block_height) AS block_height
      FROM
        laplace.staking_data staking_data_1
      GROUP BY
        staking_data_1.token
    ) maxes_by_token ON (
      (
        (
          (staking_data.token) :: text = (maxes_by_token.token) :: text
        )
        AND (
          staking_data.block_height = maxes_by_token.block_height
        )
      )
    )
  )
ORDER BY
  staking_data.cycle;
