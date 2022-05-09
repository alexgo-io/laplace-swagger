drop view if exists laplace.current_token_price;
create view laplace.current_token_price as
(with coin_geiko as (
    select case
               when token = 'token-usda' then 'token-wusda'
               when token = 'token-mia' then 'token-wmia'
               else token
               end as token,
           avg_price_usd
    from laplace.coin_gecko
)
   , alex as (
    select token,
           avg_price_usd
    from laplace.alex_usd_pricing
    where token = 'age000-governance-token'
)
   , wban as (
    select token,
           coalesce(avg_price_usd, 1) as avg_price_usd
    from laplace.oracle_token_price
), diko as (
    select token,
           avg_price_usd
    from (values ('token-wdiko', 0.19504449)) as t (token, avg_price_usd)
    )
   , all_result as (
    select *
    from coin_geiko
    union all
    select *
    from alex
    union all
    select *
    from wban
   union all
   select *
   from diko
)

select *
from all_result
    );
