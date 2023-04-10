SELECT * FROM laptops;

-- CREATING A NEW TABLE FOR BACKUP AS laptops_backup
CREATE TABLE laptops_backup LIKE laptops;

-- ISERTING THE DATA FROM laptop TABLE to laptops_backup TABLE
INSERT INTO laptops_backup 
SELECT * FROM laptops;
 
-- CHEKING THE NUMBER OF ROWS
SELECT COUNT(*) FROM laptops;
 
-- CHEKING MEMORY CONSUMPTION FOE REFERENCE('lptp' is my database name)
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'lptp'
AND TABLE_NAME = 'laptops';
 
 -- RENAME IMPORTANT COLUMNS
 SELECT * FROM laptops;
 ALTER TABLE laptops RENAME COLUMN `Unnamed: 0` TO `Index`;
 
-- CONVERING THE DATATYPE OF Inches COLUMN FROM DOUBLE TO DECIMAL
 ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,1);
 -- UPDATING THE COLUMN Ram BY REMOVING GB AND CONVERTING DATATYPE FROM TEXT TO INTEGER
UPDATE laptops l1
JOIN laptops l2 ON l1.index = l2.index
SET l1.Ram = REPLACE(l2.Ram, 'GB', '');
ALTER TABLE laptops MODIFY COLUMN Ram INTEGER;

-- UPADATING THE COLUMN Weight BY REMOVING KG AND CONVERTING THE DATATYPE INTO DECIMAL
UPDATE laptops l1
JOIN laptops l2 ON l1.index = l2.index
SET l1.Weight = REPLACE(l2.Weight, 'kg', '');
ALTER TABLE laptops MODIFY COLUMN Weight DECIMAL(10,1);

-- UPDATING THE PRICE COLUMN BY CHANGING DATATYPE FROM DOUBLE TO INTEGER
ALTER TABLE laptops MODIFY COLUMN Price INTEGER; 

-- UPDATING Opsys COLUMN
UPDATE laptops 
SET OpSys = CASE
	WHEN OpSys LIKE '%mac%' THEN 'macos'
	WHEN OpSys LIKE '%windows%' THEN 'windows'
    WHEN Opsys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'others'
END;
-- ADDING TWO NEW COLUMNS AS gpu_brand AND gpu_name 
ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;  
-- PUTTING THE VALUES IN gpu_brand COLUMN
UPDATE laptops l1
JOIN laptops l2
ON l1.index = l2.index
SET l1.gpu_brand = SUBSTRING_INDEX(l2.Gpu, ' ', 1);

-- UPDATING gpu_name COLUMN 
UPDATE laptops l1
JOIN laptops l2
ON l1.index = l2.index
SET l1.gpu_name = REPLACE(l2.Gpu, l2.gpu_brand, '');

-- DELETING THE Gpu COLUMN
ALTER TABLE laptops DROP COLUMN Gpu;
SELECT * FROM laptops;

-- ADDING three new COLUMNS

ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;
SELECT * FROM laptops;

-- UPDATING cpu_brand COLUMN

UPDATE laptops l1
JOIN laptops l2
ON l1.index = l2.index
SET l1.cpu_brand = SUBSTRING_INDEX(l2.Cpu, ' ', 1);
SELECT * FROM laptops;

-- UPDATING cpu_speed COLUMN

UPDATE laptops l1 
JOIN (
  SELECT `index`, CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10,2)) AS cpu_speed 
  FROM laptops
) l2 ON l1.`index` = l2.`index` 
SET l1.cpu_speed = l2.cpu_speed;
SELECT * FROM laptops;

-- UPDATING cpu_name COLUMN

UPDATE laptops l1
JOIN laptops l2
ON l1.index = l2.index
SET l1.cpu_name = SUBSTRING_INDEX(l2.Cpu, ' ', 3);

-- DROPPING the Cpu COLUMN

ALTER TABLE laptops DROP COLUMN Cpu;
SELECT * FROM laptops;

-- ADDING two new COLUMNS 

ALTER TABLE laptops
ADD COLUMN  resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

SELECT * FROM laptops;

-- UPDATING THE resolution_width AND resolution_height COLUMN

UPDATE laptops
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1) ;
SELECT * FROM laptops;

-- ADDING A NEW COLUMN CALLED touchscreen

ALTER TABLE laptops
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

-- UPDATING touchscreen COLUMN


UPDATE laptops
SET touchscreen = ScreenResolution LIKE '%Touch%';
SELECT * FROM laptops;

-- DROPPING THE COLUMN ScreenResolution

ALTER TABLE laptops
DROP COLUMN ScreenResolution;

-- ADDING three new COLUMNS

ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

-- UPADTING memory_type COLUMN

UPDATE laptops
SET memory_type =   CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
	WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE null
END ;
SELECT * FROM laptops;


-- UPDATING primary_storage AND secondary_storage COLUMN 

UPDATE laptops
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;

-- UPDATING primary_storage AND secondary_storage COLUMN

UPDATE laptops
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

-- DROP COLUMN Memory

ALTER TABLE laptops
DROP COLUMN Memory;

-- DROP COLUMN gpu_name

ALTER TABLE laptops
DROP COLUMN gpu_name;

SELECT * FROM laptops
