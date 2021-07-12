USE TUIOlap;

SELECT date, 
	   'RUSSIA & ABKHAZIA' AS 'Country',

		(SELECT SUM(PAX)
		 FROM AnaplanImport.ProductPlan
		 WHERE Country = 'RUSSIA/ ABKHAZIA'  
			  AND BusinessEntity = 'Russia' 
			  AND BaseUpdate = 'Update'
			  AND DATEPART(ISO_WEEK, CreationWeek) = DATEPART(ISO_WEEK, date)
			  AND DATEPART(YEAR, CreationWeek) = DATEPART(YEAR, date)) * [Proc] AS 'PAX_SP',

		(SELECT SUM(GM)
		 FROM AnaplanImport.ProductPlan
		 WHERE Country = 'RUSSIA/ ABKHAZIA'  
			  AND BusinessEntity = 'Russia' 
			  AND BaseUpdate = 'Update'
			  AND DATEPART(ISO_WEEK, CreationWeek) = DATEPART(ISO_WEEK, date)
			  AND DATEPART(YEAR, CreationWeek) = DATEPART(YEAR, date)) * [Proc] AS 'GM_SP'

FROM [AnaplanImport].[DailySales]

WHERE date >= '2021-01-25' AND date <= '2021-01-31'

	
