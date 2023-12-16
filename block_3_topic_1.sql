with f_res as(
select
	fabd.ad_date as _date,
	fc.campaign_name as campaign,
  	sum(fabd.spend) as spend,
  	sum(fabd.impressions) as impressions,
  	sum(fabd.reach) as reach,
  	sum(fabd.clicks) as clicks,
  	sum(fabd.leads) as leads,
  	sum(fabd.value) as value
FROM
  facebook_ads_basic_daily fabd
inner join 
 facebook_campaign fc on fc.campaign_id =fabd.campaign_id 
GROUP BY
  fabd.ad_date,
  fc.campaign_name 
ORDER BY
  fabd.ad_date desc),
g_res as(
select 
	gabd.ad_date as _date,
	gabd.campaign_name as campaign,
  	sum(gabd.spend) as spend,
  	sum(gabd.impressions) as impressions,
  	sum(gabd.reach) as reach,
  	sum(gabd.clicks) as clicks,
  	sum(gabd.leads) as leads,
  	sum(gabd.value) as value
FROM
  google_ads_basic_daily gabd
group by
	gabd.ad_date ,
	gabd.campaign_name 
)
select 
from f_res
