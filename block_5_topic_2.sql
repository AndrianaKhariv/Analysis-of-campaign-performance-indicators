with f_res as(
select
	fabd.ad_date as _date,
	fabd.url_parameters  as _url
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
	gabd.url_parameters  as _url
FROM
  google_ads_basic_daily gabd
group by
	gabd.ad_date ,
	gabd.url_parameters)
select _date,
	decode_url_part(lower(substring(_url, 'utm_campaign=([^&#$]+)'))) as utm_campaign
from f_res
group by
_date, 
_url
