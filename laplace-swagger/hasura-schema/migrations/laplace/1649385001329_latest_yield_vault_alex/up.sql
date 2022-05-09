CREATE TABLE "laplace"."latest_yield_vault_alex" (
  "token_name" varchar NOT NULL,
  "block_height" integer NOT NULL,
  "burn_block_time" integer NOT NULL,
  "current_cycle" bigint NOT NULL,
  "pool_user_id" bigint NOT NULL,
  "pool_total_staked_stats" JSONB NOT NULL,
  "pool_to_return_stats" JSONB NOT NULL,
  "pool_future_volume_stats" JSONB NOT NULL,
  "apys" JSONB NOT NULL,
  "sync_at" timestamptz NOT NULL,
  PRIMARY KEY ("token_name")
);

COMMENT ON TABLE "laplace"."latest_yield_vault_alex" IS 'auto alex yield vault';
