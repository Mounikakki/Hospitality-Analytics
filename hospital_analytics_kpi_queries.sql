USE hospital_analytics;

SELECT COUNT(*) AS Total_Bookings
FROM fact_bookings;

SELECT COUNT(*) AS Total_Hotels
FROM dim_hotels;

SELECT COUNT(*) AS Total_Room_Classes
FROM dim_rooms;

SELECT COUNT(*) AS Total_Date_Records
FROM dim_date;


-- KPI 1 : TOTAL REVENUE
SELECT
SUM(revenue_realized) AS Total_Revenue
FROM fact_bookings;

-- KPI 2 : OCCUPANCY %
SELECT
ROUND(
SUM(successful_bookings)*100.0/
SUM(capacity),2
) AS Occupancy_Percentage
FROM fact_aggregated_bookings;

-- KPI 3 : CANCELLATION RATE
SELECT
ROUND(
COUNT(CASE WHEN booking_status='Cancelled' THEN 1 END)
*100.0/
COUNT(*),
2
) AS Cancellation_Rate
FROM fact_bookings;

-- KPI 4 : TOTAL BOOKINGS
SELECT
COUNT(booking_id) AS Total_Bookings
FROM fact_bookings;

-- KPI 5 : UTILIZED CAPACITY
SELECT
SUM(successful_bookings) AS Utilized_Capacity
FROM fact_aggregated_bookings;

-- KPI 6 : MONTHLY REVENUE TREND
SELECT
d.`mmm_yy`,
SUM(f.revenue_realized) AS Revenue
FROM fact_bookings f
JOIN dim_date d
ON f.check_in_date=d.date
GROUP BY d.`mmm_yy`
ORDER BY MIN(d.date);

-- KPI 7 : WEEKDAY VS WEEKEND
SELECT
d.day_type,
SUM(f.revenue_realized) AS Revenue,
COUNT(f.booking_id) AS Bookings
FROM fact_bookings f
JOIN dim_date d
ON f.check_in_date=d.date
GROUP BY d.day_type;

-- KPI 8 : REVENUE BY CITY & HOTEL
SELECT
h.city,
h.property_name,
SUM(f.revenue_realized) AS Revenue
FROM fact_bookings f
JOIN dim_hotels h
ON f.property_id=h.property_id
GROUP BY h.city,h.property_name
ORDER BY Revenue DESC;

-- KPI 9 : CLASS WISE REVENUE
SELECT
r.room_class,
SUM(f.revenue_realized) AS Revenue
FROM fact_bookings f
JOIN dim_rooms r
ON f.room_category=r.room_id
GROUP BY r.room_class
ORDER BY Revenue DESC;

-- KPI 10 : BOOKING STATUS ANALYSIS
SELECT
booking_status,
COUNT(*) AS Total_Bookings
FROM fact_bookings
GROUP BY booking_status;

-- KPI 11 : WEEKLY TREND
SELECT
d.`week_no`,
SUM(f.revenue_realized) AS Revenue,
COUNT(f.booking_id) AS Total_Bookings
FROM fact_bookings f
JOIN dim_date d
ON f.check_in_date=d.date
GROUP BY d.`week_no`
ORDER BY d.`week_no`;

