alter table 
  "laplace"."simple_weight_pool_alex" 
add 
  column "oracle_instant" bigint NOT NULL default 0,
add 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."latest_simple_weight_pool_alex" 
add 
  column "oracle_instant" bigint NOT NULL default 0,
add 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."fixed_weight_pool_v1_01" 
add 
  column "oracle_instant" bigint NOT NULL default 0,
add 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."latest_fixed_weight_pool_v1_01" 
add 
  column "oracle_instant" bigint NOT NULL default 0,
add 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."pool_stats" 
add 
  column "oracle_instant" bigint NOT NULL default 0,
add 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."latest_pool_stats" 
add 
  column "oracle_instant" bigint NOT NULL default 0,
add 
  column "latest_oracle_resilient" bigint NOT NULL default 0;
