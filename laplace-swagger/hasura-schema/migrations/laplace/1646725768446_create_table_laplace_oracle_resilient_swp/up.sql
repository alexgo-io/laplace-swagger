CREATE TABLE "laplace"."oracle_resilient_swp" (
  "contract_name" VARCHAR NOT NULL, 
  "function_name" VARCHAR NOT NULL, 
  "token_x" VARCHAR NOT NULL, 
  "token_y" VARCHAR NOT NULL, 
  "value" BIGINT NOT NULL, 
  "block_height" INTEGER NOT NULL, 
  PRIMARY KEY (
    "contract_name", "function_name", 
    "token_x", "token_y", "block_height"
  )
);
COMMENT ON TABLE "laplace"."oracle_resilient_swp" IS 'ALEX simple-weight-pool oracle-resilient price time series data';
