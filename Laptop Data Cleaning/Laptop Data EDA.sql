SELECT * FROM laptops;
-- PREVIEW OF DATA BY DOING THIS QUERIES
-- HEAD
SELECT * FROM laptops
ORDER BY `index` LIMIT 5;

-- TAIL
SELECT * FROM laptops
ORDER BY `index` DESC LIMIT 5;

-- sample
SELECT * FROM laptops
ORDER BY rand() LIMIT 5 ;

-- * 8 number summary

 
  SELECT 
  COUNT(Price) OVER() AS count,
  MIN(Price) OVER() AS max_price,
  MAX(Price) OVER() AS min_price,
  AVG(Price) OVER() AS avg_price,
  STD(Price) OVER() AS std,
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER() AS '25th_percentile',
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price) OVER() AS 'median',
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER() AS '75th_percentile'
FROM laptops;
SELECT * FROM laptops;

-- missing value check
SELECT COUNT(Price)
FROM laptops
WHERE Price IS NULL;

 SELECT Company FROM laptops
 WHERE Company IS NULL;
 
 SELECT TypeName FROM laptops
 WHERE TypeName IS NULL;
 
 -- Outlier Detection
SELECT * FROM (SELECT *,
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS 'Q1'
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS 'Q3'
FROM laptops) t
WHERE t.Price < t.q1 - (1.5*(t.Q3-t.Q1)) OR
t.Price > t.Q3 + (1.5*(t.Q3 -t.Q1));

-- plotting histogram

SELECT t.buckets,REPEAT('*',COUNT(*)) FROM( SELECT Price,
CASE
	WHEN Price BETWEEN 0 AND 25000 THEN '0-25k' 
	WHEN Price BETWEEN 25001 AND 50000 THEN '25k-50k'
	WHEN Price BETWEEN 50001 AND 75000 THEN '50k-75k'	
    WHEN Price BETWEEN 75001 AND 100000 THEN '0-25k'
	ELSE '>100k'
END AS 'buckets'
FROM laptops) t  
GROUP BY t.buckets;

    -- all company and their number of laptops
SELECT Company,COUNT(Company) FROM laptops
GROUP BY Company ;

-- touchscren laptops number
SELECT touchscreen,Count(touchscreen) FROM laptops
GROUP BY touchscreen;

-- OpSys 
SELECT OpSys,COUNT(OpSys) FROM laptops
GROUP BY OpSys;
 
 -- cpu brand
 SELECT cpu_brand,COUNT(cpu_brand) FROM laptops
GROUP BY cpu_brand;
 
 -- Bivariate Analysis For scatterplot
-- for cpu_speed and price column sactterplot

SELECT cpu_speed,Price FROM laptops;

-- for company and touchscreen contingency table
SELECT Company,
SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no'
FROM laptops
GROUP BY Company;

SELECT Company,
SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'amd',
SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'samsung'
FROM laptops
GROUP BY Company;

-- Categorical Numerical Bivariate Analysis

SELECT Company,MIN(Price),MAX(Price),AVG(Price),STD(Price) FROM laptops GROUP BY Company;

-- Creating a new column ppi by using resolution_width,resolution_height and Inches column

ALTER TABLE laptops ADD COLUMN ppi INTEGER ;

UPDATE laptops
SET ppi = ROUND(SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/Inches);
SELECT * FROM laptops
