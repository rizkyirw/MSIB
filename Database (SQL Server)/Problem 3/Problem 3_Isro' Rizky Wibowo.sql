USE [Construct,co];

-- 1. Write the SQL code required to list the employee number, last name, first name, and middle initial of all employees whose last names start with Smith. In other words, the rows for both Smith and Smithfield should be included in the listing. Sort the results by employee number. Assume case sensitivity.

SELECT EMP_NUM, 
EMP_LNAME, 
EMP_FNAME, 
EMP_INITIAL 
FROM EMPLOYEE
WHERE EMP_LNAME LIKE 'Smith%'
ORDER BY EMP_NUM

-- 2. Using the EMPLOYEE, JOB, and PROJECT tables in the Ch07_ConstructCo database, write the SQL code that will join the EMPLOYEE and PROJECT tables using EMP_NUM as the common attribute. Display the attributes shown in the results presented in Figure P7.2, sorted by project value.

-- ORDER BY PROJ_VALUE
SELECT PROJ_NAME, PROJ_VALUE, PROJ_BALANCE, EMP_LNAME, EMP_FNAME, EMP_INITIAL, E.JOB_CODE, JOB_DESCRIPTION, JOB_CHG_HOUR  
FROM PROJECT P
JOIN EMPLOYEE E
ON P.EMP_NUM = E.EMP_NUM
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
ORDER BY PROJ_VALUE

-- 3. Write the SQL code that will produce the same information that was shown in Problem 2, but sorted by the employee’s last name.

-- ORDER BY EMP_LNAME
SELECT EMP_LNAME, EMP_FNAME, EMP_INITIAL, E.JOB_CODE, PROJ_NAME, PROJ_VALUE, PROJ_BALANCE, JOB_DESCRIPTION, JOB_CHG_HOUR  
FROM PROJECT P
JOIN EMPLOYEE E
ON P.EMP_NUM = E.EMP_NUM
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
ORDER BY EMP_LNAME

-- 4. Write the SQL code that will list only the distinct project numbers in the ASSIGNMENT table, sorted by project number.

SELECT DISTINCT PROJ_NUM 
FROM ASSIGNMENT
ORDER BY PROJ_NUM

-- 5. Write the SQL code to validate the ASSIGN_CHARGE values in the ASSIGNMENT table. Your query should retrieve the assignment number, employee number, project number, the stored assignment charge (ASSIGN_CHARGE), and the calculated assignment charge (calculated by multiplying ASSIGN_CHG_HR by ASSIGN_HOURS). Sort the results by the assignment number.

SELECT ASSIGN_NUM, EMP_NUM, PROJ_NUM, ASSIGN_CHARGE, ASSIGN_CHG_HR*ASSIGN_HOURS 'Calculated Assignment Charge' 
FROM ASSIGNMENT

-- 6. Using the data in the ASSIGNMENT table, write the SQL code that will yield the total number of hours worked for each employee and the total charges stemming from those hours worked, sorted by employee number. The results of running that query are shown in Figure P7.6.

SELECT E.EMP_NUM, EMP_LNAME, ROUND(SUM(ASSIGN_HOURS),2) SumOfASSIGN_HOURS, ROUND(SUM(ASSIGN_CHARGE),2) SumOfASSIGN_CHARGE
FROM ASSIGNMENT A
JOIN EMPLOYEE E 
ON A.EMP_NUM=E.EMP_NUM
GROUP BY E.EMP_NUM, EMP_LNAME
ORDER BY EMP_NUM

-- 7. Write a query to produce the total number of hours and charges for each of the projects represented in the ASSIGNMENT table, sorted by project number. The output is shown in Figure P7.7.

SELECT A.PROJ_NUM, ROUND(SUM(ASSIGN_HOURS),2) SumOfASSIGN_HOURS, ROUND(SUM(ASSIGN_CHARGE),2) SumOfASSIGN_CHARGE
FROM ASSIGNMENT A 
JOIN PROJECT P
ON A.PROJ_NUM=P.PROJ_NUM
GROUP BY A.PROJ_NUM
ORDER BY PROJ_NUM

-- 8. Write the SQL code to generate the total hours worked and the total charges made by all employees. The results are shown in Figure P7.8.

SELECT ROUND(SUM(ASSIGN_HOURS),2) SumOfASSIGN_HOURS, ROUND(SUM(ASSIGN_CHARGE),2) SumOfASSIGN_CHARGE
FROM ASSIGNMENT A
JOIN EMPLOYEE E
ON E.EMP_NUM=A.EMP_NUM
