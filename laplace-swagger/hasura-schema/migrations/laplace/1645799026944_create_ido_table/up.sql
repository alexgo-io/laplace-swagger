CREATE TABLE "laplace"."ido_register" (
  "sender_address" varchar NOT NULL,
  "block_height" integer NOT NULL,
  "ido_id" integer NOT NULL,
  "contract_call_contract_id" varchar NOT NULL,
  "apower" bigint NOT NULL,
  "payment_token" varchar NOT NULL,
  "registered_start" bigint NOT NULL,
  "registered_end" bigint NOT NULL,
  "amount" bigint,
  "tx_id" bytea NOT NULL,
  PRIMARY KEY ("block_height", "tx_id")
);

CREATE INDEX idx_ido_id_sender_address ON laplace.ido_register (ido_id, sender_address);

COMMENT ON TABLE "laplace"."ido_register" IS 'ALEX ido register results from alex-launchpad.clar';
