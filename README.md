# Compressor_log
Used Express and SQL to create a site that natural gas operators can log compressor data into and have an alert dependent on temperatures being out of speck.

![image text](https://user-images.githubusercontent.com/28475668/39559869-0d321384-4e5f-11e8-85c2-ce6e71e5e76b.png)


HOT VALVES QUERY
================
```sql
SELECT
    first_name,
    location_name,
    comp_name,
    cyl_1,
    cyl_2,
    cyl_3,
    cyl_4,
  CASE
    WHEN cyl_1 >= cyl_3 + 11 AND cyl_2 >= cyl_4 + 11 THEN 'all valves could be hot'
    WHEN cyl_1 >= cyl_3 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'all valves could be hot'
    WHEN cyl_3 >= cyl_1 + 15 AND cyl_2 >= cyl_4 + 15 THEN 'all valves could be hot'
    WHEN cyl_3 >= cyl_1 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'all valves could be hot'
    WHEN cyl_1 >= cyl_3 + 15  THEN 'cyl 1 or 3 might have hot valves'
    WHEN cyl_3 >= cyl_1 + 15  THEN 'cyl 1 or 3 might have hot valves'
    WHEN cyl_2 >= cyl_4 + 15 THEN 'cyl 2 or 4 might have hot valves'
    WHEN cyl_4 >= cyl_2 + 15 THEN 'cyl 2 or 4 might have hot valves'
    ELSE 'valves are ok'
  END AS 'VALVES'
FROM comp_log
JOIN compressors
    ON compressors.id = comp_log.comp_id
JOIN locations
    ON locations.id = compressors.location_id
JOIN operators 
    ON operators.location_id = locations.id 
WHERE operators.id = comp_log.operator_id 
ORDER BY created_at DESC;
```


TABLES
======

## Companies
| Field | Type         | Null | Key | Default | Extra          |
|------ | ------------ |----- | --- | ------- | -------------- |
| id    | int(11)      | NO   | PRI | NULL    | auto_increment |
| name  | varchar(100) | NO   |     | NULL    |                |


## Locations
| Field         | Type         | Null | Key | Default | Extra          |
|---------------|--------------|------|-----|---------|----------------|
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| location_name | varchar(100) | NO   |     | NULL    |                |
| company_id    | int(11)      | NO   | MUL | NULL    |                |


## Compressors
| Field       | Type        | Null | Key | Default | Extra          |
|-------------|-------------|------|-----|---------|----------------|
| id          | int(11)     | NO   | PRI | NULL    | auto_increment |
| comp_name   | varchar(20) | NO   |     | NULL    |                |
| company_id  | int(11)     | NO   | MUL | NULL    |                |
| location_id | int(11)     | NO   | MUL | NULL    |                |


## Operators
| Field       | Type         | Null | Key | Default | Extra          |
|-------------|--------------|------|-----|---------|----------------|
| id          | int(11)      | NO   | PRI | NULL    | auto_increment |
| first_name  | varchar(100) | NO   |     | NULL    |                |
| last_name   | varchar(100) | NO   |     | NULL    |                |
| company_id  | int(11)      | NO   | MUL | NULL    |                |
| location_id | int(11)      | NO   | MUL | NULL    |                |


## Comp_log
| Field         | Type      | Null | Key | Default           | Extra |
|---------------|-----------|------|-----|-------------------|-------|
| created_at    | timestamp | YES  |     | CURRENT_TIMESTAMP |       |
| suction       | int(11)   | YES  |     | 0                 |       |
| discharge     | int(11)   | YES  |     | 0                 |       |
| rpm           | int(11)   | YES  |     | 0                 |       |
| comp_load     | int(11)   | YES  |     | 0                 |       |
| hours         | int(11)   | YES  |     | 0                 |       |
| eng_temp      | int(11)   | YES  |     | 0                 |       |
| eng_psi       | int(11)   | YES  |     | 0                 |       |
| comp_temp     | int(11)   | YES  |     | 0                 |       |
| comp_psi      | int(11)   | YES  |     | 0                 |       |
| cyl_1         | int(11)   | YES  |     | 0                 |       |
| cyl_2         | int(11)   | YES  |     | 0                 |       |
| cyl_3         | int(11)   | YES  |     | 0                 |       |
| cyl_4         | int(11)   | YES  |     | 0                 |       |
| catalyst_temp | int(11)   | YES  |     | 0                 |       |
| comp_id       | int(11)   | NO   | MUL | NULL              |       |
| operator_id   | int(11)   | NO   | MUL | NULL              |       |


Note
----
This site has no SQL injection protection and is a prototype of something that natural gas operators would like if it was finished out. 
