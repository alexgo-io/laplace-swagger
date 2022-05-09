SET check_function_bodies = false;
CREATE SCHEMA laplace;
CREATE TABLE laplace.coin_gecko (
    token character varying NOT NULL,
    coin_gecko_id character varying NOT NULL,
    market_cap jsonb NOT NULL,
    prices_market jsonb NOT NULL,
    ccy jsonb NOT NULL,
    avg_price_usd double precision NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);
CREATE TABLE laplace.oracle_instant_fwp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    token_x character varying NOT NULL,
    token_y character varying NOT NULL,
    weight_x character varying NOT NULL,
    weight_y character varying NOT NULL,
    value character varying NOT NULL,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.oracle_instant_fwp IS 'ALEX fixed-weight-pool oracle-instant price time series data';
CREATE VIEW laplace.alex_usd_pricing AS
 SELECT 'age000-governance-token'::text AS token,
    (( SELECT coin_gecko.avg_price_usd
           FROM laplace.coin_gecko
          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)) / ( SELECT ((oracle_instant_fwp.value)::double precision / ('100000000'::numeric)::double precision)
           FROM laplace.oracle_instant_fwp
          WHERE (((oracle_instant_fwp.token_x)::text = 'token-wstx'::text) AND ((oracle_instant_fwp.token_y)::text = 'age000-governance-token'::text) AND ((oracle_instant_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text) AND (oracle_instant_fwp.block_height = ( SELECT max(oracle_instant_fwp_1.block_height) AS max
                   FROM laplace.oracle_instant_fwp oracle_instant_fwp_1))))) AS avg_price_usd;
CREATE TABLE laplace.coin_gecko_archive (
    token character varying NOT NULL,
    coin_gecko_id character varying NOT NULL,
    market_cap jsonb NOT NULL,
    prices_market jsonb NOT NULL,
    ccy jsonb NOT NULL,
    avg_price_usd double precision NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);
COMMENT ON TABLE laplace.coin_gecko_archive IS 'ALEX Coingecko price time series data';
CREATE TABLE laplace.config_contracts (
    contract character varying,
    full_name character varying
);
CREATE TABLE laplace.deployed_contracts (
    tx_id character varying NOT NULL,
    deployer_address character varying NOT NULL,
    contract_type character varying NOT NULL,
    contract_name character varying NOT NULL,
    data_type character varying NOT NULL,
    block_height character varying NOT NULL
);
COMMENT ON TABLE laplace.deployed_contracts IS 'ALEX deployed contracts relevant to ALEX app';
CREATE TABLE laplace.dynamic_ltv_crp (
    contract_name character varying DEFAULT 'collateral-rebalancing-pool'::character varying NOT NULL,
    function_name character varying DEFAULT 'get-ltv'::character varying NOT NULL,
    token character varying NOT NULL,
    collateral character varying NOT NULL,
    expiry bigint NOT NULL,
    value character varying NOT NULL,
    clarity_type character varying NOT NULL,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.dynamic_ltv_crp IS 'ALEX LTV data from collateral-rebalancing-pool time series data';
CREATE TABLE laplace.dynamic_position_crp (
    contract_name character varying DEFAULT 'collateral-rebalancing-pool'::character varying NOT NULL,
    function_name character varying DEFAULT 'get-position-given-burn-key'::character varying NOT NULL,
    token character varying NOT NULL,
    collateral character varying NOT NULL,
    expiry bigint NOT NULL,
    dx character varying NOT NULL,
    dy character varying NOT NULL,
    clarity_type_dx character varying NOT NULL,
    clarity_type_dy character varying NOT NULL,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.dynamic_position_crp IS 'ALEX position-given-burn-key data from collateral-rebalancing-pool time series data';
CREATE TABLE laplace.dynamic_price_ytp (
    contract_name character varying DEFAULT 'yield-token-pool'::character varying NOT NULL,
    function_name character varying DEFAULT 'get-price'::character varying NOT NULL,
    yield_token character varying NOT NULL,
    expiry bigint NOT NULL,
    value character varying NOT NULL,
    clarity_type character varying NOT NULL,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.dynamic_price_ytp IS 'ALEX price data from yield-token-pool time series data';
CREATE TABLE laplace.dynamic_y_given_x_fwp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    token_x character varying NOT NULL,
    token_y character varying NOT NULL,
    weight_x bigint NOT NULL,
    weight_y bigint NOT NULL,
    value character varying NOT NULL,
    clarity_type character varying NOT NULL,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.dynamic_y_given_x_fwp IS 'ALEX y_given_x data from fixed-weight-pool time series data';
CREATE TABLE laplace.dynamic_yield_ytp (
    contract_name character varying DEFAULT 'yield-token-pool'::character varying NOT NULL,
    function_name character varying DEFAULT 'get-yield'::character varying NOT NULL,
    yield_token character varying NOT NULL,
    expiry bigint NOT NULL,
    value character varying NOT NULL,
    clarity_type character varying NOT NULL,
    block_height integer NOT NULL,
    apy character varying
);
COMMENT ON TABLE laplace.dynamic_yield_ytp IS 'ALEX yield data from yield-token-pool time series data';
CREATE TABLE laplace.pool_details_fwp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    block_height integer NOT NULL,
    time_stamp timestamp with time zone NOT NULL,
    token_x character varying NOT NULL,
    token_y character varying NOT NULL,
    weight_x character varying NOT NULL,
    weight_y character varying NOT NULL,
    pool_token character varying NOT NULL,
    fee_to_address character varying NOT NULL,
    oracle_enabled character varying NOT NULL,
    balance_x bigint,
    balance_y bigint,
    fee_rate_x bigint,
    fee_rate_y bigint,
    fee_rebate bigint,
    oracle_average bigint,
    oracle_resilient bigint,
    total_supply bigint
);
COMMENT ON TABLE laplace.pool_details_fwp IS 'ALEX fixed-weight-pool time series data';
CREATE MATERIALIZED VIEW laplace.fwp_liquidity AS
 WITH fwp_detail AS (
         SELECT pool_details_fwp.contract_name,
            pool_details_fwp.function_name,
            pool_details_fwp.block_height,
            pool_details_fwp.time_stamp,
            pool_details_fwp.token_x,
            pool_details_fwp.token_y,
            pool_details_fwp.weight_x,
            pool_details_fwp.weight_y,
            pool_details_fwp.pool_token,
            pool_details_fwp.fee_to_address,
            pool_details_fwp.oracle_enabled,
            pool_details_fwp.balance_x,
            pool_details_fwp.balance_y,
            pool_details_fwp.fee_rate_x,
            pool_details_fwp.fee_rate_y,
            pool_details_fwp.fee_rebate,
            pool_details_fwp.oracle_average,
            pool_details_fwp.oracle_resilient,
            pool_details_fwp.total_supply
           FROM laplace.pool_details_fwp
          WHERE (pool_details_fwp.block_height = ( SELECT max(pool_details_fwp_1.block_height) AS max
                   FROM laplace.pool_details_fwp pool_details_fwp_1))
        ), coin_gecko_view AS (
         SELECT coin_gecko.token,
            coin_gecko.avg_price_usd
           FROM laplace.coin_gecko
        UNION ALL
         SELECT 'age000-governance-token'::character varying AS token,
            (( SELECT coin_gecko.avg_price_usd
                   FROM laplace.coin_gecko
                  WHERE ((coin_gecko.token)::text = 'token-wstx'::text)) / ( SELECT ((oracle_instant_fwp.value)::double precision / ('100000000'::numeric)::double precision)
                   FROM laplace.oracle_instant_fwp
                  WHERE (((oracle_instant_fwp.token_x)::text = 'token-wstx'::text) AND ((oracle_instant_fwp.token_y)::text = 'age000-governance-token'::text) AND (oracle_instant_fwp.block_height = ( SELECT max(oracle_instant_fwp_1.block_height) AS max
                           FROM laplace.oracle_instant_fwp oracle_instant_fwp_1))))) AS avg_price_usd
        )
 SELECT fwp_detail.contract_name,
    fwp_detail.token_x,
    fwp_detail.token_y,
    ((fwp_detail.weight_x)::double precision / ('100000000'::numeric)::double precision) AS weight_x,
    ((fwp_detail.weight_y)::double precision / ('100000000'::numeric)::double precision) AS weight_y,
    ((((fwp_detail.balance_x)::double precision * ( SELECT coin_gecko_view.avg_price_usd
           FROM coin_gecko_view
          WHERE ((coin_gecko_view.token)::text = (fwp_detail.token_x)::text))) + ((fwp_detail.balance_y)::double precision * ( SELECT coin_gecko_view.avg_price_usd
           FROM coin_gecko_view
          WHERE ((coin_gecko_view.token)::text = (fwp_detail.token_y)::text)))) / ('100000000'::numeric)::double precision) AS liquidity
   FROM fwp_detail
  WITH NO DATA;
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
CREATE MATERIALIZED VIEW laplace.farming_details AS
 SELECT 'fwp-wstx-alex-50-50-v1-01'::text AS pool_token,
    ( SELECT fwp_liquidity.liquidity
           FROM laplace.fwp_liquidity
          WHERE (((fwp_liquidity.token_x)::text = 'token-wstx'::text) AND ((fwp_liquidity.token_y)::text = 'age000-governance-token'::text) AND ((fwp_liquidity.contract_name)::text = 'fixed-weight-pool-v1-01'::text))) AS liquidity,
    ( SELECT (sum((aprs.apr)::double precision) / (32)::double precision)
           FROM ( SELECT staking_data.apr
                   FROM laplace.staking_data
                  WHERE (staking_data.block_height = ( SELECT max(staking_data_1.block_height) AS max
                           FROM laplace.staking_data staking_data_1))) aprs) AS apr,
    'ALEX'::text AS reward
UNION
 SELECT 'fwp-wstx-wbtc-50-50-v1-01'::text AS pool_token,
    ( SELECT fwp_liquidity.liquidity
           FROM laplace.fwp_liquidity
          WHERE (((fwp_liquidity.token_x)::text = 'token-wstx'::text) AND ((fwp_liquidity.token_y)::text = 'token-wbtc'::text) AND ((fwp_liquidity.contract_name)::text = 'fixed-weight-pool-v1-01'::text))) AS liquidity,
    ( SELECT (sum((aprs.apr)::double precision) / (32)::double precision)
           FROM ( SELECT staking_data.apr
                   FROM laplace.staking_data
                  WHERE (staking_data.block_height = ( SELECT max(staking_data_1.block_height) AS max
                           FROM laplace.staking_data staking_data_1))) aprs) AS apr,
    'ALEX'::text AS reward
  WITH NO DATA;
CREATE TABLE laplace.static_data_fwp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    value character varying NOT NULL,
    token_x character varying NOT NULL,
    token_y character varying NOT NULL,
    weight_x character varying NOT NULL,
    weight_y character varying NOT NULL,
    clarity_type character varying,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.static_data_fwp IS 'ALEX static data';
CREATE MATERIALIZED VIEW laplace.wstx_alex_pool_volume AS
 WITH stx_in_alex_out_txs AS (
         SELECT t.sender_address,
            encode(t.tx_id, 'hex'::text) AS tx_id,
            (((((t.function_args -> 'args'::text) -> 4) ->> 'value'::text))::double precision / (100000000)::double precision) AS input_amount,
                CASE
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'UInt'::text) THEN ((((t.transaction_result -> 'value'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'Tuple'::text) THEN ((((((t.transaction_result -> 'value'::text) -> 'value'::text) -> 'dy'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    ELSE (0)::double precision
                END AS output_amount,
            t.transaction_result,
            t.id,
            (to_timestamp((t.burn_block_time)::double precision) AT TIME ZONE 'CCT'::text) AS burn_block_time,
            t.block_height
           FROM public_transform.txs_view t
          WHERE (((t.transaction_result ->> 'type'::text) = 'ResponseOk'::text) AND (t.contract_call_contract_id = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'fixed-weight-pool-v1-01'::text)))::text) AND (((t.contract_call_function_name = 'swap-helper'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'age000-governance-token'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text)) OR ((t.contract_call_function_name = 'swap-x-for-y'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'age000-governance-token'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text))) AND (t.canonical = true) AND (t.microblock_canonical = true))
        ), stx_out_alex_in_txs AS (
         SELECT t.sender_address,
            encode(t.tx_id, 'hex'::text) AS tx_id,
            (((((t.function_args -> 'args'::text) -> 4) ->> 'value'::text))::double precision / (100000000)::double precision) AS input_amount,
                CASE
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'UInt'::text) THEN ((((t.transaction_result -> 'value'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'Tuple'::text) THEN ((((((t.transaction_result -> 'value'::text) -> 'value'::text) -> 'dy'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    ELSE (0)::double precision
                END AS output_amount,
            t.transaction_result,
            t.id,
            (to_timestamp((t.burn_block_time)::double precision) AT TIME ZONE 'CCT'::text) AS burn_block_time,
            t.block_height
           FROM public_transform.txs_view t
          WHERE (((t.transaction_result ->> 'type'::text) = 'ResponseOk'::text) AND (t.contract_call_contract_id = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'fixed-weight-pool-v1-01'::text)))::text) AND (((t.contract_call_function_name = 'swap-helper'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'age000-governance-token'::text)))::text)) OR ((t.contract_call_function_name = 'swap-y-for-x'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'age000-governance-token'::text)))::text))) AND (t.canonical = true) AND (t.microblock_canonical = true))
        )
 SELECT 'wstx-alex-pool'::text AS pool_name,
    volume.time_range,
    sum(volume.wstx_volume) AS wstx_volume,
    sum(volume.alex_volume) AS alex_volume,
    sum((volume.wstx_volume + volume.alex_volume)) AS total_volume
   FROM ((
                 SELECT sum((stx_in_alex_out_txs.input_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_in_alex_out_txs.output_amount * ( SELECT alex_usd_pricing.avg_price_usd
                           FROM laplace.alex_usd_pricing
                          WHERE (alex_usd_pricing.token = 'age000-governance-token'::text)))) AS alex_volume,
                    '24hrs'::text AS time_range
                   FROM stx_in_alex_out_txs
                  WHERE (stx_in_alex_out_txs.burn_block_time > (CURRENT_TIMESTAMP - '24:00:00'::interval))
                UNION
                 SELECT sum((stx_in_alex_out_txs.input_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_in_alex_out_txs.output_amount * ( SELECT alex_usd_pricing.avg_price_usd
                           FROM laplace.alex_usd_pricing
                          WHERE (alex_usd_pricing.token = 'age000-governance-token'::text)))) AS alex_volume,
                    '7days'::text AS time_range
                   FROM stx_in_alex_out_txs
                  WHERE (stx_in_alex_out_txs.burn_block_time > (CURRENT_TIMESTAMP - '7 days'::interval))
        ) UNION ALL (
                 SELECT sum((stx_out_alex_in_txs.output_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_out_alex_in_txs.input_amount * ( SELECT alex_usd_pricing.avg_price_usd
                           FROM laplace.alex_usd_pricing
                          WHERE (alex_usd_pricing.token = 'age000-governance-token'::text)))) AS alex_volume,
                    '24hrs'::text AS time_range
                   FROM stx_out_alex_in_txs
                  WHERE (stx_out_alex_in_txs.burn_block_time > (CURRENT_TIMESTAMP - '24:00:00'::interval))
                UNION
                 SELECT sum((stx_out_alex_in_txs.output_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_out_alex_in_txs.input_amount * ( SELECT alex_usd_pricing.avg_price_usd
                           FROM laplace.alex_usd_pricing
                          WHERE (alex_usd_pricing.token = 'age000-governance-token'::text)))) AS alex_volume,
                    '7days'::text AS time_range
                   FROM stx_out_alex_in_txs
                  WHERE (stx_out_alex_in_txs.burn_block_time > (CURRENT_TIMESTAMP - '7 days'::interval))
        )) volume
  GROUP BY volume.time_range
  WITH NO DATA;
CREATE MATERIALIZED VIEW laplace.wstx_wbtc_pool_volume AS
 WITH stx_in_btc_out_txs AS (
         SELECT t.sender_address,
            encode(t.tx_id, 'hex'::text) AS tx_id,
            (((((t.function_args -> 'args'::text) -> 4) ->> 'value'::text))::double precision / (100000000)::double precision) AS input_amount,
                CASE
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'UInt'::text) THEN ((((t.transaction_result -> 'value'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'Tuple'::text) THEN ((((((t.transaction_result -> 'value'::text) -> 'value'::text) -> 'dy'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    ELSE (0)::double precision
                END AS output_amount,
            t.transaction_result,
            t.id,
            (to_timestamp((t.burn_block_time)::double precision) AT TIME ZONE 'CCT'::text) AS burn_block_time,
            t.block_height
           FROM public_transform.txs_view t
          WHERE (((t.transaction_result ->> 'type'::text) = 'ResponseOk'::text) AND (t.contract_call_contract_id = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'fixed-weight-pool-v1-01'::text)))::text) AND (((t.contract_call_function_name = 'swap-helper'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wbtc'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text)) OR ((t.contract_call_function_name = 'swap-x-for-y'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wbtc'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text))) AND (t.canonical = true) AND (t.microblock_canonical = true) AND (t.status = 1))
        ), stx_out_btc_in_txs AS (
         SELECT t.sender_address,
            encode(t.tx_id, 'hex'::text) AS tx_id,
            (((((t.function_args -> 'args'::text) -> 4) ->> 'value'::text))::double precision / (100000000)::double precision) AS input_amount,
                CASE
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'UInt'::text) THEN ((((t.transaction_result -> 'value'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    WHEN (((t.transaction_result -> 'value'::text) ->> 'type'::text) = 'Tuple'::text) THEN ((((((t.transaction_result -> 'value'::text) -> 'value'::text) -> 'dy'::text) ->> 'value'::text))::double precision / (100000000)::double precision)
                    ELSE (0)::double precision
                END AS output_amount,
            t.transaction_result,
            t.id,
            (to_timestamp((t.burn_block_time)::double precision) AT TIME ZONE 'CCT'::text) AS burn_block_time,
            t.block_height
           FROM public_transform.txs_view t
          WHERE (((t.transaction_result ->> 'type'::text) = 'ResponseOk'::text) AND (t.contract_call_contract_id = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'fixed-weight-pool-v1-01'::text)))::text) AND (((t.contract_call_function_name = 'swap-helper'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wbtc'::text)))::text)) OR ((t.contract_call_function_name = 'swap-y-for-x'::text) AND ((((t.function_args -> 'args'::text) -> 1) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wstx'::text)))::text) AND ((((t.function_args -> 'args'::text) -> 0) ->> 'value'::text) = (( SELECT config_contracts.full_name
                   FROM laplace.config_contracts
                  WHERE ((config_contracts.contract)::text = 'token-wbtc'::text)))::text))) AND (t.canonical = true) AND (t.microblock_canonical = true) AND (t.status = 1))
        )
 SELECT 'wstx-wbtc-pool'::text AS pool_name,
    volume.time_range,
    sum(volume.wstx_volume) AS wstx_volume,
    sum(volume.alex_volume) AS alex_volume,
    sum((volume.wstx_volume + volume.alex_volume)) AS total_volume
   FROM ((
                 SELECT sum((stx_in_btc_out_txs.input_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_in_btc_out_txs.output_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-xbtc'::text)))) AS alex_volume,
                    '24hrs'::text AS time_range
                   FROM stx_in_btc_out_txs
                  WHERE (stx_in_btc_out_txs.burn_block_time > (CURRENT_TIMESTAMP - '24:00:00'::interval))
                UNION
                 SELECT sum((stx_in_btc_out_txs.input_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_in_btc_out_txs.output_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-xbtc'::text)))) AS alex_volume,
                    '7days'::text AS time_range
                   FROM stx_in_btc_out_txs
                  WHERE (stx_in_btc_out_txs.burn_block_time > (CURRENT_TIMESTAMP - '7 days'::interval))
        ) UNION ALL (
                 SELECT sum((stx_out_btc_in_txs.output_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_out_btc_in_txs.input_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-xbtc'::text)))) AS alex_volume,
                    '24hrs'::text AS time_range
                   FROM stx_out_btc_in_txs
                  WHERE (stx_out_btc_in_txs.burn_block_time > (CURRENT_TIMESTAMP - '24:00:00'::interval))
                UNION
                 SELECT sum((stx_out_btc_in_txs.output_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-wstx'::text)))) AS wstx_volume,
                    sum((stx_out_btc_in_txs.input_amount * ( SELECT coin_gecko.avg_price_usd
                           FROM laplace.coin_gecko
                          WHERE ((coin_gecko.token)::text = 'token-xbtc'::text)))) AS alex_volume,
                    '7days'::text AS time_range
                   FROM stx_out_btc_in_txs
                  WHERE (stx_out_btc_in_txs.burn_block_time > (CURRENT_TIMESTAMP - '7 days'::interval))
        )) volume
  GROUP BY volume.time_range
  WITH NO DATA;
CREATE MATERIALIZED VIEW laplace.liquidity_details AS
 WITH liquidity_table AS (
         SELECT 'fwp-wstx-alex-50-50-v1-01'::text AS token_name,
            ( SELECT wstx_alex_pool_volume.total_volume
                   FROM laplace.wstx_alex_pool_volume
                  WHERE (wstx_alex_pool_volume.time_range = '24hrs'::text)) AS volume_24h,
            ( SELECT wstx_alex_pool_volume.total_volume
                   FROM laplace.wstx_alex_pool_volume
                  WHERE (wstx_alex_pool_volume.time_range = '7days'::text)) AS volume_7d,
            ((((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-x'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'age000-governance-token'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision) + ((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-y'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'age000-governance-token'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision)) / (2)::double precision) AS item_fees,
            ( SELECT fwp_liquidity.liquidity
                   FROM laplace.fwp_liquidity
                  WHERE (((fwp_liquidity.token_x)::text = 'token-wstx'::text) AND ((fwp_liquidity.token_y)::text = 'age000-governance-token'::text) AND ((fwp_liquidity.contract_name)::text = 'fixed-weight-pool-v1-01'::text))) AS liquidity
        UNION
         SELECT 'fwp-wstx-wbtc-50-50-v1-01'::text AS token_name,
            ( SELECT wstx_wbtc_pool_volume.total_volume
                   FROM laplace.wstx_wbtc_pool_volume
                  WHERE (wstx_wbtc_pool_volume.time_range = '24hrs'::text)) AS volume_24h,
            ( SELECT wstx_wbtc_pool_volume.total_volume
                   FROM laplace.wstx_wbtc_pool_volume
                  WHERE (wstx_wbtc_pool_volume.time_range = '7days'::text)) AS volume_7d,
            ((((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-x'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'token-wbtc'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision) + ((( SELECT static_data_fwp.value
                   FROM laplace.static_data_fwp
                  WHERE (((static_data_fwp.function_name)::text = 'get-fee-rate-y'::text) AND ((static_data_fwp.token_x)::text = 'token-wstx'::text) AND ((static_data_fwp.token_y)::text = 'token-wbtc'::text) AND ((static_data_fwp.contract_name)::text = 'fixed-weight-pool-v1-01'::text))))::double precision / (1000000)::double precision)) / (2)::double precision) AS item_fees,
            ( SELECT fwp_liquidity.liquidity
                   FROM laplace.fwp_liquidity
                  WHERE (((fwp_liquidity.token_x)::text = 'token-wstx'::text) AND ((fwp_liquidity.token_y)::text = 'token-wbtc'::text) AND ((fwp_liquidity.contract_name)::text = 'fixed-weight-pool-v1-01'::text))) AS liquidity
        )
 SELECT liquidity_table.token_name,
    liquidity_table.volume_24h,
    liquidity_table.volume_7d,
    liquidity_table.item_fees,
    liquidity_table.liquidity,
    ((liquidity_table.item_fees / liquidity_table.liquidity) * (52)::double precision) AS apr
   FROM liquidity_table
  WITH NO DATA;
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
CREATE TABLE laplace.oracle_resilient_ytp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    yield_token character varying NOT NULL,
    expiry character varying NOT NULL,
    value character varying NOT NULL,
    block_height integer NOT NULL
);
COMMENT ON TABLE laplace.oracle_resilient_ytp IS 'ALEX yield-token-pool oracle-resilient price time series data';
CREATE TABLE laplace.pool_details_crp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    balance_x character varying NOT NULL,
    balance_y character varying NOT NULL,
    bs_vol character varying NOT NULL,
    conversion_ltv character varying NOT NULL,
    fee_rate_x character varying NOT NULL,
    fee_rate_y character varying NOT NULL,
    fee_rebate character varying NOT NULL,
    fee_to_address character varying NOT NULL,
    key_supply character varying NOT NULL,
    key_token character varying NOT NULL,
    ltv_0 character varying NOT NULL,
    moving_average character varying NOT NULL,
    token_to_maturity character varying NOT NULL,
    weight_x character varying NOT NULL,
    weight_y character varying NOT NULL,
    yield_supply character varying NOT NULL,
    yield_token character varying NOT NULL,
    block_height integer NOT NULL,
    time_stamp timestamp with time zone NOT NULL,
    collateral character varying NOT NULL,
    token character varying NOT NULL,
    expiry character varying NOT NULL,
    strike character varying
);
COMMENT ON TABLE laplace.pool_details_crp IS 'ALEX collateral-rebalancing-pool time series data';
CREATE TABLE laplace.pool_details_ytp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    block_height integer NOT NULL,
    time_stamp timestamp with time zone NOT NULL,
    yield_token character varying NOT NULL,
    expiry character varying NOT NULL,
    balance_token character varying NOT NULL,
    balance_virtual character varying NOT NULL,
    balance_yield_token character varying NOT NULL,
    fee_rate_token character varying NOT NULL,
    fee_rate_yield_token character varying NOT NULL,
    fee_rebate character varying NOT NULL,
    fee_to_address character varying NOT NULL,
    listed character varying NOT NULL,
    oracle_average character varying NOT NULL,
    oracle_enabled character varying NOT NULL,
    oracle_resilient character varying NOT NULL,
    pool_token character varying NOT NULL,
    token_trait character varying NOT NULL,
    total_supply character varying NOT NULL
);
COMMENT ON TABLE laplace.pool_details_ytp IS 'ALEX yield-token-pool time series data';
CREATE TABLE laplace.reward_cycle_stats (
    token character varying NOT NULL,
    block_height bigint NOT NULL,
    payload jsonb NOT NULL,
    cycle bigint NOT NULL
);
CREATE TABLE laplace.stacks_blockchain_events (
    id integer NOT NULL,
    event_path character varying(450),
    payload jsonb
);
CREATE SEQUENCE laplace.stacks_blockchain_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE laplace.stacks_blockchain_events_id_seq OWNED BY laplace.stacks_blockchain_events.id;
CREATE TABLE laplace.static_data_ytp (
    contract_name character varying NOT NULL,
    function_name character varying NOT NULL,
    block_height integer NOT NULL,
    yield_token character varying NOT NULL,
    expiry bigint NOT NULL,
    value character varying NOT NULL,
    clarity_type character varying NOT NULL
);
COMMENT ON TABLE laplace.static_data_ytp IS 'ALEX yield-token pool static data ';
CREATE TABLE laplace.sync_status (
    key character varying(64) NOT NULL,
    value text NOT NULL
);
CREATE TABLE laplace.transaction_logs (
    tx_id character varying NOT NULL,
    block_height integer NOT NULL,
    contract_id character varying NOT NULL,
    function_name character varying NOT NULL,
    sender character varying NOT NULL,
    sold_token character varying,
    bought_token character varying,
    time_stamp timestamp with time zone NOT NULL,
    id integer NOT NULL,
    tx_cost bigint,
    sold_quantity numeric,
    bought_quantity numeric
);
COMMENT ON TABLE laplace.transaction_logs IS 'ALEX transaction logs for all relevant ALEX contract';
CREATE SEQUENCE laplace.transaction_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE laplace.transaction_logs_id_seq OWNED BY laplace.transaction_logs.id;
CREATE MATERIALIZED VIEW laplace.ytp_liquidity AS
 WITH ytp_detail AS (
         SELECT pool_details_ytp.contract_name,
            pool_details_ytp.function_name,
            pool_details_ytp.block_height,
            pool_details_ytp.time_stamp,
            pool_details_ytp.yield_token,
            pool_details_ytp.expiry,
            pool_details_ytp.balance_token,
            pool_details_ytp.balance_virtual,
            pool_details_ytp.balance_yield_token,
            pool_details_ytp.fee_rate_token,
            pool_details_ytp.fee_rate_yield_token,
            pool_details_ytp.fee_rebate,
            pool_details_ytp.fee_to_address,
            pool_details_ytp.listed,
            pool_details_ytp.oracle_average,
            pool_details_ytp.oracle_enabled,
            pool_details_ytp.oracle_resilient,
            pool_details_ytp.pool_token,
            pool_details_ytp.token_trait,
            pool_details_ytp.total_supply
           FROM laplace.pool_details_ytp
          WHERE (((pool_details_ytp.function_name)::text = 'get-pool-details'::text) AND (pool_details_ytp.block_height = ( SELECT max(pool_details_ytp_1.block_height) AS max
                   FROM laplace.pool_details_ytp pool_details_ytp_1)))
        )
 SELECT ytp_detail.yield_token,
    coin_gecko.token,
    (((((ytp_detail.balance_token)::bigint + (ytp_detail.balance_yield_token)::bigint))::double precision * coin_gecko.avg_price_usd) / ('100000000'::numeric)::double precision) AS liquidity
   FROM (ytp_detail
     JOIN laplace.coin_gecko ON (((ytp_detail.token_trait)::text = (coin_gecko.token)::text)))
  WITH NO DATA;
ALTER TABLE ONLY laplace.stacks_blockchain_events ALTER COLUMN id SET DEFAULT nextval('laplace.stacks_blockchain_events_id_seq'::regclass);
ALTER TABLE ONLY laplace.transaction_logs ALTER COLUMN id SET DEFAULT nextval('laplace.transaction_logs_id_seq'::regclass);
ALTER TABLE ONLY laplace.coin_gecko_archive
    ADD CONSTRAINT coin_gecko_archive_pkey PRIMARY KEY (token, "timestamp");
ALTER TABLE ONLY laplace.coin_gecko
    ADD CONSTRAINT coin_gecko_pkey PRIMARY KEY (token);
ALTER TABLE ONLY laplace.deployed_contracts
    ADD CONSTRAINT deployed_contracts_pkey PRIMARY KEY (deployer_address, tx_id, contract_name);
ALTER TABLE ONLY laplace.dynamic_ltv_crp
    ADD CONSTRAINT dynamic_ltv_crp_pkey PRIMARY KEY (contract_name, function_name, token, collateral, expiry, block_height);
ALTER TABLE ONLY laplace.dynamic_position_crp
    ADD CONSTRAINT dynamic_position_given_burn_key_crp_pkey PRIMARY KEY (contract_name, function_name, token, collateral, expiry, block_height);
ALTER TABLE ONLY laplace.dynamic_price_ytp
    ADD CONSTRAINT dynamic_price_ytp_pkey PRIMARY KEY (contract_name, function_name, yield_token, expiry, block_height);
ALTER TABLE ONLY laplace.dynamic_y_given_x_fwp
    ADD CONSTRAINT dynamic_y_given_x_fwp_pkey PRIMARY KEY (contract_name, function_name, token_x, token_y, weight_x, weight_y, block_height);
ALTER TABLE ONLY laplace.dynamic_yield_ytp
    ADD CONSTRAINT dynamic_yield_ytp_pkey PRIMARY KEY (function_name, contract_name, yield_token, expiry, block_height);
ALTER TABLE ONLY laplace.oracle_instant_fwp
    ADD CONSTRAINT oracle_instant_fwp_pkey PRIMARY KEY (token_y, token_x, contract_name, function_name, weight_y, weight_x, block_height);
ALTER TABLE ONLY laplace.oracle_instant_ytp
    ADD CONSTRAINT oracle_instant_ytp_pkey PRIMARY KEY (contract_name, function_name, yield_token, expiry, block_height);
ALTER TABLE ONLY laplace.oracle_resilient_fwp
    ADD CONSTRAINT oracle_resilient_fwp_pkey PRIMARY KEY (contract_name, function_name, token_x, token_y, weight_x, weight_y, block_height);
ALTER TABLE ONLY laplace.oracle_resilient_ytp
    ADD CONSTRAINT oracle_resilient_ytp_pkey PRIMARY KEY (contract_name, function_name, expiry, yield_token, block_height);
ALTER TABLE ONLY laplace.pool_details_crp
    ADD CONSTRAINT pool_details_crp_pkey PRIMARY KEY (contract_name, function_name, block_height, collateral, token, expiry);
ALTER TABLE ONLY laplace.pool_details_fwp
    ADD CONSTRAINT pool_details_fwp_pkey PRIMARY KEY (token_x, weight_y, weight_x, token_y, block_height, contract_name, function_name);
ALTER TABLE ONLY laplace.pool_details_ytp
    ADD CONSTRAINT pool_details_ytp_pkey PRIMARY KEY (expiry, block_height, yield_token);
ALTER TABLE ONLY laplace.static_data_fwp
    ADD CONSTRAINT pool_static_data_pkey PRIMARY KEY (contract_name, function_name, token_x, token_y, weight_x, weight_y);
ALTER TABLE ONLY laplace.reward_cycle_stats
    ADD CONSTRAINT reward_cycle_stats_pkey PRIMARY KEY (token, block_height);
ALTER TABLE ONLY laplace.staking_data
    ADD CONSTRAINT staking_data_pkey PRIMARY KEY (token, current_cycle, cycle, block_height);
ALTER TABLE ONLY laplace.static_data_ytp
    ADD CONSTRAINT static_data_ytp_pkey PRIMARY KEY (yield_token, expiry, contract_name, function_name);
ALTER TABLE ONLY laplace.sync_status
    ADD CONSTRAINT sync_status_pk PRIMARY KEY (key);
ALTER TABLE ONLY laplace.transaction_logs
    ADD CONSTRAINT transaction_logs_pkey PRIMARY KEY (id);
