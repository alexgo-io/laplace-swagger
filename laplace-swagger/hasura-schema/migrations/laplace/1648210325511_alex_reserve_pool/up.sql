CREATE TABLE "laplace"."alex_reserve_pools" (
  "token_deployer_address" VARCHAR NOT NULL,
  "token_name" VARCHAR NOT NULL,
  "block_height" INTEGER NOT NULL,
  "activation_block" INTEGER NOT NULL,
  "reward_cycle_length" INTEGER NOT NULL,
  "token_halving_cycle" INTEGER NOT NULL,
  "current_cycle" INTEGER NOT NULL,
  "reserved_balance" BIGINT NOT NULL,
  "coinbase_amount_1" BIGINT NOT NULL,
  "coinbase_amount_2" BIGINT NOT NULL,
  "coinbase_amount_3" BIGINT NOT NULL,
  "coinbase_amount_4" BIGINT NOT NULL,
  "coinbase_amount_5" BIGINT NOT NULL,
  "apower_multiplier" BIGINT NOT NULL,
  "staking_stats" JSONB NOT NULL,
  "sync_at" timestamptz NOT NULL,
  PRIMARY KEY (
    "token_deployer_address",
    "token_name",
    "block_height"
  )
);

CREATE INDEX idx_alex_reserve_pools_blockheight ON laplace.alex_reserve_pools (block_height);

COMMENT ON COLUMN "laplace"."alex_reserve_pools"."staking_stats" IS 'array of 32 uint, starting from current cycle';

COMMENT ON TABLE "laplace"."alex_reserve_pools" IS 'Contract alex-reserve-pool per-block data';
