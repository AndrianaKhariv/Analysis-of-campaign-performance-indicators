SELECT
  ad_date,
  campaign_id,
  SUM(spend) AS total_spend,
  Sum(impressions) AS impressions,
  SUm(clicks) AS clicks,
  SUM(value) AS total_value,
  sum(spend) / count(clicks) as CPC,
  cast(sum(spend) as float) / cast(sum(value) as float) * 1000 AS CPM,
  cast(sum(clicks)as float) / cast(sum(impressions)as float) as CTR,
  cast(SUM(value)as float) / cast (SUM(spend) AS FLOAT)*100 AS ROMI
FROM
  facebook_ads_basic_daily
where 
 spend > 0
  GROUP BY
  ad_date,
  campaign_id
ORDER BY
  ad_date DESC