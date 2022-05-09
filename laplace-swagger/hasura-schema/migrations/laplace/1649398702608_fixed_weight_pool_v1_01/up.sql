CREATE TABLE "laplace"."fixed_weight_pool_v1_01" (
  "block_height" INTEGER NOT NULL,
  "burn_block_time" INTEGER NOT NULL,
  "token_x" VARCHAR NOT NULL,
  "token_y" VARCHAR NOT NULL,
  "weight_x" BIGINT NOT NULL,
  "weight_y" BIGINT NOT NULL,
  "balance_x" BIGINT NOT NULL,
  "balance_y" BIGINT NOT NULL,
  "fee_rate_x" BIGINT NOT NULL,
  "fee_rate_y" BIGINT NOT NULL,
  "fee_rebate" BIGINT NOT NULL,
  "fee_to_address" VARCHAR NOT NULL,
  "oracle_average" BIGINT NOT NULL,
  "oracle_enabled" BOOLEAN NOT NULL,
  "oracle_resilient" BIGINT NOT NULL,
  "pool_token" VARCHAR NOT NULL,
  "total_supply" BIGINT NOT NULL,
  "est_token_y_price" BIGINT NOT NULL,
  "est_pool_token_price" BIGINT NOT NULL,
  "sync_at" timestamptz NOT NULL,
  PRIMARY KEY (
    "token_x",
    "token_y",
    "weight_x",
    "weight_y",
    "block_height"
  )
);

CREATE INDEX idx_fixed_weight_pool_v1_01_blockheight ON laplace.fixed_weight_pool_v1_01 (block_height);

COMMENT ON TABLE "laplace"."fixed_weight_pool_v1_01" IS 'Contract fixed_weight_pool_v1_01 per-block data';

CREATE TABLE "laplace"."latest_fixed_weight_pool_v1_01" (
  "block_height" INTEGER NOT NULL,
  "burn_block_time" INTEGER NOT NULL,
  "token_x" VARCHAR NOT NULL,
  "token_y" VARCHAR NOT NULL,
  "weight_x" BIGINT NOT NULL,
  "weight_y" BIGINT NOT NULL,
  "balance_x" BIGINT NOT NULL,
  "balance_y" BIGINT NOT NULL,
  "fee_rate_x" BIGINT NOT NULL,
  "fee_rate_y" BIGINT NOT NULL,
  "fee_rebate" BIGINT NOT NULL,
  "fee_to_address" VARCHAR NOT NULL,
  "oracle_average" BIGINT NOT NULL,
  "oracle_enabled" BOOLEAN NOT NULL,
  "oracle_resilient" BIGINT NOT NULL,
  "pool_token" VARCHAR NOT NULL,
  "total_supply" BIGINT NOT NULL,
  "est_token_y_price" BIGINT NOT NULL,
  "est_pool_token_price" BIGINT NOT NULL,
  "sync_at" timestamptz NOT NULL,
  PRIMARY KEY ("token_x", "token_y", "weight_x", "weight_y")
);

COMMENT ON TABLE "laplace"."latest_fixed_weight_pool_v1_01" IS 'Contract fixed_weight_pool_v1_01 latest-block data';
