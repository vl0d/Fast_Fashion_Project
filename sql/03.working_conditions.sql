-- 1. the count of good and bad average salaries
with salaries as(
    select  
        brand,
        year, 
        round(avg(Avg_Worker_Wage_USD), 2) as avg_salary_USD,
        CASE
            WHEN avg(Avg_Worker_Wage_USD) > 150 then 'Above Average'
            else 'Below Average'
            end as salary_quality
    from fashion_sustainability
    where avg_worker_wage_usd > 0
    group by brand, year
)

SELECT 
    brand,
    count(case when salary_quality = 'Above Average' then brand end) as salaries_above_average,
    count(case when salary_quality = 'Below Average' then brand end) as salaries_below_average
from salaries
group by brand


-- Forever 21 has only 2 years with salaries above the average range



-- 2. salaries by year and brand
    select  
        brand,
        year, 
        round(avg(Avg_Worker_Wage_USD), 2) as avg_salary_USD,
        CASE
            WHEN avg(Avg_Worker_Wage_USD) > 150 then 'Above Average'
            else 'Below Average'
            end as salary_quality
    from fashion_sustainability
    where avg_worker_wage_usd > 0
    group by brand, year




-- 3. -- working hours by brand and year
SELECT
    brand,
    year,
    round(avg(Working_Hours_Per_Week), 0) as avg_working_hours_per_week,
    case
        when avg(Working_Hours_Per_Week) > (select avg(Working_Hours_Per_Week) from fashion_sustainability) then 'Above Average'
        else 'Below Average'
        end as above_or_below_average_work
from fashion_sustainability
group by brand, year
order by brand, year

