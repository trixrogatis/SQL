--CREATE OR REPLACE MATERIALIZED VIEW `Adverity_GoogleB2C.MView_Dashboard_DataValidation` AS

  /*
    Materialized view created by: Beatriz Rogatis (beatrizrogatis@me.com)
    Materialized view edited by: Wallace Oliveira (---)
    Objective: Feed the data validation dashboard
    Adverity connection (if available): NA
    Spreadsheets connection (if available): https://docs.google.com/spreadsheets/d/1GyqDqS8bKMtROxkxPlBGQ3kgmEwn423Kx9OM5-cxiY0/edit#gid=1882032664
    Looker Studio connection (if available): https://lookerstudio.google.com/u/0/reporting/f6a92ae4-67e3-48ed-b8e4-034cf07ab5d2/page/ePfZD/edit
  */

  -- General select from Consolidated data

  SELECT
    date,
    DATE_TRUNC(date, WEEK(SUNDAY)) AS last_sunday,
    week,
    year,
    account_id,
    account_name,

    CASE
      WHEN channel IN('GDN', 'SEM', 'Youtube') THEN 'Google Ads'
      ELSE channel
    END AS channel,

    currency,
    SUM(investment) AS investment,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(video_views) AS views
  FROM
    `blinks-bi.Adverity_GoogleB2C.1_Table_Consolidated-Data`
  GROUP BY
    1,2,3,4,5,6,7,8

--;
