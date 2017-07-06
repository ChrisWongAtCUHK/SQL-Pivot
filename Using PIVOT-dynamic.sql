USE AdventureWorks2008R2 ;
GO

DECLARE @col VARCHAR(1000);
DECLARE @sql VARCHAR(2000)

;WITH cte AS 
(
	SELECT DaysToManufacture
	FROM Production.Product
	GROUP BY DaysToManufacture
	HAVING AVG(StandardCost) > 300
)
SELECT @col = COALESCE(@col + ', ','') + QUOTENAME(DaysToManufacture)
FROM cte

-- Pivot table with one row and five columns
SET @sql = 'SELECT ''AverageCost'' AS Cost_Sorted_By_Production_Days, 
' + @col +'
FROM
(SELECT DaysToManufacture, StandardCost 
    FROM Production.Product) AS SourceTable
PIVOT
(
AVG(StandardCost)
FOR DaysToManufacture IN (' + @col + ')
) AS PivotTable'

EXEC (@sql)
