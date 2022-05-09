CREATE TABLE "laplace"."pool_volume" (
  "pool_name" varchar NOT NULL, 
  "time_range" varchar NOT NULL, 
  "token_x_volume" float8 NOT NULL, 
  "token_y_volume" float8 NOT NULL, 
  "total_volume" float8 NOT NULL, 
  PRIMARY KEY ("pool_name", "time_range")
);

COMMENT ON TABLE "laplace"."pool_volume" IS 'ALEX pool volume data';
