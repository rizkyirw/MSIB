-- ISRO' RIZKY WIBOWO
-- KELAS DATA ANALYST I

Use [SaleCo];

-- 1. Write a query to count the number of invoices.
SELECT COUNT(*) FROM INVOICE

-- 2. Write a query to count the number of customers with a balance of more than $500.
SELECT COUNT(*) FROM CUSTOMER
WHERE CUS_BALANCE > 500

-- 3. Generate a listing of all purchases made by the customers, using the output shown in Figure P7.11 as your guide. Sort the results by customer code, invoice number, and product description.
SELECT C.CUS_CODE, I.INV_NUMBER, I.INV_DATE, PROD.P_DESCRIPT, L.LINE_UNITS, L.LINE_PRICE
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
JOIN PRODUCT PROD
ON L.P_CODE = PROD.P_CODE
ORDER BY C.CUS_CODE, I.INV_NUMBER, PROD.P_DESCRIPT ASC;

-- 4. Using the output shown in Figure P7.12  is a derived attribute calculated by multiplying LINE_UNITS by LINE_PRICE. Sort the output by customer code, invoice number, and product description. Be certain to use the column aliases as shown in the figure.
SELECT C.CUS_CODE, I.INV_NUMBER, PROD.P_DESCRIPT, L.LINE_UNITS, L.LINE_PRICE, (L.LINE_UNITS*L.LINE_PRICE) AS SUBTOTAL
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
JOIN PRODUCT PROD
ON L.P_CODE = PROD.P_CODE
ORDER BY C.CUS_CODE, I.INV_NUMBER, PROD.P_DESCRIPT ASC;

-- 5. Write a query to display the customer code, balance, and total purchases for each customer. Total purchase is calculated by summing the line subtotals (as calculated in Problem 12) for each customer. Sort the results by customer code, and use aliases as shown in Figure P7.13.
SELECT C.CUS_CODE, C.CUS_BALANCE, ROUND(SUM(L.LINE_UNITS*L.LINE_PRICE),2) AS TOTAL_PURCHASES
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE

-- 6. Modify the query in Problem 5 to include the number of individual product purchases made by each customer. (In other words, if the customer’s invoice is based on three products, one per LINE_NUMBER, you count three product purchases. Note that in the original invoice data, customer 10011 generated three invoices, which contained a total of six lines, each representing a product purchase.) Your output values must match those shown in Figure P7.14, sorted by customer code.
SELECT C.CUS_CODE, C.CUS_BALANCE, ROUND(SUM(L.LINE_UNITS*L.LINE_PRICE),2) AS TOTAL_PURCHASES, COUNT (C.CUS_CODE) AS NUMBER_OF_PURCHASES
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE

-- 7. Use a query to compute the total of all purchases, the number of purchases, and the average purchase amount made by each customer. Your output values must match those shown in Figure P7.15. Sort the results by customer code.
SELECT C.CUS_CODE, C.CUS_BALANCE, ROUND(SUM(L.LINE_UNITS*L.LINE_PRICE),2) AS TOTAL_PURCHASES, COUNT(C.CUS_CODE) AS NUMBER_OF_PURCHASES, ROUND(ROUND(SUM(L.LINE_UNITS*L.LINE_PRICE),2)/COUNT(C.CUS_CODE),2) AS AVG_PURCHASE_AMOUNT
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE

-- 8. Create a query to produce the total purchase per invoice, generating the results shown in Figure P7.16, sorted by invoice number. The invoice total is the sum of the product purchases in the LINE that corresponds to the INVOICE.
SELECT I.INV_NUMBER, ROUND(SUM(L.LINE_PRICE*LINE_UNITS),2) AS INVOICE_TOTAL
FROM INVOICE I
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.INV_NUMBER

-- 9. Use a query to show the invoices and invoice totals in Figure P7.17. Sort the results by customer code and then by invoice number.
SELECT C.CUS_CODE, I.INV_NUMBER, ROUND(SUM(L.LINE_PRICE*LINE_UNITS),2) AS INVOICE_TOTAL
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, I.INV_NUMBER

-- 10. Write a query to produce the number of invoices and the total purchase amounts by customer, using the output shown in Figure P7.18 as your guide. Note the results are sorted by customer code. (Compare this summary to the results shown in Problem 9.)
SELECT C.CUS_CODE, COUNT( DISTINCT I.INV_NUMBER) AS NUMBER_OF_INVOICES ,ROUND(SUM(L.LINE_UNITS*L.LINE_PRICE),2) AS TOTAL_CUSTOMER_PURCHASES
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L
ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE

-- 11. Write a query to generate the total number of invoices, the invoice total for all of the invoices, the smallest of the customer purchase amounts, the largest of the customer purchase amounts, and the average of all the customer purchase amounts. Your out- put must match Figure P7.19.
SELECT SUM("NUM_OF_INV") AS TOTAL_INVOICES,
ROUND(SUM("TOTAL_CUST_PURCHASES"),2) AS TOTAL_SALES,
ROUND(MIN("TOTAL_CUST_PURCHASES"),2) AS MINIMUM_CUST_PURCHASES,
ROUND(MAX("TOTAL_CUST_PURCHASES"),2) AS LARGEST_CUST_PURCHASES,
ROUND(AVG("TOTAL_CUST_PURCHASES"),2) AS AVERAGE_CUST_PURCHASES
FROM (SELECT DISTINCT I.CUS_CODE,
COUNT(DISTINCT I.INV_NUMBER) AS "NUM_OF_INV",
SUM(LINE_PRICE*LINE_UNITS) AS "TOTAL_CUST_PURCHASES"
FROM CUSTOMER C, INVOICE I, LINE L
WHERE C.CUS_CODE=I.CUS_CODE
AND I.INV_NUMBER=L.INV_NUMBER
GROUP BY I.CUS_CODE) CUST_PURCHASES_DETAIL

-- 12. List the balances of customers who have made purchases during the current invoice cycle—that is, for the customers who appear in the INVOICE table. The results of this query are shown in Figure P7.20, sorted by customer code.
SELECT DISTINCT C.CUS_CODE, C.CUS_BALANCE
FROM CUSTOMER C, INVOICE I
WHERE C.CUS_CODE = I.CUS_CODE
ORDER BY C.CUS_CODE

-- 13. Provide a summary of customer balance characteristics for customers who made purchases. Include the minimum balance, maximum balance, and average balance, as shown in Figure P7.21.
SELECT MIN(C.CUS_BALANCE) AS MINIMUM_BALANCE, 
ROUND(MAX(C.CUS_BALANCE),2) AS MAXIMUM_BALANCE,
ROUND(SUM(C.CUS_BALANCE)/COUNT (DISTINCT C.CUS_CODE),2) AS AVERAGE_BALANCE
FROM CUSTOMER C
JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE

-- 14. Create a query to find the balance characteristics for all customers, including the total of the outstanding balances. The results of this query are shown in Figure P7.22.
SELECT ROUND(SUM(C.CUS_BALANCE),2) AS TOTAL_BALANCE,
MIN(C.CUS_BALANCE) AS MINIMUM_BALANCE, 
ROUND(MAX(C.CUS_BALANCE),2) AS MAXIMUM_BALANCE,
ROUND(AVG(C.CUS_BALANCE),2) AS AVERAGE_BALANCE
FROM CUSTOMER C

-- 15. Find the listing of customers who did not make purchases during the invoicing period. Sort the results by customer code. Your output must match the output shown in Figure P7.23.
SELECT C.CUS_CODE, C.CUS_BALANCE
FROM CUSTOMER C
LEFT JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
WHERE I.INV_NUMBER IS NULL
ORDER BY C.CUS_CODE ASC

-- 16. Find the customer balance summary for all customers who have not made purchases during the current invoicing period. The results are shown in Figure P7.24.
SELECT ROUND(SUM(C.CUS_BALANCE),2) AS TOTAL_BALANCE,
ROUND(MIN(C.CUS_BALANCE),2) AS MINIMUM_BALANCE,
ROUND(MAX(C.CUS_BALANCE),2) AS MAXIMUM_BALANCE,
ROUND(AVG(C.CUS_BALANCE),2) AS AVERAGE_BALANCE
FROM CUSTOMER C
LEFT JOIN INVOICE I
ON C.CUS_CODE = I.CUS_CODE
WHERE I.INV_NUMBER IS NULL

-- 17. Create a query that summarises the value of products currently in inventory. Note that the value of each product is a result of multiplying the units currently in inventory by the unit price. Sort the results in descending order by subtotal, as shown in Figure P7.25.
SELECT P_DESCRIPT, P_QOH, P_PRICE, (P_QOH*P_PRICE) AS SUBTOTAL
FROM PRODUCT
ORDER BY SUBTOTAL DESC

-- 18. Find the total value of the product inventory. The results are shown in Figure P7.26.
SELECT ROUND(SUM(P_QOH*P_PRICE),2) AS TOTAL_VALUE_OF_INVENTORY
FROM PRODUCT