alter table "laplace"."pool_stats"
drop column "fee_to_address" varchar not null,
drop column "oracle_enabled" bigint not null,
drop column "oracle_average" bigint not null,
drop column "oracle_resilient" bigint not null,
drop column "est_token_y_price" bigint not null,
drop column "est_pool_token_price" bigint not null;
