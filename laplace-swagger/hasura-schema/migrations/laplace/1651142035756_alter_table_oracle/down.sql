alter table 
  "laplace"."simple_weight_pool_alex" 
drop 
  column "oracle_instant" bigint NOT NULL default 0,
drop 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."latest_simple_weight_pool_alex" 
drop 
  column "oracle_instant" bigint NOT NULL default 0,
drop 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."fixed_weight_pool_v1_01" 
drop 
  column "oracle_instant" bigint NOT NULL default 0,
drop 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."latest_fixed_weight_pool_v1_01" 
drop 
  column "oracle_instant" bigint NOT NULL default 0,
drop 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."pool_stats" 
drop 
  column "oracle_instant" bigint NOT NULL default 0,
drop 
  column "latest_oracle_resilient" bigint NOT NULL default 0;

alter table 
  "laplace"."latest_pool_stats" 
drop 
  column "oracle_instant" bigint NOT NULL default 0,
drop 
  column "latest_oracle_resilient" bigint NOT NULL default 0;
