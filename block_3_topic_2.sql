with f_res as(
select
	fc.campaign_name as campaign,
	fa.adset_name as adset,
  	sum(fabd.spend) as spend,
  	sum(fabd.value) as value
FROM
  facebook_ads_basic_daily fabd
inner join 
 facebook_campaign fc on fc.campaign_id =fabd.campaign_id 
inner join
 facebook_adset fa on fa.adset_id = fabd.adset_id 
GROUP BY
  fc.campaign_name,
  fa.adset_name 
  union 
select 
	gabd.campaign_name as campaign,
	gabd.adset_name as adset,
  	sum(gabd.spend) as spend,
  	sum(gabd.value) as value
FROM
  google_ads_basic_daily gabd
group by
	gabd.campaign_name,
	gabd.adset_name 
)
select 
f_res.campaign, f_res.adset,
Sum(f_res.spend) as sp,
cast(SUM(f_res.value)as float) / cast (SUM(f_res.spend) AS FLOAT)*100 AS ROMI
from f_res
group by
f_res.campaign,f_res.adset
having 
sum(f_res.spend)>500000
ORDER BY ROMI DESC
limit 1

