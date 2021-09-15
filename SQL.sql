-- Average summary of sales
SELECT
AVG(pack) AS Average_number_of_bottles_per_pack,
AVG(sale_dollars) AS Average_sale_val,
AVG(bottles_sold) AS Average_num_bottles_sold,
COUNT(bottles_sold) AS total_bottles_sold
 FROM `Project.Sales`

-- Creating a table for sales of beverages by volume organized by type
CREATE TABLE IF NOT EXISTS Sales_by_volume
AS
SELECT
SUM(volume_sold_gallons) AS total_gallons_sold,
category_name
FROM `Project.Sales`
GROUP BY category_name
ORDER BY total_gallons_sold DESC

-- Creating a table which contains total values of sales for each type
CREATE TABLE IF NOT EXISTS Total_sales_by_type
AS
SELECT
category_name,
SUM(sale_dollars) AS total_sales_dollars,
 FROM `Project.Sales`
group by category_name
order by total_sales_dollars DESC

--Creating a temp table which combines the previous two tables
DROP TABLE IF EXISTS #TempSalessums
CREATE TABLE #TempSalessums (
category_name  varchar(50)
total_sales_dollars float(50)
total_gallons_sold float(50)
)
INSERT INTO #TempSalessums
  SELECT
  m.category_name,
  total_sales_dollars,
  c.total_gallons_sold
    FROM `Project.Total_sales_by_type` AS m
    Join `Project.Sales_by_volume` AS c
    on m.category_name=c.category_name

--Total values calculated from the temp table
SELECT
SUM(total_sales_dollars),
SUM(total_gallons_sold)
FROM `Project.#TempSalesSums`
