-- 1. The total net revenue for each brand and ranking the brands by total revenue 
select 
    brand, 
    sum(gdp_contribution_million_usd) as total_net_revenue,
    rank() over(order by sum(gdp_contribution_million_usd) desc) as ranking_by_net_revenue
from fashion_sustainability
group by brand


-- 2. Total release cycles by brand and ranking the brands by number of cycles
select 
    brand,
    sum(Release_Cycles_Per_Year) as total_release_cycles,
    rank() over(order by sum(gdp_contribution_million_usd) desc) as ranking_by_release_cycles
from fashion_sustainability
group by brand



-- 3. Correlation between production and GDP percentage:
            WITH every_brand AS (
                SELECT
                    brand,
                    SUM(Monthly_Production_Tonnes) AS total_production_by_brand,
                    SUM(GDP_Contribution_Million_USD) AS total_gdp_by_brand
                FROM fashion_sustainability
                GROUP BY brand
            ),
            brand_and_year AS (
                SELECT
                    brand,
                    year,
                    SUM(Monthly_Production_Tonnes) AS production_by_brand_year,
                    SUM(GDP_Contribution_Million_USD) AS gdp_by_brand_year
                FROM fashion_sustainability
                GROUP BY brand, year
            )

            SELECT
                b.brand,
                b.year,
                round((b.production_by_brand_year / NULLIF(e.total_production_by_brand, 0)) * 100, 1) AS pct_of_production_by_brand,
                round((b.gdp_by_brand_year / NULLIF(e.total_gdp_by_brand, 0)) * 100, 1) AS pct_of_gdp_by_brand
            FROM brand_and_year b
            JOIN every_brand e ON b.brand = e.brand
            ORDER BY b.brand, b.year;


