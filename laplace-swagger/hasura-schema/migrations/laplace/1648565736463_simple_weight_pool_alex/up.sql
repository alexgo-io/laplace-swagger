CREATE TABLE "laplace"."simple_weight_pool_alex" (
  "block_height" INTEGER NOT NULL,
  "burn_block_time" INTEGER NOT NULL,
  "token_x" VARCHAR NOT NULL,
  "token_y" VARCHAR NOT NULL,
  "balance_x" BIGINT NOT NULL,
  "balance_y" BIGINT NOT NULL,
  "start_block" NUMERIC NOT NULL,
  "end_block" NUMERIC NOT NULL,
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
    "block_height"
  )
);

CREATE INDEX idx_simple_weight_pool_alex_blockheight ON laplace.simple_weight_pool_alex (block_height);

COMMENT ON TABLE "laplace"."simple_weight_pool_alex" IS 'Contract simple_weight_pool_alex per-block data';

CREATE TABLE "laplace"."latest_simple_weight_pool_alex" (
  "block_height" INTEGER NOT NULL,
  "burn_block_time" INTEGER NOT NULL,
  "token_x" VARCHAR NOT NULL,
  "token_y" VARCHAR NOT NULL,
  "balance_x" BIGINT NOT NULL,
  "balance_y" BIGINT NOT NULL,
  "start_block" NUMERIC NOT NULL,
  "end_block" NUMERIC NOT NULL,
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
  PRIMARY KEY ("token_x", "token_y")
);

COMMENT ON TABLE "laplace"."latest_simple_weight_pool_alex" IS 'Contract simple_weight_pool_alex latest-block data';
