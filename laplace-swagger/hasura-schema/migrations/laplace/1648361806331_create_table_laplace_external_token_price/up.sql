CREATE TABLE "laplace"."external_token_price" (
  "token_name" varchar NOT NULL, 
  "value" numeric NOT NULL, 
  PRIMARY KEY ("token_name")
);
COMMENT ON TABLE "laplace"."external_token_price" IS 'External token price fetched using read-only calls';
