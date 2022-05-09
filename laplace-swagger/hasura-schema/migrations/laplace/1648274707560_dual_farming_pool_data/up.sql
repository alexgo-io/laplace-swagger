ALTER TABLE
  "laplace"."alex_reserve_pools"
ADD
  COLUMN "dual_yield_token_deployer_address" VARCHAR,
ADD
  COLUMN "dual_yield_token_name" VARCHAR,
ADD
  COLUMN "dual_yield_token_multiplier" BIGINT;
