SELECT DISTINCT claim.inc AS 'Reservation',
				claim.rdate AS 'Creation',
				CAST(claim.rdate as date) AS 'Creation_notime',
				claim.datebeg AS 'Check_in',
				claim.nights AS 'Nights',
				tour.name AS 'Tour',
				region.lname AS 'Region',
				pax.Adult + pax.Child AS 'Pax',

		
				-- Time To Confirm Calculation --
				CASE
					WHEN claim.confirmeddate IS NULL THEN DATEDIFF(HOUR, claim.cdatetime, CAST(GETDATE() AS DATETIME))
					ELSE DATEDIFF(HOUR, claim.cdatetime, claim.confirmeddate) 
				END AS 'Time_for_confirm',

				
				-- Real Reservation Status --
				CASE	
					WHEN claim.status = 3 THEN 'Canceled'
					WHEN claim.confirmed = 1 THEN 'Confirmed'
					WHEN claim.confirmationstatus = 0 THEN 'Not Confirmed'
					WHEN claim.confirmationstatus = -1 OR claim.confirmationstatus = 1 THEN 'No Answer'
				END AS 'Real_status',

				
				-- Product Type --
				CASE
					WHEN tour.lname LIKE LOWER('%gds%') THEN 'GDS'
					WHEN tour.lname LIKE LOWER('%БЛОК%') THEN 'BLOCK'
					WHEN tour.lname LIKE LOWER('%BLOCK%') THEN 'BLOCK'
					WHEN tour.lname LIKE LOWER('%flydubai%') THEN 'BLOCK'
					WHEN tour.lname LIKE LOWER('%hotel%') THEN 'HOTEL ONLY'
					WHEN tour.lname LIKE LOWER('%dwc/rkt%') THEN 'BLOCK'
					WHEN tour.lname LIKE LOWER('%sl%') THEN 'CUSTOM'
				END AS 'Product'

FROM claim

LEFT JOIN [order] res
	ON claim.inc = res.claim
LEFT JOIN hotel
	ON res.hotel = hotel.inc
LEFT JOIN town
	ON hotel.town = town.inc
LEFT JOIN region
	ON town.region = region.inc

LEFT JOIN tour
	ON claim.tour = tour.inc

LEFT JOIN v_ClaimPax pax
	ON claim.inc = pax.inc 
	   	  
WHERE claim.rdate >= CAST(GETDATE() - 14 AS DATE)
	  AND claim.owner = 100961
	  AND tour.state = 20613
	  AND res.hotel > 0