-- Have a look at the PostgreSQL database
SELECT table_schema, table_name  
FROM information_schema.tables; 

-- Have a look at the columns of a certain table
SELECT table_name, column_name, data_type 
FROM information_schema.columns  
WHERE table_name = 'pg_config';

""" Query information_schema with SELECT
Get information on all table names in the current database, while limiting your query to the 'public' table_schema. """
-- Query the right table in information_schema
SELECT table_name 
FROM information_schema.tables
-- Specify the correct table_schema value
WHERE table_schema = 'public';

-- Query the right table in information_schema to get columns
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'university_professors' AND table_schema = 'public';

""" CREATE your first few TABLEs
Create a table professors with two text columns: firstname and lastname."""
-- Create a table for the professors entity type
CREATE TABLE professors (
 firstname text,
 lastname text
);
-- Print the contents of this table
SELECT * 
FROM professors;

-- Create a table for the universities entity type
CREATE TABLE universities (
 university_shortname text,
 university text,
 university_city text
);
-- Print the contents of this table
SELECT * 
FROM universities;

""" ADD a COLUMN with ALTER TABLE
Alter professors to add the text column university_shortname."""
-- Add the university_shortname column
ALTER TABLE professors
ADD university_shortname text;
-- Print the contents of this table
SELECT * 
FROM professors;

"""RENAME and DROP COLUMNs in affiliations"""
-- Rename the organisation column
ALTER TABLE affiliations
RENAME COLUMN organisation TO organization;

-- Delete the university_shortname column
ALTER TABLE affiliations
DROP COLUMN university_shortname;

"""Migrate data with INSERT INTO SELECT DISTINCT

    Insert all DISTINCT professors from university_professors into professors.
    Print all the rows in professors."""
-- Insert unique professors into the new table
INSERT INTO professors 
SELECT DISTINCT firstname, lastname, university_shortname 
FROM university_professors;
-- Doublecheck the contents of professors
SELECT * 
FROM professors;

-- The INSERT INTO statement
INSERT INTO table_name (column_a, column_b) 
VALUES ("value_a", "value_b"); 

"""Insert all DISTINCT affiliations into affiliations from university_professors."""
-- Insert unique affiliations into the new table
INSERT INTO affiliations 
SELECT DISTINCT firstname, lastname, function, organization 
FROM university_professors;

-- Doublecheck the contents of affiliations
SELECT * 
FROM affiliations;

"""Delete tables with DROP TABLE"""
-- Delete the university_professors table
DROP TABLE university_professors;


CREATE TABLE transactions (
 transaction_date date, 
 amount integer,
 fee text
);
-- Let's add a record to the table
INSERT INTO transactions (transaction_date, amount, fee) 
VALUES ('2018-09-24', 5454, '30');
-- Doublecheck the contents
SELECT *
FROM transactions;

""" Working with data types"""
-- Type CASTs
-- Calculate the net amount as amount + fee
SELECT transaction_date, amount + CAST(fee AS integer) AS net_amount 
FROM transactions;

CREATE TABLE students ( 
 ssn integer,  
 name varchar(64),  
 dob date,  
 average_grade numeric(3, 2), -- e.g. 5.54 
 tuition_paid boolean  
); 

"""Change types with ALTER COLUMN"""
-- Select the university_shortname column
SELECT DISTINCT( university_shortname) 
FROM professors;

-- Specify the correct fixed-length character type
ALTER TABLE professors
ALTER COLUMN university_shortname
TYPE char(3);

ALTER TABLE students 
ALTER COLUMN name  
TYPE varchar(128); 

-- Change the type of firstname
ALTER TABLE professors
ALTER COLUMN firstname
TYPE varchar(64);

"""Convert types USING a function"""
ALTER TABLE students 
ALTER COLUMN average_grade 
TYPE integer 
-- Turns 5.54 into 6, not 5, before type conversion 
USING ROUND(average_grade); 

-- Convert the values in firstname to a max. of 16 characters
ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)
USING SUBSTRING(firstname FROM 1 FOR 16)

"""Disallow NULL values with SET NOT NULL"""
-- Disallow NULL values in firstname
ALTER TABLE professors 
ALTER COLUMN firstname SET NOT NULL;

-- Disallow NULL values in lastname
ALTER TABLE professors 
ALTER COLUMN lastname SET NOT NULL;

CREATE TABLE students ( 
 ssn integer not null, 
 lastname varchar(64) not null, 
 home_phone integer, 
 office_phone integer 
); 

ALTER TABLE students  
ALTER COLUMN home_phone  
SET NOT NULL; 

ALTER TABLE students  
ALTER COLUMN ssn  
DROP NOT NULL; 

"""Make your columns UNIQUE with ADD CONSTRAINT
Add a unique constraint to the university_shortname column in universities. Give it the name university_shortname_unq."""
CREATE TABLE table_name ( 
 column_name UNIQUE 
); 
ALTER TABLE table_name 
ADD CONSTRAINT some_name UNIQUE(column_name); 


-- Make universities.university_shortname unique
ALTER TABLE universities
ADD CONSTRAINT university_shortname_unq UNIQUE(university_shortname);

"""Add a unique constraint to the organization column in organizations. Give it the name organization_unq."""
-- Make organizations.organization unique
ALTER TABLE organizations
ADD CONSTRAINT organization_unq UNIQUE(organization);

