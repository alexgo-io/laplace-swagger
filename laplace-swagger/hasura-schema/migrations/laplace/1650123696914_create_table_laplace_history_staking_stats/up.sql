CREATE TABLE "laplace"."history_staking_stats" (
  "token" varchar NOT NULL,
  "cycle" integer NOT NULL,
  "total_staked" numeric NOT NULL,
  "sync_at_block_height" integer NOT NULL,
  "sync_at" timestamptz NOT NULL,
  PRIMARY KEY ("token", "cycle")
);

COMMENT ON TABLE "laplace"."history_staking_stats" IS 'ALEX staking statistics history';
