--Cleaning in SQL


Select *
FROM DutSales


-- Fix Date

Select CONVERT(Date, [Settle Date])
FROM DutSales


ALTER TABLE DutSales
Add SaleDateConverted Date;

Update DutSales
SET SaleDateConverted = CONVERT(Date,[Settle Date])


-- Separating Address from City

Select PARSENAME(REPLACE(Address, ',','.'),2),
PARSENAME(REPLACE(Address, ',','.'),1)
From DutSales


ALTER TABLE DutSales
Add SplitAddress Nvarchar(255);

Update DutSales
SET SplitAddress = PARSENAME(REPLACE(Address, ',', '.') , 2)


ALTER TABLE DutSales
Add SplitCity Nvarchar(255);

Update DutSales
SET SplitCity = PARSENAME(REPLACE(Address, ',', '.') , 1)


--Reduce/clarify number of options in Property Class

Select DISTINCT([Property Class]), COUNT([Property Class])
FROM DutSales
GROUP BY [Property Class]
Order BY COUNT([Property Class]) DESC



Select [Property Class],
  CASE WHEN [Property Class] = 'Single Family Resid' THEN 'Single Fam'
     WHEN [Property Class] = 'Vacant Resid' THEN 'Res Land'
	 WHEN [Property Class] = 'Apartments' THEN 'Condo'
	 WHEN [Property Class] = '2 Family Resid' THEN 'Multi Fam'
	 WHEN [Property Class] = '3 Family Resid' THEN 'Multi Fam'
	 ELSE 'Other'
	 END
FROM DutSales


Update DutSales
SET [Property Class] =  CASE WHEN [Property Class] = 'Single Family Resid' THEN 'Single Fam'
     WHEN [Property Class] = 'Vacant Resid' THEN 'Res Land'
	 WHEN [Property Class] = 'Apartments' THEN 'Condo'
	 WHEN [Property Class] = '2 Family Resid' THEN 'Multi Fam'
	 WHEN [Property Class] = '3 Family Resid' THEN 'Multi Fam'
	 ELSE 'Other'
	 END




	 -- Remove duplicates

	 Select *,
	   ROW_NUMBER () OVER(
	   PARTITION BY [Tax ID],
					Address,
					[Last Sale Price],
					SaleDateConverted,
					[Tax Amount]
				ORDER BY 
					[Tax ID]
					) row_num

	 FROM DutSales




	 
	 
	 WITH RowNumCTE AS(
		Select *,
	   ROW_NUMBER () OVER(
	   PARTITION BY [Tax ID],
					Address,
					[Last Sale Price],
					SaleDateConverted,
					[Tax Amount]
				ORDER BY 
					[Tax ID]
					) row_num

	 FROM DutSales
	 )
	 Select *
From RowNumCTE
Where row_num > 1
Order by Address

	 WITH RowNumCTE AS(
		Select *,
	   ROW_NUMBER () OVER(
	   PARTITION BY [Tax ID],
					Address,
					[Last Sale Price],
					SaleDateConverted,
					[Tax Amount]
				ORDER BY 
					[Tax ID]
					) row_num

	 FROM DutSales
	 )
	 DELETE *
From RowNumCTE
Where row_num > 1
Order by Address


-- Delete unneeded columns

Select *
FROM DutSales


Alter Table DutSales
DROP COLUMN address, [Settle Date]

