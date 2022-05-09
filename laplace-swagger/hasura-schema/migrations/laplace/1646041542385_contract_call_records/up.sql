CREATE TABLE "laplace"."contract_calls" (
  "block_height" integer NOT NULL,
  "tx_id" bytea NOT NULL,
  "sender_address" character varying NOT NULL,
  "contract_id" character varying NOT NULL,
  "function_name" character varying NOT NULL,
  "arg1" character varying,
  "arg2" character varying,
  "arg3" character varying,
  "arg4" character varying,
  "arg5" character varying,
  "contract_name" character varying NOT NULL,
  "anchor_mode" smallint NOT NULL,
  "fee_rate" bigint NOT NULL,
  "execution_cost_read_count" bigint NOT NULL,
  "execution_cost_read_length" bigint NOT NULL,
  "execution_cost_runtime" bigint NOT NULL,
  "execution_cost_write_count" bigint NOT NULL,
  "execution_cost_write_length" bigint NOT NULL,
  "function_args" JSONB NOT NULL,
  "transaction_result_type" character varying NOT NULL,
  "transaction_result" JSONB NOT NULL,
  "events" JSONB NOT NULL,
  PRIMARY KEY ("block_height", "tx_id")
);

CREATE INDEX idx_contract_calls_signature ON laplace.contract_calls (
  contract_id,
  function_name,
  arg1,
  arg2,
  arg3,
  arg4,
  arg5
);

CREATE INDEX idx_contract_calls_sender ON laplace.contract_calls (sender_address);

COMMENT ON TABLE "laplace"."contract_calls" IS 'Contract function calls index by function signature';
