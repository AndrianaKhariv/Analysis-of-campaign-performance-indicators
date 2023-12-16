with f_res as(
select
	fabd.ad_date as _date,
	fabd.url_parameters  as _url,
  	coalesce(sum(fabd.spend),0) as spend,
  	coalesce(sum(fabd.impressions),0) as impressions,
  	coalesce(sum(fabd.reach),0) as reach,
  	coalesce(sum(fabd.clicks),0) as clicks,
  	coalesce(sum(fabd.leads),0) as leads,
  	coalesce(sum(fabd.value),0) as value
FROM
  facebook_ads_basic_daily fabd
inner join 
 facebook_campaign fc on fc.campaign_id =fabd.campaign_id 
GROUP BY
  fabd.ad_date,
  fabd.url_parameters
 union 
select 
	gabd.ad_date as _date,
	gabd.url_parameters  as _url,
  	coalesce(sum(gabd.spend),0) as spend,
  	coalesce(sum(gabd.impressions),0) as impressions,
  	coalesce(sum(gabd.reach),0) as reach,
  	coalesce(sum(gabd.clicks),0) as clicks,
  	coalesce(sum(gabd.leads),0) as leads,
  	coalesce(sum(gabd.value),0) as value
FROM
  google_ads_basic_daily gabd
group by
	gabd.ad_date ,
	gabd.url_parameters)
select _date,
	nullif (lower(substring(_url, 'utm_campaign=([^&#$]+)')),'nan') as utm_campaign,
  	sum(spend) as spend,
  	sum(impressions) as impressions,
  	sum(clicks) as clicks,
  	sum(value) as value,
  	case when sum(clicks)>0 then  (sum(spend) / sum(clicks)) else 0 end as CPC,
	case when sum(value)>0 then (sum(spend) / sum(value) * 1000) else 0 end AS CPM,
    case when sum(impressions)>0 then (sum(clicks) / sum(impressions)) else 0 end as CTR,
	case when sum(spend)>0 then (SUM(value)-sum(spend) / SUM(spend)*100) else 0 end AS ROMI
from f_res
group by
_date,
_url
