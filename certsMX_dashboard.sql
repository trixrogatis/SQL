--CREATE OR REPLACE MATERIALIZED VIEW `Adverity_GoogleB2C.MView_Dashboard_CertsMx` AS

  /*
    Vista materializada criada por Beatriz Rogatis (beatriz.rogatis@mediafuturesgroup.com)
    Objetivo da vista: Alimentar dashboard de Certs México
    Conexão Adverity (Se houver): NA
    Conexão Sheets (Se houver): 
    Conexão Looker Studio (Se houver): https://lookerstudio.google.com/u/0/reporting/c6454bd6-2dca-48ad-a8b3-929601341122/page/yADYD/edit?s=pIwzj0FY4IY
  */

  -- Select geral da tabela consolidada
  SELECT

  CASE
    WHEN date BETWEEN '2023-06-15' AND '2023-06-21' THEN 'Week-01'
    WHEN date BETWEEN '2023-06-22' AND '2023-06-28' THEN 'Week-02'
    WHEN date BETWEEN '2023-06-29' AND '2023-07-05' THEN 'Week-03'
    WHEN date BETWEEN '2023-07-06' AND '2023-07-12' THEN 'Week-04'
    WHEN date BETWEEN '2023-07-13' AND '2023-07-19' THEN 'Week-05'
    WHEN date BETWEEN '2023-07-20' AND '2023-07-26' THEN 'Week-06'
    WHEN date BETWEEN '2023-07-27' AND '2023-08-02' THEN 'Week-07'
    WHEN date BETWEEN '2023-08-03' AND '2023-08-09' THEN 'Week-08'
    WHEN date BETWEEN '2023-08-10' AND '2023-08-16' THEN 'Week-09'
    WHEN date BETWEEN '2023-08-17' AND '2023-08-23' THEN 'Week-10'
    WHEN date BETWEEN '2023-08-24' AND '2023-08-31' THEN 'Week-11' --Semana mais longa
    ELSE 'NA'
  END AS week,
  
  DATE_TRUNC(date,WEEK(MONDAY)) as iso_week,
  date,
  channel,

  CASE --Filtro de Funnel
    WHEN channel = 'TikTok' OR REGEXP_CONTAINS(campaign_name,'(?i)Awareness|YT') THEN 'Awareness'
    ELSE 'Consideration'
  END AS funnel,

  CASE --Filtro de Ad_Type
    -- Google Ads
    WHEN builder = 'Search' AND REGEXP_CONTAINS(campaign_name,'(?i)Banner') THEN 'Landscape/Square Banners'
    WHEN builder = 'Search' AND REGEXP_CONTAINS(campaign_name,'(?i)AKWS') THEN 'Keywords/Text Ads | Generic'
    WHEN builder = 'Search' AND REGEXP_CONTAINS(campaign_name,'(?i)BKWS') THEN 'Keywords/Text Ads | Institutional'
    WHEN builder = 'Search' AND REGEXP_CONTAINS(campaign_name,'(?i)YT( |)Bump') THEN 'Bumper'
    WHEN builder = 'Search' AND REGEXP_CONTAINS(campaign_name,'(?i)YT( |)TrV') THEN 'TrueView In-Stream'
    -- Meta
    WHEN channel = 'Meta' THEN 'Image/Video/Carousel'
    -- LinkedIn
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(campaign_name,'(?i)Message( |)Ad') THEN 'Message Ad'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(campaign_name,'(?i)_Video_|_Image_|_Carousel_') THEN 'Single Image/Video/Carousel'
    -- TikTok
    WHEN channel = 'TikTok' THEN 'Video with Sound 5-60 seconds'
    -- Twitter
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(campaign_name,'(?i)Pre( |)Roll') THEN 'Video | Pre Roll'
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(campaign_name,'(?i)Video Views') THEN 'Video View'
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(campaign_name,'(?i)Reach') THEN 'Tweets'
    ELSE 'NA'
  END AS ad_type,

  CASE
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M010|msg( |)10|mensagem( |)10') THEN 'Marketing Digital'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M01|msg( |)1|mensagem( |)1') THEN 'Oportunidades Laborales'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M02|msg( |)2|mensagem( |)2') THEN 'Romper tus limites'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M03|msg( |)3|mensagem( |)3') THEN 'Crecer en el equipo'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M04|msg( |)4|mensagem( |)4') THEN 'Cambiar de profesión'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M05|msg( |)5|mensagem( |)5') THEN 'Soñar con ganar más'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M06|msg( |)6|mensagem( |)6') THEN 'Soporte de TI'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M07|msg( |)7|mensagem( |)7') THEN 'Gestión de proyectos'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M08|msg( |)8|mensagem( |)8') THEN 'UX Design'
    WHEN REGEXP_CONTAINS(ad_name,'(?i)_M09|msg( |)9|mensagem( |)9') THEN 'Analista de Dados'
    -- SEM e RESPONSIVE
    WHEN REGEXP_CONTAINS(campaign_name,'(?i)SEM') OR REGEXP_CONTAINS(campaign_name,'_Pre Roll') THEN 'SEM/Disp/Pre-Roll'
    WHEN ad_name='RESPONSIVE_DISPLAY_AD' THEN 'SEM/Disp/Pre-Roll'
    WHEN campaign_name LIKE '1605696 | Google Career Certificates | BR | ESS01 | LATAM | MX | es | Hybrid | DISP | MT | Banner | GAds%' THEN 'SEM/Disp/Pre-Roll'
    ELSE 'NA'
  END AS ad_data,

  CASE
    -- GDN e Youtube
    WHEN builder = 'Search' AND REGEXP_CONTAINS(adset_name,'(?i)TT|IMS|LIFE|IT') THEN 'KOFs'
    WHEN builder = 'Search' AND REGEXP_CONTAINS(adset_name,'(?i)AS') THEN 'Final Users'
    WHEN builder = 'Search' AND REGEXP_CONTAINS(adset_name,'(?i)KWT') THEN 'General'
    -- SEM
    WHEN builder = 'Search' AND REGEXP_CONTAINS(campaign_name,'(?i)SEM') THEN 'General'
    -- LinkedIn
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(campaign_name,'(?i)Decision( |)Makers|EngagedCitizens|Amplifiers|Influencers|Informed( |)Citizens|LinkedinExperts') THEN 'KOFs'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(campaign_name,'(?i)_Final( |)Users_') THEN 'Final Users'
    -- Meta, TikTok e Twitter
    WHEN channel IN('Meta','TikTok','Twitter') AND REGEXP_CONTAINS(adset_name,'(?i)final( |)users') THEN 'Final Users'
    WHEN channel IN('Meta','TikTok','Twitter') AND REGEXP_CONTAINS(adset_name,'(?i)experts|informed( |)citizens|decision( |)makers|KOFs') THEN 'KOFs'
    ELSE 'NA'
  END AS audience,

  CASE
    WHEN channel = 'GDN' THEN 'Banner'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(ad_name, "(?i)carousel|carrousel|carrossel")  THEN 'Carousel'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(ad_name, "(?i)static")  THEN 'Banner'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(ad_name, "(?i)messagead")  THEN 'Text'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(ad_name, "(?i)short( |-|)video|video( |-|)short") THEN 'Video-Short'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(ad_name, "(?i)long( |-|)video|video( |-|)long") THEN 'Video-Long'
    WHEN channel = 'LinkedIn' AND REGEXP_CONTAINS(ad_name, "(?i)video")  THEN 'Video'
    WHEN channel = 'Meta' AND REGEXP_CONTAINS(ad_name, "(?i)carousel|carrousel|carrossel")  THEN 'Carousel'
    WHEN channel = 'Meta' AND REGEXP_CONTAINS(ad_name, "(?i)static|image")  THEN 'Banner'
    WHEN channel = 'Meta' AND REGEXP_CONTAINS(ad_name, "(?i)short( |-|)video|video( |-|)short") THEN 'Video-Short'
    WHEN channel = 'Meta' AND REGEXP_CONTAINS(ad_name, "(?i)long( |-|)video|video( |-|)long") THEN 'Video-Long'      
    WHEN channel = 'Meta' AND REGEXP_CONTAINS(ad_name, "(?i)video")  THEN 'Video'
    WHEN channel = 'SEM' THEN 'Text'
    WHEN channel = 'TikTok' AND REGEXP_CONTAINS(ad_name, "(?i)short( |-|)video|video( |-|)short") THEN 'Video-Short'
    WHEN channel = 'TikTok' AND REGEXP_CONTAINS(ad_name, "(?i)long( |-|)video|video( |-|)long") THEN 'Video-Long'
    WHEN channel = 'TikTok' AND REGEXP_CONTAINS(ad_name, "(?i)video")  THEN 'Video'
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(campaign_name, "(?i)pre( |-|)roll")  THEN 'Pre-Roll'
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(ad_name, "(?i)short( |-|)video|video( |-|)short") THEN 'Video-Short'
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(ad_name, "(?i)long( |-|)video|video( |-|)long") THEN 'Video-Long'      
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(ad_name, "(?i)video")  THEN 'Video'
    WHEN channel = 'Twitter' AND REGEXP_CONTAINS(ad_name, "(?i)tweet")  THEN 'Tweet'
    WHEN channel = 'Youtube' AND REGEXP_CONTAINS(ad_name, "(?i)bumper")  THEN 'Bumper'
    WHEN channel = 'Youtube' AND REGEXP_CONTAINS(ad_name, "(?i)in( |-|)stream")  THEN 'TrueView In Stream'
    ELSE CONCAT(Channel,'-NA')
  END AS ad_format,

  media_type,
  account_name,
  campaign_name,
  adset_name,
  ad_name,
  currency,
  SUM(investment) AS investment,
  SUM(investment_usd) AS investment_usd,
  SUM(impressions) AS impressions,
  SUM(impressions_video) AS impressions_video,  
  SUM(clicks) AS clicks,
  SUM(video_views) AS views,
  SUM(views_25) AS views_25,
  SUM(views_50) AS views_50,
  SUM(views_75) AS views_75,
  SUM(views_100) AS views_100

  FROM
    `blinks-bi.Adverity_GoogleB2C.1_Table_Consolidated-Data` 
  WHERE
    iniciative = 'Google Certs MX'
    AND date BETWEEN "2023-06-15" AND "2023-08-31"
  GROUP BY
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    
--;
