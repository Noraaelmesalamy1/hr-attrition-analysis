create database hr_analysis ;
select * from HR_sep ;
SELECT * INTO hr 
FROM [HR_sep]  WHERE 1 = 0;
SELECT * FROM HR ;

insert into hr 
select * from [HR_sep] ;

------duplicates

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY satisfaction_level, last_evaluation, number_project,
                            average_montly_hours, time_spend_company, work_accident,
                           [ left], promotion_last_5years, department, salary
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM HR
)
SELECT * FROM CTE WHERE rn > 1;
 
 WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY satisfaction_level, last_evaluation, number_project,
                            average_montly_hours, time_spend_company, work_accident,
                           [left], promotion_last_5years, department, salary
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM HR
)
DELETE FROM CTE
WHERE rn > 1;

select * from hr ;


UPDATE HR
SET department = LTRIM(RTRIM(LOWER(department)));


UPDATE HR
SET salary = LOWER(LTRIM(RTRIM(salary)));
--- check missing value 

SELECT COUNT(*) AS Missing_Department FROM HR WHERE department IS NULL OR department = '';
SELECT COUNT(*) AS Missing_Salary FROM HR WHERE salary IS NULL OR salary = '';
-- Very high hours
SELECT TOP 10 * FROM HR ORDER BY average_montly_hours DESC;

-- Satisfaction outside 0–1
SELECT * FROM HR WHERE satisfaction_level < 0 OR satisfaction_level > 1;
----employees left 

SELECT COUNT(*) AS total_employees FROM HR;

SELECT [left], COUNT(*) AS count_employees
FROM HR
GROUP BY [left];

SELECT 
    AVG(satisfaction_level) AS avg_satisfaction,
    MIN(satisfaction_level) AS min_satisfaction,
    MAX(satisfaction_level) AS max_satisfaction,
    
    AVG(last_evaluation) AS avg_evaluation,
    MIN(last_evaluation) AS min_evaluation,
    MAX(last_evaluation) AS max_evaluation,
    
    AVG(average_montly_hours) AS avg_hours,
    MIN(average_montly_hours) AS min_hours,
    MAX(average_montly_hours) AS max_hours,
    
    AVG(time_spend_company) AS avg_years,
    MIN(time_spend_company) AS min_years,
    MAX(time_spend_company) AS max_years
FROM HR;
---comparing performance  as left 1 or not 0
SELECT [left],
       AVG(satisfaction_level) AS avg_satisfaction,
       AVG(last_evaluation) AS avg_evaluation,
       AVG(average_montly_hours) AS avg_hours,
       AVG(time_spend_company) AS avg_tenure
FROM HR
GROUP BY [left];

---attrition by department  left/t employee*100
SELECT department, 
       COUNT(*) AS total_employees,
       SUM(CASE WHEN [left] = 1 THEN 1 ELSE 0 END) AS employees_left,
       100.0 * SUM(CASE WHEN [left] = 1 THEN 1 ELSE 0 END) / COUNT(*) AS attrition_rate
FROM HR
GROUP BY department
ORDER BY attrition_rate DESC;

select salary,
  count (*) as total_employee ,
  sum (case when [left] = 1  then 1 else 0 end ),
  100 *   sum (case when [left] = 1  then 1 else 0 end )/ count (*) as attrition_rate
  FROM HR
GROUP BY salary
ORDER BY attrition_rate DESC;
---work hours and projects

SELECT 
    MIN(average_montly_hours) AS min_hours,
    MAX(average_montly_hours) AS max_hours,
    AVG(average_montly_hours) AS avg_hours,
    MIN(number_project) AS min_projects,
    MAX(number_project) AS max_projects,
    AVG(number_project) AS avg_projects
FROM HR;

---correlation checks

SELECT promotion_last_5years,
       COUNT(*) AS total,
       SUM(CASE WHEN [left] = 1 THEN 1 ELSE 0 END) AS employees_left,
       100.0 * SUM(CASE WHEN [left] = 1 THEN 1 ELSE 0 END) / COUNT(*) AS attrition_rate
FROM HR
GROUP BY promotion_last_5years;




select * from hr ;


SELECT salary, 
       COUNT(*) AS total_employees,
       SUM(CASE WHEN [left] = 1 THEN 1 ELSE 0 END) AS employees_left,
       100.0 * SUM(CASE WHEN [left] = 1 THEN 1 ELSE 0 END) / COUNT(*) AS attrition_rate
FROM HR
GROUP BY salary
ORDER BY attrition_rate DESC;
