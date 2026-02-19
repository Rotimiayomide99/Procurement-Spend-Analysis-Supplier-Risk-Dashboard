select * from spend_analysis


1. Total Spend:
SELECT CAST(SUM(TotalCost) AS DECIMAL(10,2)) AS TotalSpend 
FROM dbo.spend_analysis;  

2. average transaction value
select cast(sum(totalcost)/count(transactionid) as decimal(10,2)) as average_transaction_value from dbo.spend_analysis

3. avg unit per category
select category, avg(quantity) as avg_unit_per_category from dbo.spend_analysis group by category

4. spend per category %
select category, cast(sum(totalcost) as decimal(10,2)) as spend_per_category, 
	   cast(sum(totalcost) * 100.0 / (select sum(totalcost) from dbo.spend_analysis) as decimal(10,2)) as spend_per_category_percentage
	   from dbo.spend_analysis group by category
5. spend per supplier %
select supplier, sum(totalcost) as spend_per_supplier, 
       cast(sum(totalcost) * 100.0 / (select sum(totalcost) from dbo.spend_analysis) as decimal(10,2)) as spend_per_supplier_percentage
       from dbo.spend_analysis group by supplier

6. total quantities purchased 
select SUM(Quantity) as total_quantities_purchased from dbo.spend_analysis

7. number of transactions per buyers
select buyer, count(transactionid) as number_of_transactions from dbo.spend_analysis group by buyer

8. cost per transaction per buyer
select buyer, cast(sum(totalcost) as decimal(10,2)) as total_cost_per_buyer, 
	   cast(sum(totalcost) / count(transactionid) as decimal(10,2)) as cost_per_transaction_per_buyer
	   from dbo.spend_analysis group by buyer

9. Supplier Concentration Ratio (Top 3 suppliers % of total spend) 
WITH Top3 AS (
    SELECT 
        supplier,
        SUM(TotalCost) AS TotalSpend
    FROM dbo.spend_analysis
    GROUP BY supplier
    ORDER BY TotalSpend DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
),
AllSpend AS (
    SELECT SUM(TotalCost) AS GrandTotal FROM dbo.spend_analysis
)
SELECT 
    t.supplier,
    FORMAT(t.TotalSpend, 'N2') AS TotalSpend,
    FORMAT((t.TotalSpend * 1.0 / a.GrandTotal), 'P2') AS PctOfTotalSpend
FROM Top3 t
CROSS JOIN AllSpend a 

10. MONTHLY SPEND TREND
SELECT 
    YEAR(PurchaseDate) AS Year,
    MONTH(PurchaseDate) AS Month,
    CAST(SUM(TotalCost) AS DECIMAL(10,2)) AS MonthlySpend
FROM dbo.spend_analysis
GROUP BY YEAR(PurchaseDate), MONTH(PurchaseDate)
ORDER BY YEAR(PurchaseDate), MONTH(PurchaseDate);   