CREATE TABLE laplace.transaction_logs (
    tx_id character varying NOT NULL,
    block_height integer NOT NULL,
    contract_id character varying NOT NULL,
    function_name character varying NOT NULL,
    sender character varying NOT NULL,
    sold_token character varying,
    bought_token character varying,
    time_stamp timestamp with time zone NOT NULL,
    id integer NOT NULL,
    tx_cost bigint,
    sold_quantity numeric,
    bought_quantity numeric
);
COMMENT ON TABLE laplace.transaction_logs IS 'ALEX transaction logs for all relevant ALEX contract';
CREATE SEQUENCE laplace.transaction_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE laplace.transaction_logs_id_seq OWNED BY laplace.transaction_logs.id;
