USE TUI;

SELECT users.name AS 'Author',
	   DATEPART(HOUR, revision.revdate) AS 'Hour',
	   CONVERT(date, revision.revdate) AS 'Date',
	   
	   SUM(CASE 
	   WHEN SUBSTRING(error, CHARINDEX(':', error) + 1, CHARINDEX(' ', error, CHARINDEX(':', error) + 2) - CHARINDEX(':', error)) IS NULL THEN 0
	   WHEN SUBSTRING(error,1,5) = 'Debug' THEN 0
	   ELSE SUBSTRING(error, CHARINDEX(':', error) + 1, CHARINDEX(' ', error, CHARINDEX(':', error) + 2) - CHARINDEX(':', error))
	   END) AS 'Calculated'

FROM revision

LEFT JOIN users
	ON revision.author = users.code

WHERE revdate >= '2021-04-01 00:00:00.000'

GROUP BY revision.revdate, users.name

ORDER BY Calculated DESC