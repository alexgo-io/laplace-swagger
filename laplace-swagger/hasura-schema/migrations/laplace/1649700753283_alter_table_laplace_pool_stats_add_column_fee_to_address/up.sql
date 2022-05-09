alter table
  "laplace"."pool_stats"
add
  column "fee_to_address" varchar not null default '',
add
  column "oracle_enabled" bigint not null default -1,
add
  column "oracle_average" bigint not null default -1,
add
  column "oracle_resilient" bigint not null default -1,
add
  column "est_token_y_price" bigint not null default -1,
add
  column "est_pool_token_price" bigint not null default -1;
