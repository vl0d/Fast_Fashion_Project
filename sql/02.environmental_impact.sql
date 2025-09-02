
-- 1. the emissions per cycle added up
with values as (
    select  
        brand,
        year,
        sum(Release_Cycles_Per_Year) as total_releaseas,
        round(sum(water_usage_million_litres), 0) as total_water_used_millions,
        round(sum(water_usage_million_litres) / sum(Release_Cycles_Per_Year), 0) as water_used_per_cycle_in_year,
        round(sum(carbon_emissions_tco2e), 0) as total_carbon_emissions,
        round(sum(carbon_emissions_tco2e) / sum(Release_Cycles_Per_Year), 0) as carbon_emissions_per_cycle_in_year
    from fashion_sustainability
    group by brand, year
    order by brand, year
),

agrregations as (
    select
        brand,

        -- Carbon emissions aggregations
        sum(carbon_emissions_per_cycle_in_year) as total_emissions_per_cycle,
        avg(carbon_emissions_per_cycle_in_year) as avg_emissions_per_cycle,

        -- Water usage aggregations
        sum(water_used_per_cycle_in_year) as total_water_per_cycle,
        avg(water_used_per_cycle_in_year) as avg_water_per_cycle
    from values
    group by brand
)

select
    brand,

    -- Rankings for carbon emissions
    rank() over(order by total_emissions_per_cycle desc) as ranking_total_emissions_per_cycle_all_years_per_brand,
    rank() over(order by avg_emissions_per_cycle desc) as ranking_avg_emissions_per_cycle_all_years_per_brand,

    -- Rankings for water usage
    rank() over(order by total_water_per_cycle desc) as ranking_total_water_per_cycle_all_years_per_brand,
    rank() over(order by avg_water_per_cycle desc) as ranking_avg_water_per_cycle_all_years_per_brand
from agrregations;


/* although being ranked 4th in total cycles and revenue,
Uniqlo is ranked first in carbon emissions and water used per cycle, in all years
*/



-- 2. Water usage and Carbon Emissions and their values per product release cycle.

SELECT  
    brand,
    year,
    sum(Release_Cycles_Per_Year) as total_releaseas,
    round(sum(water_usage_million_litres), 0) as total_water_used_millions,
    round(sum(water_usage_million_litres) / sum(Release_Cycles_Per_Year), 0) as water_used_per_cycle_in_year,
    round(sum(carbon_emissions_tco2e), 0) as total_carbon_emissions,
    round(sum(carbon_emissions_tco2e) / sum(Release_Cycles_Per_Year), 0) as carbon_emissions_per_cycle_in_year
from fashion_sustainability
group by brand, year
order by brand, year




-- 3. Emissions per tonne produced, by brand and year
    
        select 
            brand,
            year,
            sum(Monthly_Production_Tonnes) as total_tonnes,
            sum(Carbon_Emissions_tCO2e) as total_carbon,
            round(sum(Carbon_Emissions_tCO2e) / sum(Monthly_Production_Tonnes), 1) as carbon_emissions_per_tonnes
        from fashion_sustainability
        group by brand, year
        order by brand, year


-- 4. values in millions, tonnes and their respective percentages from the total etc.
select 
    brand,
    sum(water_usage_million_litres) as water,
    ROUND(100.0 * SUM(water_usage_million_litres) / SUM(SUM(water_usage_million_litres)) OVER (), 2) AS pct_water,

    sum(Carbon_Emissions_tCO2e) as carbon,
    ROUND(100.0 * SUM(Carbon_Emissions_tCO2e) / SUM(SUM(Carbon_Emissions_tCO2e)) OVER (), 2) AS pct_carbon,

    sum(Landfill_Waste_Tonnes) as waste,
    ROUND(100.0 * SUM(Landfill_Waste_Tonnes) / SUM(SUM(Landfill_Waste_Tonnes)) OVER (), 2) AS pct_waste,

    sum(GDP_Contribution_Million_USD) as gdp,
    ROUND(100.0 * SUM(GDP_Contribution_Million_USD) / SUM(SUM(GDP_Contribution_Million_USD)) OVER (), 2) AS pct_gdp
from fashion_sustainability
group by brand
order by gdp desc

-- from this we find that the environmental impact of brands is directly proportional to the profit they make


