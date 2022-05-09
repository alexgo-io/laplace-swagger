CREATE TABLE "laplace"."pool_stats" (
  "pool_token" varchar NOT NULL,
  "token_x" varchar NOT NULL,
  "token_y" varchar NOT NULL,
  "balance_x" numeric NOT NULL,
  "balance_y" numeric NOT NULL,
  "total_supply" numeric NOT NULL,
  "fee_rate_x" numeric NOT NULL,
  "fee_rate_y" numeric NOT NULL,
  "fee_rebate" numeric NOT NULL,
  "block_height" numeric NOT NULL,
  "volume_x_24h" numeric NOT NULL,
  "volume_y_24h" numeric NOT NULL,
  "volume_24h" numeric NOT NULL,
  "volume_x_7d" numeric NOT NULL,
  "volume_y_7d" numeric NOT NULL,
  "volume_7d" numeric NOT NULL,
  "fee_rebate_x_24h" numeric NOT NULL,
  "fee_rebate_y_24h" numeric NOT NULL,
  "fee_rebate_24h" numeric NOT NULL,
  "fee_rebate_x_7d" numeric NOT NULL,
  "fee_rebate_y_7d" numeric NOT NULL,
  "fee_rebate_7d" numeric NOT NULL,
  "liquidity" numeric NOT NULL,
  "apr_7d" numeric NOT NULL,
  "burn_block_time" numeric NOT NULL,
  "sync_at" timestamptz NOT NULL,
  PRIMARY KEY ("pool_token", "block_height")
);

CREATE INDEX idx_pool_stats_blockheight ON laplace.pool_stats (block_height);

COMMENT ON TABLE "laplace"."pool_stats" IS 'ALEX pool status ';
