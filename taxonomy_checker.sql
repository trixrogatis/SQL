/*
  View created by: Beatriz Rogatis (beatrizrogatis@me.com)
  Objective: validate online campaign taxonomy for the client
  Adverity connection (if available): NA
  Spreadsheets connection (if available): NA
  Looker Studio connection (if available): https://lookerstudio.google.com/u/0/reporting/1ccc96c6-dba1-40cf-a53b-1b909c1a43bb/page/gUKwC/edit

  View edited by: Beatriz Rogatis (beatrizrogatis@me.com)
  Edit date: 2024-02-02
  Edit reason: adding URL validator
*/

SELECT

  DISTINCT
  quarter,
  channel,
  account_name,
  campaign_name,
  campaign_id,
  adset_name,
  adset_id,
  builder,
  iniciative,
  LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"|","")) AS pipe_campaign,
  LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"_","")) AS underscore_campaign,
  LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"|","")) AS pipe_adset,
  LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"_","")) AS underscore_adset,
  final_url,


  -- INÍCIO VALIDAÇÃO DA TAXONOMIA DE CAMPANHA E ADSET --
  -- CLASSIFICAÇÃO DE CAMPANHAS --
  
  
  CASE
    WHEN builder='Display House Ads' THEN
      CASE 
        WHEN LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"|","")) = 11 
        AND LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"_","")) = 1 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
    WHEN builder='Search' THEN
      CASE
        WHEN LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"|","")) = 11
        AND LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"_","")) = 2 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
    WHEN builder='DV360' THEN
      CASE
        WHEN LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"|","")) = 10
        AND LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"_","")) = 2 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
    WHEN builder='Paid-Social' THEN
      CASE
        WHEN LENGTH(campaign_name) - LENGTH(REPLACE(campaign_name,"_","")) = 10 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
  END AS campaign_validator,

  -- CLASSIFICAÇÃO DE ADSET --
  
  CASE
    WHEN builder='Display House Ads' THEN
      CASE
        WHEN LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"|","")) = 2
        AND LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"_","")) = 2 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
    WHEN builder='Search' THEN
      CASE
        WHEN LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"|","")) = 2 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
    WHEN builder='DV360' THEN
      CASE
        WHEN LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"|","")) = 4
        AND LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"_","")) = 3 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
    WHEN builder='Paid-Social' THEN
      CASE
        WHEN LENGTH(adset_name) - LENGTH(REPLACE(adset_name,"_","")) = 12 THEN 'Ok'
        ELSE 'Revise a nomenclatura'
      END
  END AS adset_validator,
  
  -- VALIDAÇÃO DE URLs --

  CASE
    WHEN REGEXP_CONTAINS(final_url,r'utm_source=') AND REGEXP_CONTAINS(final_url,r'utm_medium=') THEN 'Ok'
    ELSE 'Erro'
  END AS sourcemedium_validator,
  CASE
    WHEN REGEXP_CONTAINS(final_url,r'utm_campaign=') THEN 'Ok'
    ELSE 'Erro'
  END AS utmcampaign_validator,
  CASE
    WHEN REGEXP_CONTAINS(final_url,r'utm_content=') THEN 'Ok'
    ELSE 'Erro'
  END AS utmcontent_validator,


FROM 
  `blinks-bi.Adverity_GoogleB2C.View_Consolidated-Data`
WHERE
  date >= '2023-01-01' AND builder <> 'Veiculos-PI' AND campaign_name IS NOT NULL
