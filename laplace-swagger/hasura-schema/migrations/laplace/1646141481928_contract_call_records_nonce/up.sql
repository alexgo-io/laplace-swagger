DROP INDEX laplace.idx_contract_calls_sender;

ALTER TABLE
  laplace.contract_calls
ADD
  COLUMN nonce integer NOT NULL;

CREATE INDEX idx_contract_calls_sender_nonce ON laplace.contract_calls (sender_address, nonce);
