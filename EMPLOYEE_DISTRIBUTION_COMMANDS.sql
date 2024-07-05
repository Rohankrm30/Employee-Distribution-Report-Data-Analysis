CREATE DATABASE PROJECTS;
USE PROJECTS;
SELECT count(*) FROM HR;

ALTER TABLE HR
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;
SELECT * FROM HR;

DESCRIBE HR;

SELECT BIRTHDATE FROM HR;

SET sql_safe_updates=0; 

UPDATE HR
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE null
END;

SELECT BIRTHDATE FROM HR;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE HR
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE null
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age < 18;

select count(* ) from hr;

SELECT gender,count(*) AS count 
FROM hr 
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY gender;

SELECT race,COUNT(*) AS count 
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
    FROM hr
    WHERE age>=18 AND termdate='0000-00-00';
    
SELECT 
	CASE 
    WHEN age>=18 AND age<=24 THEN '18-24'
    WHEN age>=25 AND age<=34 THEN '25-34'
    WHEN age>=35 AND age<=44 THEN '35-44'
    WHEN age>=45 AND age<=54 THEN '45-54'
    WHEN age>=55 AND age<=64 THEN '55-64'
    ELSE '65+'
END AS age_group,
count(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY age_group
ORDER BY age_group;
    
SELECT 
	CASE 
    WHEN age>=18 AND age<=24 THEN '18-24'
    WHEN age>=25 AND age<=34 THEN '25-34'
    WHEN age>=35 AND age<=44 THEN '35-44'
    WHEN age>=45 AND age<=54 THEN '45-54'
    WHEN age>=55 AND age<=64 THEN '55-64'
    ELSE '65+'
END AS age_group,gender,
count(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY age_group,gender
ORDER BY age_group,gender;

SELECT location,count(*) AS count 
FROM hr 
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY location;

SELECT 
	round(avg(datediff(termdate,hire_date))/365,0) AS avg_length_employment
FROM hr 
WHERE termdate<=curdate() AND termdate <> '0000-00-00' AND age>=18;

SELECT department,gender,COUNT(*) AS count 
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY department,gender
ORDER BY department;

SELECT jobtitle,count(*) AS count
FROM hr 
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle desc;

SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate<>'0000-00-00' AND termdate<=curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr 
    WHERE age>=18 
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;

SELECT location_state, count(*) AS count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY location_state
ORDER BY location_state;

SELECT 
	year,
    hires,
    terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires*100,2) AS net_change_percentage
FROM (
	SELECT YEAR (hire_date) AS YEAR,
    count(*) AS hires,
    SUM(CASE WHEN termdate<>'0000-00-00' AND termdate<=curdate() THEN 1 ELSE 0 END) AS terminations
FROM hr
WHERE AGE>=18
GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;
  
SELECT department,round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate<=curdate() and termdate<>'0000-00-00' AND age>=18
GROUP BY department;
    

