-- 1. Use a CTE to calc total sales for each month in year 2012. Want month and total sales amount. --
-- Need sum of (Total) column in invoices table. Want to use InvoiceDate to obtain month. --

WITH MonthSales AS (
     SELECT Round(SUM(Total), 2) AS MonthlyTotal, STRFTIME('%m', InvoiceDate) AS Month -- Selecting Sum of Total and Month specifically from Invoices table. --
     FROM invoices
     WHERE STRFTIME('%Y', InvoiceDate) = '2012' -- Filtering for only months that are 2012. --
     GROUP BY Month
     ORDER BY Month
)

SELECT MonthlyTotal, Month
FROM MonthSales;

-- 2. Calculate running total of sales for each customer, include customer name, invoice date, invoice total, running total. --
-- Need customer info and invoice info. Want to recount whenever a new customerId is hit. Want a Sum of total again. --

SELECT c.FirstName || ' ' || c.LastName AS FullName, i.InvoiceDate, i.total AS InvoiceTotal,
     SUM (i.Total) OVER(PARTITION BY c.CustomerId
                        ORDER BY i.InvoiceDate) AS RunningTotal -- Window fx to partition by customerid, ordering by date, creating a running total. --
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
ORDER BY FullName, InvoiceDate;

-- 3. ID highest spending customer in each country, include country, customer name, and total spending. -- 
-- Need a Sum of spending by customer (group by customer). Then want to rank customers in each country by total amount spent. --
-- Two CTEs: One getting a sum by customer, next ranking. --

WITH CustomerSpending AS (
     SELECT c.FirstName || ' ' || c.LastName AS FullName,
     c.Country,
     SUM (i.Total) AS TotalSpending
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY Country, c.CustomerId), -- Denoting customerid from the customers table for this, as otherwise this would return an ambiguous column error. --

RankedSpending AS (
     SELECT Country, FullName, TotalSpending,
            RANK() OVER(PARTITION BY Country ORDER BY TotalSpending DESC) -- Ranking by total within each country category. --
            AS SpendingRank
     FROM CustomerSpending)

SELECT Country, FullName, TotalSpending -- Finally, selecting the top spenders from each country. --
FROM RankedSpending
WHERE SpendingRank = 1;


-- In sum, made 2 CTEs, the first which creates a table with the sum of total customer spending by country, utilizing customers and invoices table. --
-- 2nd CTE creates a table that ranks the Countries by totalspending from the 1st, and orders them by Total spent. --