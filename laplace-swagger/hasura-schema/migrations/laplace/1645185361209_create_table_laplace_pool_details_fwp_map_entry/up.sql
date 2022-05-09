CREATE TABLE "laplace"."pool_details_fwp_map_entry" (
    "contract_name" varchar NOT NULL,
    "block_height" integer NOT NULL,
    "token_x" varchar NOT NULL,
    "token_y" varchar NOT NULL,
    "weight_x" bigint NOT NULL,
    "weight_y" bigint NOT NULL,
    "pool_token" varchar NOT NULL,
    "fee_to_address" varchar NOT NULL,
    "oracle_enabled" varchar NOT NULL,
    "balance_x" bigint NOT NULL,
    "balance_y" bigint NOT NULL,
    "fee_rate_x" bigint NOT NULL,
    "fee_rate_y" bigint NOT NULL,
    "fee_rebate" bigint NOT NULL,
    "oracle_average" bigint NOT NULL,
    "oracle_resilient" bigint NOT NULL,
    "total_supply" bigint NOT NULL,
    PRIMARY KEY (
        "contract_name",
        "block_height",
        "token_x",
        "token_y",
        "weight_x",
        "weight_y"
    )
);

COMMENT ON TABLE "laplace"."pool_details_fwp_map_entry" IS 'ALEX fixed-weight-pool time series data using map_entry api';
