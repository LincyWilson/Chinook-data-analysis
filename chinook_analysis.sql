USE `Chinook`;

# 1) Write a query to see how many tracks are not purchased at least once, and display the percentage of tracks purchased at least once.

SELECT COUNT(*) AS TracksNotPurchased, 
ROUND((1 - COUNT(*) / (SELECT COUNT(*) FROM track)) * 100,2) AS PercentageofTracks
FROM track 
WHERE TrackId NOT IN 
(SELECT DISTINCT TrackId FROM invoiceline);


# 2) Write a query to see the number of tracks purchased, percentage of tracks purchased, total sales and sales percentage made on tracks, based on genre.

SELECT g.Name AS GenreName, t.GenreId, COUNT(il.TrackId) AS NumberofTracks, 
COUNT(il.TrackId) / (SELECT COUNT(TrackId) FROM track t1 WHERE t1.GenreId = t.GenreId) * 100 AS PercentageofTracks, 
SUM(il.UnitPrice * il.Quantity) AS TotalSales,
SUM(il.UnitPrice * il.Quantity) / (SELECT SUM(UnitPrice * Quantity) FROM invoiceline il1) * 100 AS SalesPercentage
FROM genre AS g, track AS t, invoiceline AS il
WHERE t.trackId = il.TrackId
AND t.GenreId = g.GenreId
GROUP BY t.GenreId;


# 3) Write a query to see the total sales across each country.

SELECT * FROM invoice;
SELECT CONCAT('$', SUM(Total)) AS Total_Sales, BillingCountry AS Country FROM invoice
GROUP BY BillingCountry
ORDER BY BillingCountry;


# 4) Provide a query that shows the most purchased track of 2011.

SELECT t.Name, COUNT(i.InvoiceId) AS NumberofPurchasesin2011
FROM Track AS t, InvoiceLine As il, Invoice AS i
WHERE t.TrackId = il.TrackId 
AND il.InvoiceId = i.InvoiceId
AND i.InvoiceDate LIKE "%2011%"
GROUP BY t.Name
ORDER BY COUNT(il.InvoiceId)
DESC LIMIT 1;


# 5. Write a query to find number of invoices generated, total sales performed, and sales per invoice brought by the company's sales representatives. 

SELECT CONCAT(e.FirstName, " ", e.LastName) AS "Sales Agent Name", COUNT(i.invoiceID) as "No. of Invoices", 
CONCAT('$', SUM(i.Total)) AS "Total Sales",
SUM(i.Total) / COUNT(i.invoiceID) AS "SalesPerInvoice"
FROM Invoice AS i, Employee AS e, Customer AS c 
WHERE i.CustomerId = c.CustomerId 
AND c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId
ORDER BY e.EmployeeId;


# 8. Write a query to see the percentage of tracks purchased separately and an entire album purchased.

WITH
    tracks_in_invoice AS (
        SELECT
            il.InvoiceId,
            COUNT(DISTINCT il.TrackId) AS tracks_in_invoice
        FROM
            invoiceline as il
        GROUP BY
            il.invoiceid
    ),
    album_tracks_count AS (
        SELECT
            il.InvoiceId,
            COUNT(DISTINCT t.TrackId) AS tracks_in_album
        FROM
            invoiceline il
            JOIN track t ON t.TrackId = il.TrackId
        GROUP BY
            il.InvoiceId, t.AlbumId
    )
   
SELECT
    ROUND(COUNT(atc.InvoiceId) / COUNT(tii.InvoiceId)* 100.0 , 2) AS percentage_album_purchased,
    ROUND(COUNT(tii.InvoiceId) / COUNT(atc.InvoiceId)* 100.0, 2) AS percentage_tracks_purchased
FROM
    tracks_in_invoice tii
    LEFT JOIN album_tracks_count atc ON tii.InvoiceId = atc.InvoiceId AND tii.tracks_in_invoice = atc.tracks_in_album;


# 7) Write a query to display the number of customers, average sales per invoice, and average sales per customer for each country

SELECT BillingCountry, COUNT(DISTINCT CustomerId) AS NumberofCustomers, SUM(Total) / COUNT(InvoiceId) AS AvgSalesPerInvoice, 
SUM(Total) / COUNT(DISTINCT CustomerId) AS AvgSalesPerCustomer
FROM invoice 
GROUP BY BillingCountry;


# 8. Write a query to see the percentage of tracks purchased separately and an entire album purchased.

WITH
    tracks_in_invoice AS (
        SELECT
            il.InvoiceId,
            COUNT(DISTINCT il.TrackId) AS tracks_in_invoice
        FROM
            invoiceline as il
        GROUP BY
            il.invoiceid
    ),
    album_tracks_count AS (
        SELECT
            il.InvoiceId,
            COUNT(DISTINCT t.TrackId) AS tracks_in_album
        FROM
            invoiceline il
            JOIN track t ON t.TrackId = il.TrackId
        GROUP BY
            il.InvoiceId, t.AlbumId
    )
   
SELECT
    ROUND(COUNT(atc.InvoiceId) / COUNT(tii.InvoiceId)* 100.0 , 2) AS percentage_album_purchased,
    ROUND(COUNT(tii.InvoiceId) / COUNT(atc.InvoiceId)* 100.0, 2) AS percentage_tracks_purchased
FROM
    tracks_in_invoice tii
    LEFT JOIN album_tracks_count atc ON tii.InvoiceId = atc.InvoiceId AND tii.tracks_in_invoice = atc.tracks_in_album;