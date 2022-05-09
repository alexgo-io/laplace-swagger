DROP INDEX IF EXISTS laplace.idx_token_blockheight;
CREATE INDEX idx_token_blockheight
    ON laplace.staking_data (token, block_height);

DROP VIEW IF EXISTS laplace.latest_staking_data;
CREATE VIEW laplace.latest_staking_data AS
SELECT laplace.staking_data.token, laplace.staking_data.current_cycle, laplace.staking_data.cycle, laplace.staking_data.block_height, laplace.staking_data.staking_stats, laplace.staking_data.coinbase_amount, laplace.staking_data.apr
FROM laplace.staking_data
JOIN (
        SELECT  token, max(block_height) as block_height
        FROM laplace.staking_data
        GROUP BY token
    ) as maxes_by_token
ON laplace.staking_data.token = maxes_by_token.token and laplace.staking_data.block_height = maxes_by_token.block_height
ORDER BY laplace.staking_data.cycle ASC;
