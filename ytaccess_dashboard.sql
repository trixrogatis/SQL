--CREATE OR REPLACE MATERIALIZED VIEW `Adverity_GoogleB2C.MView_Dashboard_Youtube-Access` AS

  /*
    Materialized view created by: Beatriz Rogatis (beatrizrogatis@me.com)
    Objective:consolidate data information on Youtube Access campaign for dataviz
    Adverity connection: N/A
    Spreadsheets connection: N/A
    Looker Studio connection: https://lookerstudio.google.com/s/hw8CyT6XCwo
  */

  -- General select geral from consolidated table

  SELECT

  date,

  CASE -- week filter
    WHEN date BETWEEN '2023-10-02' AND '2023-10-08' THEN 'Week 01 (Oct 02 - Oct 08)'
    WHEN date BETWEEN '2023-10-09' AND '2023-10-15' THEN 'Week 02 (Oct 09 - Oct 15)'
    WHEN date BETWEEN '2023-10-16' AND '2023-10-22' THEN 'Week 03 (Oct 16 - Oct 22)'
    WHEN date BETWEEN '2023-10-23' AND '2023-10-29' THEN 'Week 04 (Oct 23 - Oct 29)'
    WHEN date BETWEEN '2023-10-30' AND '2023-11-05' THEN 'Week 05 (Oct 30 - Nov 05)'
    WHEN date BETWEEN '2023-11-06' AND '2023-11-12' THEN 'Week 06 (Nov 06 - Nov 12)'
    WHEN date BETWEEN '2023-11-13' AND '2023-11-19' THEN 'Week 07 (Nov 13 - Nov 19)'
    WHEN date BETWEEN '2023-11-20' AND '2023-11-26' THEN 'Week 08 (Nov 20 - Nov 26)'
    WHEN date BETWEEN '2023-11-27' AND '2023-12-03' THEN 'Week 09 (Nov 27 - Dec 03)'
    ELSE 'NA'
  END AS week,
  
  channel,
  'Awareness' as funnel,

  CASE -- Ad_type filter
    -- Meta
    WHEN channel = 'Meta' THEN 'Brand Awareness'
    -- TikTok
    WHEN channel = 'TikTok' THEN 'Video Views + TTcX'
  END AS ad_type,

  IFNULL(SPLIT(adset_name,'_')[SAFE_OFFSET(10)],"-") audience,
  IFNULL(SPLIT(ad_name,'_')[SAFE_OFFSET(14)],"-") ad_format,

  media_type,
  account_name,
  campaign_name,
  adset_name,
  ad_name,
  currency,
  subchannel,
  SUM(investment) AS investment,
  SUM(investment_usd) AS investment_usd,
  SUM(impressions) AS impressions,
  SUM(impressions_video) AS impressions_video,
  SUM(clicks) AS clicks,
  SUM(video_views) AS views,
  SUM(views_25) AS views_25,
  SUM(views_50) AS views_50,
  SUM(views_75) AS views_75,
  SUM(views_100) AS views_100,
  SUM(comments) AS comments,
  SUM(reactions) AS reactions,
  SUM(shares) AS shares

  FROM
    `blinks-bi.Adverity_GoogleB2C.1_Table_Consolidated-Data`
  WHERE
    iniciative = "Youtube-Access"
    AND date BETWEEN '2023-10-25' AND "2023-12-31"
  GROUP BY
    date,
    week,
    channel,
    funnel,
    ad_type,
    audience,
    ad_format,
    media_type,
    account_name,
    campaign_name,
    adset_name,
    ad_name,
    currency,
    subchannel

  --;
