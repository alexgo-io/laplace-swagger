DROP INDEX laplace.idx_contract_calls_sender_nonce;

CREATE INDEX idx_contract_calls_sender ON laplace.contract_calls (sender_address);

ALTER TABLE
  laplace.contract_calls DROP COLUMN nonce;
