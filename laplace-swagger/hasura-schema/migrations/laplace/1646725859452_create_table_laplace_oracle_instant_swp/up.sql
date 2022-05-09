CREATE TABLE "laplace"."oracle_instant_swp" (
  "contract_name" VARCHAR NOT NULL, 
  "function_name" VARCHAR NOT NULL, 
  "token_x" VARCHAR NOT NULL, 
  "token_y" VARCHAR NOT NULL, 
  "block_height" INTEGER NOT NULL, 
  "value" BIGINT NOT NULL, 
  PRIMARY KEY (
    "contract_name", "function_name", 
    "token_x", "token_y", "block_height"
  )
);
COMMENT ON TABLE "laplace"."oracle_instant_swp" IS 'ALEX simple-weight-pool oracle-instant price time series data';
