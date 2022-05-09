create index if not exists coin_gecko_archive_coin_gecko_id_index
    on laplace.coin_gecko_archive (coin_gecko_id);

create index if not exists coin_gecko_archive_timestamp_index
    on laplace.coin_gecko_archive (timestamp);

create index if not exists coin_gecko_archive_token_timestamp_index
    on laplace.coin_gecko_archive (token, timestamp);

