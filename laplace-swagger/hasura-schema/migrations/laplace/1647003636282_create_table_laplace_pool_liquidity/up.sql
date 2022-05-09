CREATE TABLE "laplace"."pool_liquidity" (
  "token_name" varchar NOT NULL, 
  "volume_24h" float8 NOT NULL, 
  "volume_7d" float8 NOT NULL, 
  "item_fees" float8 NOT NULL, 
  "liquidity" float8 NOT NULL, 
  "apr" float8 NOT NULL, 
  PRIMARY KEY ("token_name")
);
COMMENT ON TABLE "laplace"."pool_liquidity" IS 'ALEX pool liquidity data';
