--SQL Advance Case Study
SELECT *FROM DIM_CUSTOMER
SELECT *FROM DIM_DATE
SELECT *FROM DIM_LOCATION
SELECT *FROM DIM_MANUFACTURER
SELECT *FROM DIM_MODEL
SELECT *FROM FACT_TRANSACTIONS


--Q1--BEGIN 
SELECT STATE 
FROM FACT_TRANSACTIONS AS T1
INNER JOIN DIM_LOCATION AS T2 ON T1.IDLocation = T2.IDLocation
INNER JOIN DIM_MODEL AS T3 ON T1.IDModel = T3.IDModel
WHERE Date BETWEEN '2005-01-04' AND GETDATE()

	





--Q1--END

--Q2--BEGIN
SELECT TOP 1
State FROM DIM_LOCATION
INNER JOIN FACT_TRANSACTIONS ON DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
INNER JOIN DIM_MANUFACTURER ON DIM_MANUFACTURER.IDManufacturer =DIM_MODEL.IDManufacturer
WHERE Manufacturer_Name = 'SAMSUNG'
GROUP BY State
ORDER BY SUM(Quantity) DESC









--Q2--END

--Q3--BEGIN      
SELECT MODEL_NAME, ZIPCODE, STATE, COUNT(IDCUSTOMER) AS NO_OF_TRANSACTIONS FROM DIM_LOCATION
INNER JOIN FACT_TRANSACTIONS ON DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
GROUP BY MODEL_NAME, ZIPCODE, STATE










--Q3--END

--Q4--BEGIN
SELECT TOP 1
IDMODEL,MODEL_NAME FROM DIM_MODEL
ORDER BY Unit_price






--Q4--END

--Q5--BEGIN
SELECT MODEL_NAME, AVG(UNIT_PRICE) AS AVG_PRICE FROM DIM_MODEL
INNER JOIN DIM_MANUFACTURER ON DIM_MANUFACTURER.IDManufacturer = DIM_MODEL.IDManufacturer
WHERE MANUFACTURER_NAME IN
(
SELECT TOP 5 MANUFACTURER_NAME FROM FACT_TRANSACTIONS
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
INNER JOIN DIM_MANUFACTURER ON DIM_MANUFACTURER.IDManufacturer = DIM_MODEL.IDManufacturer
GROUP BY Manufacturer_Name
ORDER BY SUM(Quantity)
)
GROUP BY Model_Name
ORDER BY AVG(Unit_price) DESC












--Q5--END

--Q6--BEGIN
SELECT CUSTOMER_NAME, AVG(TOTALPRICE) AVG_SPENT
FROM DIM_CUSTOMER
INNER JOIN FACT_TRANSACTIONS ON DIM_CUSTOMER.IDCustomer = FACT_TRANSACTIONS.IDCustomer
WHERE YEAR(DATE) = 2009
GROUP BY Customer_Name
HAVING AVG(TotalPrice) > 500












--Q6--END
	
--Q7--BEGIN  
SELECT TOP 5 IDMODEL, COUNT(QUANTITY)
FROM FACT_TRANSACTIONS
WHERE YEAR(DATE) = 2008
GROUP BY IDMODEL
ORDER BY COUNT(QUANTITY) DESC
SELECT TOP 5 IDMODEL, COUNT(QUANTITY)
FROM FACT_TRANSACTIONS
WHERE YEAR(DATE) = 2009
GROUP BY IDMODEL
SELECT TOP 5 IDMODEL, COUNT(QUANTITY)
FROM FACT_TRANSACTIONS
WHERE YEAR(DATE) = 2010
GROUP BY IDMODEL
ORDER BY COUNT(QUANTITY) DESC
	
	


	
















--Q7--END	
--Q8--BEGIN
select manufacturer_name from 
 (select top 1 * from
 (
 select top 2 mm.manufacturer_name, sum(totalprice) total_sales
 from FACT_TRANSACTIONS t inner join DIM_MODEL m
 on t.IDModel = m.IDModel inner join DIM_MANUFACTURER mm
 on m.IDManufacturer = mm.IDManufacturer
 where datepart(year,date) = 2009
 group by mm.Manufacturer_Name
 order by total_sales desc
 ) manuf_2009
 order by total_sales) manuf_from_2009
 union all
 
 select manufacturer_name from 
 (select top 1 * from
 (
 select top 2 mm.manufacturer_name, sum(totalprice) total_sales
 from FACT_TRANSACTIONS t inner join DIM_MODEL m
 on t.IDModel = m.IDModel inner join DIM_MANUFACTURER mm
 on m.IDManufacturer = mm.IDManufacturer
 where datepart(year,date) = 2010
 group by mm.Manufacturer_Name
 order by total_sales desc
 ) manuf_2010
 order by total_sales) manuf_from_2010














--Q8--END
--Q9--BEGIN
SELECT MANUFACTURER_NAME FROM DIM_MANUFACTURER T1
INNER JOIN DIM_MODEL T2 ON T1.IDManufacturer = T2.IDManufacturer
INNER JOIN FACT_TRANSACTIONS T3 ON T2.IDModel = T3.IDModel
WHERE YEAR(DATE) = 2010
EXCEPT
SELECT MANUFACTURER_NAME FROM DIM_MANUFACTURER T1
INNER JOIN DIM_MODEL T2 ON T1.IDManufacturer = T2.IDManufacturer
INNER JOIN FACT_TRANSACTIONS T3 ON T2.IDModel = T3.IDModel
WHERE YEAR(DATE) = 2009

















--Q9--END

--Q10--BEGINS
SELECT 
    T1.Customer_Name, T1.Year, T1.Avg_Price,T1.Avg_Qty,
    CASE
        WHEN T2.Year IS NOT NULL
        THEN FORMAT(CONVERT(DECIMAL(8,2),(T1.Avg_Price-T2.Avg_Price))/CONVERT(DECIMAL(8,2),T2.Avg_Price),'p') ELSE NULL 
        END AS 'YEARLY_%_CHANGE'
    FROM
        (SELECT t2.Customer_Name, YEAR(t1.DATE) AS YEAR, AVG(t1.TotalPrice) AS Avg_Price, AVG(t1.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS t1 
        left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
        where t1.IDCustomer in (select top 10 IDCustomer from FACT_TRANSACTIONS group by IDCustomer order by SUM(TotalPrice) desc)
        group by t2.Customer_Name, YEAR(t1.Date)
        )T1



    left join
        (SELECT t2.Customer_Name, YEAR(t1.DATE) AS YEAR, AVG(t1.TotalPrice) AS Avg_Price, AVG(t1.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS t1 
        left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
        where t1.IDCustomer in (select top 10 IDCustomer from FACT_TRANSACTIONS group by IDCustomer order by SUM(TotalPrice) desc)
        group by t2.Customer_Name, YEAR(t1.Date)
        )T2
        on T1.Customer_Name=T2.Customer_Name and T2.YEAR=T1.YEAR-1









--Q10--END

