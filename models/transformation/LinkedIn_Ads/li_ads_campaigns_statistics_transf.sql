
{{
    config(
        materialized='table'
    )
}}


with li_ads_ad_analytics_stats_campaign_raw as (

    SELECT 
        campaign_id ,Date(Min(day)) AS start_date,CAST(ROUND(SUM(cost_in_usd),2) AS NUMERIC) AS Spent, SUM(approximate_unique_impressions) AS approximate_unique_impressions,
       ROUND (CAST(( SUM(cost_in_usd)/SUM(approximate_unique_impressions)*1000) AS NUMERIC),3) AS CPM, CAST(SUM(clicks) AS NUMERIC) AS clicks, CAST (SUM(impressions) AS NUMERIC) AS impressions,
        ROUND (CAST(( SUM(clicks) / SUM(impressions)) AS NUMERIC),3) AS CTR,ROUND( CAST(( SUM(cost_in_usd)/SUM(clicks)) AS NUMERIC),3) AS CPC , 
        SUM(external_website_conversions) AS conversions, ROUND (IF  (SUM(external_website_conversions) > 0,SUM(cost_in_usd)/SUM(external_website_conversions),0) ,3)AS Cost_per_conversion,
         SUM(COALESCE(one_click_leads,0)) AS leads, ROUND (IF (SUM(one_click_leads) > 0,SUM(cost_in_usd)/SUM(one_click_leads),0),3) AS CPL,SUM(comments) AS comments, 
        SUM(COALESCE(likes,0)) AS likes,SUM(shares) AS shares, CAST(SUM(total_engagements) AS NUMERIC ) AS total_engagements


    FROM 
        {{ ref('li_ads_ad_analytics_by_campaign_raw')}}

    Group By campaign_id
    
)

SELECT *
FROM li_ads_ad_analytics_stats_campaign_raw
