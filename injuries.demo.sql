-- DAY 1

-- Create a new table

CREATE TABLE injuries
(
  id INTEGER PRIMARY KEY,
  name VARCHAR(40),
  description TEXT,
  tth INTEGER
);

-- What is a schema? https://raw.githubusercontent.com/statianzo/sql-course/master/images/falcon.jpg

-- Create data in our new table
INSERT INTO injuries
(id, name, description, tth)
VALUES (1, 'Pulled Groin', 'Results from putting too much stress on muscles in your groin and thigh.', 2);

-- Add the rest

INSERT INTO injuries (id, name, description, tth) VALUES (2, 'Cervical Radiculopathy', 'Pinched nerve.', 6);
INSERT INTO injuries (id, name, description, tth) VALUES (3, 'Herniated Disc', 'Soft substance on the inside of the disc (nucleus pulposi) is pushed out', 12);
INSERT INTO injuries (id, name, description, tth) VALUES (4, 'Femur Fracture', 'Bone fracture.', 8);
INSERT INTO injuries (id, name, description, tth) VALUES (5, 'Shattered Toenail', '20 percent of the US population suffers from onychorrhexis.', 3);
INSERT INTO injuries (id, name, description, tth) VALUES (6, 'Nintendo Thumb', 'Painful affliction of opposable digits.', 1);
INSERT INTO injuries (id, name, description, tth) VALUES (7, 'Amnesia', null, 1);
INSERT INTO injuries (id, name, description, tth) VALUES (8, 'Pulled Muscle', 'Results from putting too much stress on any muscles.', 2);

-- What does it mean to "query"?

-- Inspect entire table, returning all its records and columns.
SELECT * FROM injuries;

-- Inspect individual columns on a table.
SELECT name, description FROM injuries;

-- Summarize the Time-to-heal field
SELECT sum(tth) FROM injuries;

-- ! Try other functions: avg, min, max

-- Count the records
SELECT count(id) FROM injuries;
 
SELECT count(*) FROM injuries;

SELECT count(description) FROM injuries;

-- ? What's the difference?

-- Select expressions
SELECT name, tth * 30 FROM injuries;

SELECT upper(name) FROM injuries;

-- Constrain the results
SELECT * FROM injuries WHERE id = 2;
 
-- ! Try finding all injuries where id is greater than or equal to 2

-- Querying on strings
SELECT * FROM injuries WHERE name = 'Nintendo Thumb';

-- Null values
SELECT * FROM injuries WHERE description IS NULL;

-- Combine clauses
SELECT * FROM injuries WHERE tth < 10 AND description IS NOT NULL; 

-- ! How would you find injuries that take 9 or 10 months to heal?
-- ! Can you think of a second way to accomplish the same thing?

-- Pattern matching: https://www.postgresql.org/docs/8.3/static/functions-matching.html
SELECT * FROM injuries WHERE name LIKE 'Pulled%'

-- Enumerations
SELECT * FROM injuries WHERE id IN (1, 2, 3);

-- ! Can you find all records BUT 1, 2, and 3?

-- Sort the results
SELECT * FROM injuries ORDER BY tth;
SELECT * FROM injuries ORDER BY tth ASC;
SELECT * FROM injuries ORDER BY tth DESC;

-- Sort by multiple columns
SELECT * FROM injuries ORDER BY tth DESC, name ASC;

-- Limit the results
SELECT * FROM injuries ORDER BY tth DESC LIMIT 2;

-- Limit while skipping over an offset
SELECT * FROM injuries ORDER BY tth DESC LIMIT 2 OFFSET 2;

-- Random results
SELECT * FROM injuries ORDER BY random() LIMIT 1;

-- Distinct values
SELECT tth FROM injuries;           -- dupes
SELECT DISTINCT tth FROM injuries;  -- no dupes

-- END DAY NOTES:
--
-- EXPLAIN SELECT * FROM injuries WHERE name LIKE 'Pulled%'

-- DAY 2

-- Create an affectedAreas table
CREATE TABLE affectedAreas
(
  id INTEGER PRIMARY KEY,
  name VARCHAR(40)
);

INSERT INTO affectedAreas (id, name) VALUES (1, 'Groin');
INSERT INTO affectedAreas (id, name) VALUES (2, 'Neck');
INSERT INTO affectedAreas (id, name) VALUES (3, 'Leg');
INSERT INTO affectedAreas (id, name) VALUES (4, 'Foot');
INSERT INTO affectedAreas (id, name) VALUES (5, 'Head');
INSERT INTO affectedAreas (id, name) VALUES (6, 'Hand');
INSERT INTO affectedAreas (id, name) VALUES (7, 'Wrist');
INSERT INTO affectedAreas (id, name) VALUES (8, 'Ankle');
INSERT INTO affectedAreas (id, name) VALUES (9, 'Elbow');

-- Recreate our data from yesterday
CREATE TABLE injuries
(
  id INTEGER PRIMARY KEY,
  name VARCHAR(40),
  description TEXT,
  tth INTEGER
);

INSERT INTO injuries (id, name, description, tth) VALUES (1, 'Pulled Groin', 'Results from putting too much stress on muscles in your groin and thigh.', 2);
INSERT INTO injuries (id, name, description, tth) VALUES (2, 'Cervical Radiculopathy', 'Pinched nerve.', 6);
INSERT INTO injuries (id, name, description, tth) VALUES (3, 'Herniated Disc', 'Soft substance on the inside of the disc (nucleus pulposi) is pushed out', 12);
INSERT INTO injuries (id, name, description, tth) VALUES (4, 'Femur Fracture', 'Bone fracture.', 8);
INSERT INTO injuries (id, name, description, tth) VALUES (5, 'Shattered Toenail', '20 percent of the US population suffers from onychorrhexis.', 3);
INSERT INTO injuries (id, name, description, tth) VALUES (6, 'Nintendo Thumb', 'Painful affliction of opposable digits.', 1);
INSERT INTO injuries (id, name, description, tth) VALUES (7, 'Amnesia', null, 1);
INSERT INTO injuries (id, name, description, tth) VALUES (8, 'Pulled Muscle', 'Results from putting too much stress on any muscles.', 2);

-- Pick up in SQL.key

-- Add a foreign key to injuries
ALTER TABLE injuries ADD COLUMN affectedAreaId INTEGER REFERENCES affectedAreas(id);

-- Update the existing injuries
UPDATE injuries SET affectedAreaId = 1 WHERE id = 1;
UPDATE injuries SET affectedAreaId = 2 WHERE id = 2;
UPDATE injuries SET affectedAreaId = 2 WHERE id = 3;
UPDATE injuries SET affectedAreaId = 3 WHERE id = 4;
UPDATE injuries SET affectedAreaId = 4 WHERE id = 5;
UPDATE injuries SET affectedAreaId = 6 WHERE id = 6;
UPDATE injuries SET affectedAreaId = 6 WHERE id = 7;
UPDATE injuries SET affectedAreaId = 1 WHERE id = 8;

-- Combine the two tables into one query (e.g. Tell us everything about body parts and injuries!)
SELECT *
FROM affectedAreas
JOIN injuries ON affectedAreas.id = injuries.affectedAreaId;

-- Describe all neck injuries:
SELECT *
FROM affectedAreas
JOIN injuries ON affectedAreas.id = injuries.affectedAreaId
WHERE affectedAreas.name = 'Neck';

-- How can we limit the amount of information we query?
SELECT injuries.id, injuries.name
FROM affectedAreas
JOIN injuries ON affectedAreas.id = injuries.affectedAreaId
WHERE affectedAreas.name = 'Neck';

-- How about counting them?
SELECT count(*)
FROM affectedAreas
JOIN injuries ON affectedAreas.id = injuries.affectedAreaId
WHERE affectedAreas.name = 'Neck';

-- What if there are no injuries related to a body part?
SELECT injuries.id, injuries.name
FROM affectedAreas
JOIN injuries ON affectedAreas.id = injuries.affectedAreaId
WHERE affectedAreas.name = 'Wrist';
-- No results

-- Another way to describe all neck injuries: The Subquery
SELECT *
FROM injuries
WHERE affectedAreaId in (SELECT id FROM affectedAreas WHERE name = 'Neck');

-- Count the number of possible injuries for each body part
SELECT affectedAreas.name, count(*)
FROM affectedAreas
JOIN injuries ON affectedAreas.id = injuries.affectedAreaId
GROUP BY affectedAreas.name;

-- Another way to count: The Subquery
SELECT name, (SELECT count(*) FROM injuries WHERE injuries.affectedAreaId = affectedAreas.id)
FROM affectedAreas;

-- What was the difference?

-- Delete rows
DELETE FROM injuries;
