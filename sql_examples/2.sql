USE TUI;

SELECT 
claim.inc AS 'Reservation',
partner.plname AS 'Owner',
tour.lname AS 'Tour',
claim.cdatetime AS 'Vvod_reservation',
claim.rdate AS 'Podacha_reservation',
claim.datebeg AS 'Check_in',
claim.dateend AS 'Check_out',
claim.confirmed AS 'Confirmed?',
claim.canceldate AS 'Date_of_cancelation',
claim.reason 'Cancel_reason',
claim.confirmeddate AS 'Date_of_confirmation',
status.lname AS 'Status',

CASE 
	WHEN in_partner.lname = 'ТО Дельфин (Москва)' THEN SUBSTRING(res.order_info,	
														 	    (CHARINDEX(',', res.order_info, CHARINDEX(',', res.order_info)+1))+1,  	
															    (CHARINDEX(',', res.order_info, CHARINDEX(',', res.order_info, CHARINDEX(',', res.order_info)+1)+1)) - (CHARINDEX(',', res.order_info, CHARINDEX(',', res.order_info)+1))-1)
	ELSE hotel.lname
END AS 'Hotel',

star.lname AS '*',


CASE 
	WHEN in_partner.lname = 'ТО Дельфин (Москва)' THEN SUBSTRING(order_info, 
																(CHARINDEX(',', order_info) + 1), 
																(CHARINDEX(',', order_info, CHARINDEX(',', order_info)+1) - CHARINDEX(',', order_info))-1)
	ELSE region.lname
END AS 'Hotel_region',

room.lname AS 'Room',

CASE 
	WHEN in_partner.lname = 'ТО Дельфин (Москва)' THEN SUBSTRING(order_info,
															    (CHARINDEX(',', order_info, CHARINDEX(',', order_info, CHARINDEX(',', order_info)+1)+1)+1),
															    (CHARINDEX(',', order_info, CHARINDEX(',', order_info, CHARINDEX(',', order_info, CHARINDEX(',', order_info)+1)+1)+1)+1) - (CHARINDEX(',', order_info, CHARINDEX(',', order_info, CHARINDEX(',', order_info)+1)+1)+2))
	ELSE meal.lname
END AS 'Meal',

res.net AS 'Hotel_net',
res.net / claim.nights AS 'Room_rate',
in_partner.lname AS 'Hotel_provider',
hotel.longitude AS 'Hotel_longiture',
hotel.latitude AS 'Hotel_latitude',
pax.adult AS 'Adl',
pax.child AS 'Chd',
pax.infant AS 'Inf',
pax.adult + pax.child AS 'Pax',
claim.commission AS 'Commission',
claim.nights AS 'Night',
spo.fullnumber AS 'SPO',
(SELECT DISTINCT SUBSTRING(res.pricedetail, 2, CHARINDEX(' ', res.pricedetail, 1) - 1) FROM [order] res WHERE LOWER(res.pricedetail) LIKE ('%rev%') AND res.claim = claim.inc ) AS 'Revision'

FROM claim

LEFT JOIN PartnerTownRegion as partner
	ON claim.owner = partner.pinc
LEFT JOIN tour
	ON claim.tour = tour.inc
LEFT JOIN status
	ON claim.status = status.inc
LEFT JOIN v_ClaimPax pax
	ON claim.inc = pax.inc 
LEFT JOIN spog spo
	ON claim.spog = spo.inc
LEFT JOIN [order] res
	ON claim.inc = res.claim
LEFT JOIN hotel
	ON res.hotel = hotel.inc
LEFT JOIN room
	ON res.room = room.inc
LEFT JOIN meal
	ON res.meal = meal.inc
LEFT JOIN star
	ON hotel.star = star.inc
LEFT JOIN town
	ON hotel.town = town.inc
LEFT JOIN region
	ON town.region = region.inc
LEFT JOIN state
	ON tour.state = state.inc
LEFT JOIN partner in_partner
	ON res.partner = in_partner.inc

WHERE state.lname IN ('Russia', 'Abkhazia')
	  AND hotel.inc <> -2147483647
	  AND partner.plname = 'TUI RU'
	  AND claim.rdate >= CAST(GETDATE() AS DATE)