CREATE TABLE "laplace"."synced_blocks" (
  "block_height" integer NOT NULL,
  "burn_block_height" integer NOT NULL,
  "burn_block_time" integer NOT NULL,
  "burn_block_hash" bytea NOT NULL,
  "miner_txid" bytea NOT NULL,
  "block_hash" bytea NOT NULL,
  "parent_block_hash" bytea NOT NULL,
  "index_block_hash" bytea NOT NULL,
  "parent_index_block_hash" bytea NOT NULL,
  "parent_microblock_hash" bytea NOT NULL,
  "parent_microblock_sequence" integer NOT NULL,
  PRIMARY KEY ("block_height")
);

COMMENT ON TABLE "laplace"."synced_blocks" IS 'blocks synced by block pollers';
