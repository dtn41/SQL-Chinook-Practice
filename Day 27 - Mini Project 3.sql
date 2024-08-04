-- 1. Find average invoice total BY customer (name, invoice total), only if they have an average invoice total >6.0. --
SELECT c.FirstName || " " || c.LastName AS Fullname,
    ROUND(AVG(i.Total), 1) AS AvgInvoiceTotal
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING AvgInvoiceTotal > 6.0
ORDER BY AvgInvoiceTotal DESC;

-- 2. What are the top 10 customers with the most invoices (full name and count of invoices) --
SELECT c.FirstName || " " || c.LastName AS Fullname,
    COUNT(i.InvoiceId) AS InvoiceCount
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY InvoiceCount DESC
LIMIT 10;

-- 3. Top 10 customers with most invoices by purchase amount (Total). --
SELECT c.FirstName || " " || c.LastName AS Fullname,
    SUM(i.Total) AS TotalAmount
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalAmount DESC
LIMIT 10;

-- 4. What are the total sales by country? (Countries with most sales). --
SELECT c.Country, ROUND(SUM(i.Total), 2) AS TotalSales
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY TotalSales DESC
LIMIT 10;