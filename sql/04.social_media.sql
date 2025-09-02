-- 1. The total Instagram and Tiktok mentions, over the years
select
        brand,
        sum(Instagram_Mentions_Thousands) as instagram_mentions,
        sum(TikTok_Mentions_Thousands) as tiktok_mentions
from fashion_sustainability
group by brand


-- 2. The values for the current year and the previous year regarding Instagram and Tiktok mentions and the difference between the two, in order to accentuate evolution over time

SELECT
    brand,
    year,
    
    -- Instagram 
    SUM(Instagram_Mentions_Thousands) AS instagram_mentions,
    LAG(SUM(Instagram_Mentions_Thousands), 1) OVER (PARTITION BY brand ORDER BY year) AS instagram_mentions_previous_year,
    SUM(Instagram_Mentions_Thousands)
      - LAG(SUM(Instagram_Mentions_Thousands), 1) OVER (PARTITION BY brand ORDER BY year) AS instagram_mentions_diff,
    
    -- TikTok
    SUM(TikTok_Mentions_Thousands) AS tiktok_mentions,
    LAG(SUM(TikTok_Mentions_Thousands), 1) OVER (PARTITION BY brand ORDER BY year) AS tiktok_mentions_previous_year,
    SUM(TikTok_Mentions_Thousands)
      - LAG(SUM(TikTok_Mentions_Thousands), 1) OVER (PARTITION BY brand ORDER BY year) AS tiktok_mentions_diff

FROM fashion_sustainability
GROUP BY brand, year
ORDER BY brand, year;
