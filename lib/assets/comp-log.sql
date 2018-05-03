CREATE DATABASE compressor_log;

USE compressor_log;

CREATE TABLE companies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    company_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

CREATE TABLE compressors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  comp_name VARCHAR(20) NOT NULL,
  company_id INT NOT NULL,
  location_id INT NOT NULL,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (location_id) REFERENCES locations(id)
);

CREATE TABLE operators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    company_id INT NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

CREATE TABLE comp_log (
  created_at TIMESTAMP DEFAULT NOW(),
  suction INT DEFAULT 0,
  discharge INT DEFAULT 0,
  rpm INT DEFAULT 0,
  comp_load INT DEFAULT 0,
  hours INT DEFAULT 0,
  eng_temp INT DEFAULT 0,
  eng_psi INT DEFAULT 0,
  comp_temp INT DEFAULT 0,
  comp_psi INT DEFAULT 0,
  cyl_1 INT DEFAULT 0,
  cyl_2 INT DEFAULT 0,
  cyl_3 INT DEFAULT 0,
  cyl_4 INT DEFAULT 0,
  catalyst_temp INT DEFAULT 0,
  comp_id INT NOT NULL,
  operator_id INT NOT NULL,
  FOREIGN KEY (comp_id) REFERENCES compressors(id),
  FOREIGN KEY (operator_id) REFERENCES operators(id)
);

INSERT INTO companies (name)
VALUES ('ENLINK'),('ENBRIDGE'),('ATMOS');

INSERT INTO locations (location_name, company_id)
VALUES
  ('Jarvis', 1),
  ('East Rome', 1),
  ('Ross', 1),
  ('Justin', 1),
  ('Ponder', 1),
  ('Springtown', 2),
  ('Loancamp', 2),
  ('Weatherford', 2),
  ('Justin', 3);

INSERT INTO compressors (comp_name, company_id, location_id)
VALUES
    ('COMP #1', 1, 1),
    ('COMP #2', 1, 1),
    ('COMP #3', 1, 1),
    ('COMP #4', 1, 1),
    ('COMP #6', 1, 1),
    ('COMP #10', 1, 1),
    ('COMP #11', 1, 1),
    ('COMP #12', 1, 1),
    ('COMP #13', 1, 1),
    ('COMP #1', 1, 2),
    ('COMP #2', 1, 2),
    ('COMP #1', 1, 3),
    ('COMP #1', 1, 4),
    ('COMP #2', 1, 4),
    ('COMP #1', 1, 5),
    ('COMP #2', 1, 5),
    ('COMP #3', 1, 5),
    ('COMP #1', 2, 6),
    ('COMP #2', 2, 6),
    ('COMP #3', 2, 6),
    ('COMP #1', 2, 7),
    ('COMP #1', 2, 8),
    ('COMP #1', 3, 9);

INSERT INTO operators (first_name, last_name, company_id, location_id)
VALUES
        ('Steve', 'Kuhn', 1, 5);
    ('Micheal', 'Giles', 1, 1),
    ('Ruben', 'Contreras', 1, 1),
    ('Jim', 'Bertelmen', 1, 1),
    ('Steve', 'Smith', 1, 1),
    ('Marvin', 'Parry', 1, 2),
    ('Gabe', '...', 1, 3),
    ('Todd', 'Kume', 1, 4),
    ('Nick', 'caballero', 1, 5),
    ('Mike', 'Miller', 2, 6),
    ('Tim', 'Arnald', 2, 7),
    ('Ricky', 'White', 2, 8),
    ('Justin', 'Nelly', 3, 9);

UPDATE locations SET location_name='East Rhome'
WHERE location_name='East Rome';

INSERT INTO comp_log (
                  suction,
                  discharge,
                  rpm,
                  comp_load,
                  hours,
                  eng_temp,
                  eng_psi,
                  comp_temp,
                  comp_psi,
                  cyl_1,
                  cyl_2,
                  cyl_3,
                  cyl_4,
                  catalyst_temp,
                  comp_id,
                  operator_id
)
VALUES
(71,863,70,880,102543,174,75,172,64,259,256,243,263,0,1,4),
(71,863,71,1000,3024543,165,75,173,63,259,256,263,263,0,2,4),
(71,863,73,880,402543,154,78,174,64,289,254,253,263,0,3,4),
(71,863,72,880,502543,127,75,172,68,259,256,263,283,0,4,4),
(71,863,74,1200,3024543,167,76,174,62,259,253,263,293,0,5,4),
(71,863,73,880,3302543,174,75,172,64,279,254,263,243,0,6,4),
(71,863,75,1250,5024543,145,74,172,64,259,256,243,263,0,7,4),
(71,863,76,1280,4024543,138,75,177,68,259,259,263,263,0,11,5),
(71,863,70,880,14322543,179,73,172,64,269,256,293,243,0,10,5);

SELECT * FROM companies;
SELECT * FROM locations;
SELECT * FROM operators;
SELECT * FROM compressors;
SELECT
    DATE(created_at) AS day,
    suction AS suct,
    discharge AS disch,
    rpm,
    comp_load AS 'load',
    hours,
    eng_temp,
    eng_psi,
    cyl_1,
    cyl_2,
    cyl_3,
    cyl_4,
    catalyst_temp AS cat_temp,
    comp_id,
    operator_id
FROM comp_log;

-- COMPRESSOR ENGINE TEMPRETURE
SELECT
  CONCAT(
    operators.first_name, ' ',
    operators.last_name) AS 'operator',
  CONCAT(
    locations.location_name, ' ',
    compressors.comp_name) AS 'compressor',
  CONCAT(
    comp_log.eng_temp, '° ',
  CASE
    WHEN eng_temp > 150 THEN 'HOT'
    ELSE 'NORMAL'
  END) AS 'engine temp',
  DATE_FORMAT(comp_log.created_at, '%W %M %Y') AS 'logged on'
FROM compressors
JOIN comp_log
  ON compressors.id = comp_log.comp_id
JOIN locations
  ON locations.id = compressors.location_id
JOIN operators
  ON operators.location_id = locations.id
WHERE operators.id = comp_log.operator_id;

-- AVERAGE COMPRESSOR TEMPRETURE
SELECT
    locations.location_name,
    compressors.comp_name,
     ROUND(AVG(eng_temp), 2) AS 'Average engine temp'
FROM compressors
JOIN comp_log
    ON compressors.id = comp_log.comp_id
JOIN locations
  ON locations.id = compressors.location_id
GROUP BY compressors.id;

-- OPERATOR WORKS AT
SELECT
  CONCAT(
    operators.first_name, ' ',
    operators.last_name, ' works with ',
    companies.name, ' at the ',
    locations.location_name, ' location'
  ) AS 'operators company and location'
FROM operators
JOIN companies
    ON companies.id = operators.company_id
JOIN locations
    ON locations.id = operators.location_id;

-- HOW MANY COMPRESSORS ARE AT THE PLANTS
SELECT
  CONCAT(
    locations.location_name, ' has ',
    COUNT(*), ' compressor(s)') AS TOTAL_COMPRESSORS
FROM compressors
JOIN locations
    ON locations.id = compressors.location_id
GROUP BY locations.id;

-- HOW MANY LOCATIONS DO THE COMPANIES HAVE
SELECT
  CONCAT(
    companies.name, ' has ',
    COUNT(*), ' location(s)') AS TOTAL_LOCATIONS
FROM companies
JOIN locations
    ON locations.company_id = companies.id
GROUP BY companies.id;

-- HOT VALVES
SELECT
    location_name,
    comp_name,
    cyl_1,
    cyl_2,
    cyl_3,
    cyl_4,
  CASE
    WHEN cyl_1 >= cyl_3 + 11 AND cyl_2 >= cyl_4 + 11 THEN 'all valves could be hot valves'
    WHEN cyl_1 >= cyl_3 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'all valves could be hot valves'
    WHEN cyl_3 >= cyl_1 + 15 AND cyl_2 >= cyl_4 + 15 THEN 'all valves could be hot valves'
    WHEN cyl_3 >= cyl_1 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'all valves could be hot valves'
    WHEN cyl_1 >= cyl_3 + 15  THEN 'cyl 1 or 3 has hot valves'
    WHEN cyl_3 >= cyl_1 + 15  THEN 'cyl 1 or 3 has hot valves'
    WHEN cyl_2 >= cyl_4 + 15 THEN 'cyl 2 or 4 has hot valves'
    WHEN cyl_4 >= cyl_2 + 15 THEN 'cyl 2 or 4 has hot valves'
    ELSE 'valves are ok'
  END AS 'VALVES'
FROM comp_log
JOIN compressors
    ON compressors.id = comp_log.comp_id
JOIN locations
    ON locations.id = compressors.location_id;
