with f_res as(
select
	date(date_trunc('month', fabd.ad_date)) as  ad_month,
	nullif (decode_url_part(lower(substring(fabd.url_parameters, 'utm_campaign=([^&#$]+)'))),'nan') as utm_campaign,
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
	date(date_trunc('month', gabd.ad_date)) as  ad_month,
	nullif (lower(substring(gabd.url_parameters, 'utm_campaign=([^&#$]+)')),'nan') as utm_campaign,
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
select  
	ad_month,
	utm_campaign,
  	sum(spend) as spend,
  	sum(impressions) as impressions,
  	sum(clicks) as clicks,
  	sum(value) as value,
  	case when sum(clicks)>0 then  (sum(spend)::numeric  / sum(clicks)) else 0 end as CPC,
	case when sum(value)>0 then (sum(spend)::numeric  / sum(value) * 1000) else 0 end AS CPM,
    case when sum(impressions)>0 then (sum(clicks) / sum(impressions)) else 0 end as CTR,
	case when sum(spend)>0 then (SUM(value)-sum(spend) / SUM(spend)*100) else 0 end AS ROMI,	
	(case when sum(value)>0 then (sum(spend)::numeric  / sum(value) * 1000) else 0 end - 
		lag(case when sum(value)>0 then (sum(spend)::numeric  / sum(value) * 1000) else 0 end) 
		over (
			partition by utm_campaign order by ad_month)) * 100 / 
			lag(case when sum(value)>0 then (sum(spend)::numeric  / sum(value) * 1000) else 0 end) 
			over (
				partition by utm_campaign order by ad_month) as diff_cpm,
	(case when sum(impressions)>0 then (sum(clicks) / sum(impressions)) else 0 end  - 
		lag(case when sum(impressions)>0 then (sum(clicks) / sum(impressions)) else 0 end ) 
		over (
			partition by utm_campaign order by ad_month)) * 100 / 
			lag(case when sum(impressions)>0 then (sum(clicks) / sum(impressions)) else 0 end ) 
			over (
				partition by utm_campaign order by ad_month) as diff_ctr,
	(case when sum(spend)>0 then (SUM(value)-sum(spend) / SUM(spend)*100) else 0 end - 
		lag(case when sum(spend)>0 then (SUM(value)-sum(spend) / SUM(spend)*100) else 0 end) 
		over (
			partition by utm_campaign order by ad_month)) * 100 / 
			lag(case when sum(spend)>0 then (SUM(value)-sum(spend) / SUM(spend)*100) else 0 end) 
			over (
				partition by utm_campaign order by ad_month) as diff_romi
from 
f_res
group by
ad_month,
utm_campaign