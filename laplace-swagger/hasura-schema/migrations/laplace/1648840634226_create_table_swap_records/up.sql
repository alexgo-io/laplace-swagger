CREATE TABLE "laplace"."swap_records" (
  "block_height" numeric NOT NULL, 
  "burn_block_time" numeric NOT NULL, 
  "tx_id" varchar NOT NULL, 
  "tx_index" numeric NOT NULL, 
  "event_index" numeric NOT NULL, 
  "contract_id" varchar NOT NULL, 
  "function_name" varchar NOT NULL, 
  "pool_token_deployer_address" varchar NOT NULL, 
  "pool_token_name" varchar NOT NULL, 
  "pool_action" varchar NOT NULL, 
  "token_x" varchar NOT NULL, 
  "token_x_amount" bigint NOT NULL, 
  "token_x_fee" bigint NOT NULL, 
  "token_x_fee_rebate" bigint NOT NULL, 
  "token_y" varchar NOT NULL, 
  "token_y_amount" bigint NOT NULL, 
  "token_y_fee" bigint NOT NULL, 
  "token_y_fee_rebate" bigint NOT NULL, 
  PRIMARY KEY ("tx_id", "event_index")
);
COMMENT ON TABLE "laplace"."swap_records" IS 'ALEX swap records';
CREATE INDEX "burn_block_time_index" on "laplace"."swap_records" using btree ("burn_block_time");
CREATE INDEX "block_height_index" on "laplace"."swap_records" using btree ("block_height");
CREATE INDEX "pool_token_index" on "laplace"."swap_records" using btree (
  "pool_token_name", "pool_token_deployer_address"
);
