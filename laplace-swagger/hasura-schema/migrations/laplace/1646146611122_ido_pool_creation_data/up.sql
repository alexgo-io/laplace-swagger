CREATE TABLE "laplace"."ido_pool_creation" (
    "tx_id" text NOT NULL,
    "block_height" integer NOT NULL,
    "ido_token" text NOT NULL,
    "payment_token" text NOT NULL,
    "ido_owner" text NOT NULL,
    "claim_end_height" integer NOT NULL,
    "activation_threshold" Integer NOT NULL,
    "ido_tokens_per_ticket" integer NOT NULL,
    "registration_start_height" integer NOT NULL,
    "price_per_ticket_in_fixed" int8 NOT NULL,
    "registration_end_height" integer NOT NULL,
    "apower_per_ticket_in_fixed" int8 NOT NULL,
    "transaction_result_type" text NOT NULL,
    "result_value" integer NOT NULL,
    PRIMARY KEY (
        "tx_id",
        "ido_token",
        "payment_token",
        "ido_owner",
        "claim_end_height",
        "activation_threshold",
        "ido_tokens_per_ticket",
        "registration_start_height",
        "registration_end_height",
        "apower_per_ticket_in_fixed"
    )
);

COMMENT ON TABLE "laplace"."ido_pool_creation" IS 'Tracks the data of IDO pools at initialization';

CREATE INDEX idx_ido_pool_creation_blockheight ON laplace.ido_pool_creation (block_height);
