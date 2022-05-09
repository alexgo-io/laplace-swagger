CREATE TABLE "laplace"."token_stats" (
  "token_name" varchar NOT NULL,
  "decimals" numeric NOT NULL,
  "total_supply" numeric NOT NULL,
  "block_height" numeric NOT NULL,
  PRIMARY KEY ("token_name", "block_height")
);

COMMENT ON TABLE "laplace"."token_stats" IS 'ALEX token stats using read-only call';
