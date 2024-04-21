-- SQL style guidelines: https://www.sqlstyle.guide/

/* CREATE TABLE: create a table inside a database */
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR (255) NOT NULL,
    box_office BIGINT,
    budget BIGINT,
    country VARCHAR (255),
    language VARCHAR (255),
    year INT
);

CREATE TABLE people (
    people_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (255) NOT NULL,
    birthdate DATE,
    deathdate DATE,
    sex VARCHAR (1)
);

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    people_id INT NOT NULL,
    description VARCHAR (255) NOT NULL,
);

/* DISTINCT: select all the unique values from a column */
SELECT DISTINCT language
FROM movies;

/* COUNT: gives the number of rows in the table */
SELECT COUNT(*)
FROM people;

/* COUNT and DISTINCT: counts the number of distinct birth dates in the people table */
SELECT COUNT(DISTINCT birthdate)
FROM people;

/* WHERE: allows filtering based on both text and numeric values in a table */
SELECT *
FROM movies
WHERE box_office > 10000;

/* WHERE */
SELECT title
FROM movies
WHERE country = 'China';

/* WHERE with AND */
SELECT title
FROM movies
WHERE year > 1995
    AND year < 2001;

/* WHERE with BETWEEN: filters values within a specified range */
SELECT title
FROM movies
WHERE year BETWEEN 1995 AND 2001;

/* WHERE with IN: allows specifying multiple values */
SELECT year
FROM movies
WHERE year IN (1999, 2000, 2001);

/* IS NULL:  missing or unknown value */
SELECT COUNT(*)
FROM people
WHERE birthdate IS NULL;

/* IS NOT NULL: not missing neither unknown value */
SELECT name
FROM people
WHERE birthdate IS NOT NULL;

/* LIKE with % : matches 0, 1, or many characters in the text */
SELECT name
FROM people
WHERE name LIKE 'Cameron%';

/* LIKE with _ : matches a single character */
SELECT name
  FROM people
 WHERE name LIKE 'M_ry';


/* AGGREGATE FUNCTIONS */

/* AVG: average value from a column in a table */
SELECT AVG(budget)
FROM movies;

/* MAX: returns the highest value in a column */
SELECT MAX(budget)
FROM movies;

/* MIN: returns the lowest value in a column */
SELECT MIN(budget)
FROM movies;

/* SUM: returns the result of adding up the numeric values in a column */
SELECT SUM(budget)
FROM movies
WHERE year >= 2010;

/* ARITHMETIC: we can perform basic arithmetic */
SELECT (4 * 3);

/* Give an integer result */
SELECT (4 / 3);

/* Add decimal places */
SELECT (4.0 / 3.0) AS result;

/* ALIASING: assigning a temporary name to something */
SELECT MAX(budget) AS max_budget,
       MAX(box_office) AS max_box_office
FROM movies;

/*  ORDER BY: sorts in ascending order
    ORDER BY (column) DESC: sorts in descending order */
SELECT title
FROM movies
ORDER BY year DESC;

/* Sort the 1st column first (oldest to newest) and then the 2nd in alphabetical order */
SELECT birthdate, name
FROM people
ORDER BY birthdate, name; 

/* GROUP BY: group a result by one or more columns */
SELECT sex, count(*)
FROM people
GROUP BY sex;

/* GROUP BY with ORDER BY */
SELECT sex, count(*)
FROM people
GROUP BY sex
ORDER BY count DESC;

/* HAVING: allows filtering based on the result of an aggregate function */
SELECT year
FROM movies
GROUP BY year
HAVING COUNT(title) > 10;

/* JOIN: allows querying multiple tables */
SELECT roles.description
FROM roles
INNER JOIN movies ON roles.movie_id = movies.movie_id
WHERE movies.title = 'Gone with the Wind';
