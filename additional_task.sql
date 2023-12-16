SELECT
  campaign_id,
  cast(SUM(value)as float) / cast(SUM(spend) AS FLOAT)*100 AS ROMI
FROM
  facebook_ads_basic_daily
GROUP BY
  campaign_id
HAVING
  SUM(spend) > 500000
ORDER BY
  ROMI DESC
limit 1