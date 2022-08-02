use [Tesca OLTP]
select * from SalesTransaction
select * from POSChannel
select * from PurchaseTransaction


 ---- product Oltp source---
 use [Tesca OLTP]
 select p.ProductID,p.Product,p.ProductNumber,p.UnitPrice,d.Department,getdate() as CreateDdate from Product p
 inner join Department d on p.DepartmentID=d.DepartmentID

 select Count(*) as SourceCount from Product p
inner join Department d on 
p.DepartmentID = d.DepartmentID

use [Tesca Staging]

create schema TescaOltp
create schema HR

 ---product staging ----
 use [Tesca Staging]
 Truncate table TescaOltp.product

 create table TescaOltp.product
(
 productid int,
 productname nvarchar(50),
 productnumber nvarchar(50),
 unitprice float,
 department nvarchar(50),
 CreatedDate datetime,
 constraint tescaoltp_product_pk primary key(productid)
)

use [Tesca Staging]
select productid,productname,productnumber,unitprice,department from tescaOLTP.product 


----product edw ---
use [Tesca EDW]
create schema TescaEdw
 
 select Count(*) as PreCount from TescaEdw.Dimproduct

 select Count(*) as PostCount from TescaEdw.Dimproduct

 create table TescaEdw.Dimproduct
(
 product_sk int identity(1,1),
 productid int,
 productname nvarchar(50),
 productnumber nvarchar(50),
 unitprice float,
 department nvarchar(50),
 EffectiveStartDate Datetime,
 EffectiveEndDate Datetime, 
 constraint tescaEdw_Dimproduct_sk primary key(product_sk)
)

--store Oltp source---
use [Tesca OLTP]

select s.StoreID, s.StoreName,s.StreetAddress,c.CityName,st.[State],getdate()as CreatedDate from Store s
inner join City c on s.CityID = c.CityID
inner join State st on c.StateID = st.StateID


select Count(*) as SourceCount from Store s
inner join City c on s.CityID = c.CityID
inner join State st on c.StateID = st.StateID

use [Tesca Staging]
Truncate table TescaOltp.store

create table TescaOltp.store
(
  storeid int,
  storename nvarchar(50),
  streetaddress nvarchar(50),
  city nvarchar(50),
  state nvarchar(50),
  createddate  datetime,
  constraint TescaOltp_storeid_pk primary key(storeid)
  )

 select storeid,storename,streetaddress,city,state from TescaOltp.store 

 use [Tesca EDW]

 select Count(*) as PreCount from TescaEdw.Dimstore

 select Count(*) as PostCount from TescaEdw.Dimstore

 create table TescaEdw.Dimstore
(
  store_sk int identity (1,1),
  storeid int,
  storename nvarchar(50),
  streetaddress nvarchar(50),
  city nvarchar(50),
  state nvarchar(50),
  EffectiveDate Datetime,
  constraint TescaEdw_DimStore_sk primary key(store_sk)
  )

 select store_sk,storeid,storename,streetaddress,city,state
 from Tescaedw.Dimstore 


 ---promotion---
 use [Tesca OLTP]

 select p.PromotionID,p.StartDate,p.EndDate,p.DiscountPercent,pt.Promotion,getdate()as CreatedDate from promotion p
 inner join PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID
 inner join PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID

 use [Tesca Staging]
 Truncate Table TescaOltp.promotion

 Create Table TescaOltp.promotion
 (
   promotionid int,
   StartDate Date,
   EndDate Date,
   DiscountPercent float,
   promotion nvarchar(50),
   CreatedDate Datetime,
   constraint TescaOltp_promotion_pk primary key(promotionid)
)

select promotionid,StartDate,EndDate,DiscountPercent,promotion from TescaOltp.promotion  

use [Tesca EDW]

select Count(*) as PreCount from TescaEdw.Dimpromotion

 select Count(*) as PostCount from TescaEdw.Dimpromotion

 Create Table TescaEdw.Dimpromotion
 (
   Promotion_sk int identity(1,1),
   promotionid int,
   StartDate Date,
   EndDate Date,
   DiscountPercent float,
   promotion nvarchar(50),
   EffectiveDate Datetime,
   constraint TescaEdw_Dimpromotion_sk primary key(promotion_sk)
)

select dm.Promotion_sk,dm.promotionid,dm.promotion,dm.StartDate,dm.EndDate,dm.DiscountPercent,dm.EffectiveDate
from TescaEdw.Dimpromotion dm

---customer---
use [Tesca OLTP]

select c.CustomerID,concat(upper(c.lastname),' ',c.firstname)as CustomerName,c.CustomerAddress,ct.CityName,st.State,getdate()as CreatedDate  from Customer c
inner join City ct on c.CityID=ct.CityID
inner join State st on ct.StateID=st.StateID

select Count(*) as SourceCount  from Customer c
inner join City ct on c.CityID=ct.CityID
inner join State st on ct.StateID=st.StateID

use [Tesca Staging]
Truncate table TescaOltp.Customer

Create table TescaOltp.Customer
(
 customerid int,
 CustomerName nvarchar(255),
 customeraddress nvarchar(50),
 CityName nvarchar(50),
 State nvarchar(50),
 CreatedDate Datetime,
 constraint Tesca_Customer_pk primary key(customerid)
 )
 select customerid,CustomerName,customeraddress,CityName,State from TescaOltp.Customer 

 use [Tesca EDW]

 select Count(*) as PreCount from TescaEdw.DimCustomer

 select Count(*) as PostCount from TescaEdw.DimCustomer
 

 Create table TescaEDW.DimCustomer
(
 Customer_sk int identity (1,1),
 customerid int,
 CustomerName nvarchar(255),
 customeraddress nvarchar(50),
 CityName nvarchar(50),
 State nvarchar(50),
 EffectiveDate Datetime,
 constraint TescaEdw_DimCustomer_sk primary key(customer_sk)
 )

 select  dc.Customer_sk,dc.customerid,dc.CustomerName,dc.customeraddress,dc.CityName,dc.State,dc.EffectiveDate
 from TescaEDW.DimCustomer dc

 ---Employee--
 use [Tesca OLTP]

select e.EmployeeID,e.EmployeeNo,concat(upper(e.lastname),' ',e.FirstName)as EmployeeName,e.DoB as DateOfBirth,m.MaritalStatus,getDate()as CreatedDate from Employee E
inner join MaritalStatus m on e.MaritalStatus =m.MaritalStatusID

select Count(*) as SourceCount from Employee E
inner join MaritalStatus m on e.MaritalStatus =m.MaritalStatusID

use [Tesca Staging]
Truncate Table TescaOltp.Employee

Create Table TescaOltp.Employee
(
 EmployeeId int,
 EmployeeNo nvarchar(50),
 EmployeeName nvarchar(255),
 DateofBirth Date,
 MaritalStatus nvarchar(50),
 createdDate Datetime,
 constraint TescaOltp_employee_pk primary key(employeeid)
 )

 select  EmployeeId,EmployeeNo,EmployeeName,DateofBirth,MaritalStatus from TescaOltp.Employee 

 use [Tesca EDW]

 select Count(*) as PreCount from TescaEdw.DimEmployee

 select Count(*) as PostCount from TescaEdw.DimEmployee

 Create Table TescaEdw.DimEmployee
(
 Employee_sk int identity(1,1),
 EmployeeId int,
 EmployeeNo nvarchar(50),
 EmployeeName nvarchar(255),
 DateofBirth Date,
 MaritalStatus nvarchar(50),
 EffectiveDate Datetime,
 EffectiveEndDate Datetime,
 constraint TescaEdw_Dimemployee_sk primary key(employee_sk)
 )

 ---POSChannel---

 use [Tesca OLTP]

 select ChannelID,ChannelNo,DeviceModel,InstallationDate,SerialNo,getdate()as createdDate from POSChannel 

 select Count(*) as SourceCount from POSChannel

 use [Tesca Staging]
 Truncate table TescaOltp.POSChannel
 Drop table TescaOltp.POSChannel
 Create table TescaOltp.POSChannel
 (
  ChannelId int,
  ChannelNo nvarchar(50),
  DeviceModel nvarchar(50),
  SerialNo nvarchar (50),
  InstallationDate Date,
  CreatedDate Datetime,
  Constraint TescaOltp_POSChannel_pk primary key(ChannelId)
  )

 Select ChannelId,ChannelNo,DeviceModel,InstallationDate,SerialNo from TescaOltp.POSChannel 

use [Tesca EDW]
select Count(*) as PreCount from TescaEdw.DimPOSChannel

 select Count(*) as PostCount from TescaEdw.DimPOSChannel
Drop table TescaEdw.DimPOSChannel
Create Table tescaEDW.DimPosChannel
(
 Channel_SK int identity(1,1), 
 ChannelID int,
 ChannelNo nvarchar(50),
 DeviceModel nvarchar(50),
 InstallationDate Date,
 serialNo nvarchar(50),
 EffectiveStartDate datetime,
 EffectiveEndDate datetime,
 Constraint tescaEDW_DimPosChannel_Sk primary key (Channel_Sk)
)


  use [Tesca OLTP]

  ---Vendor--
  select  v.vendorid, v.vendorno,concat(upper(v.lastname),' ',isnull(v.firstname,'*****')) vendorname,
  v.RegistrationNo,v.VendorAddress,c.CityName,s.State,getdate() as CreatedDate  from vendor v
  inner join City c on v.CityID = c.CityID
  inner join State s on c.StateID = s.StateID


   select Count(*) as SourceCount  from vendor v
  inner join City c on v.CityID = c.CityID
  inner join State s on c.StateID = s.StateID

  use [Tesca Staging]
  Truncate Table TescaOltp.Vendor
 
  Create Table TescaOltp.Vendor
  (
   VendorId int,
   vendorNo nvarchar(50),
   VendorName nvarchar(255),
   RegistrationNo nvarchar(50),
   VendorAddress nvarchar(50),
   City nvarchar(50),
   State nvarchar(50),
   CreatedDate Datetime,
   constraint TescaOltp_Vendor_pk primary key (VendorId)
  )

  select VendorId,vendorNo,VendorName,RegistrationNo,VendorAddress,City,State
  from TescaOltp.Vendor 
  
  use [Tesca EDW]
  select Count(*) as PreCount from TescaEdw.DimVendor

 select Count(*) as PostCount from TescaEdw.DimVendor

  Create Table TescaEdw.DimVendor
  (
   Vendor_sk int identity(1,1),
   VendorId int,
   vendorNo nvarchar(50),
   VendorName nvarchar(255),
   RegistrationNo nvarchar(50),
   VendorAddress nvarchar(50),
   City nvarchar(50),
   State nvarchar(50),
   EffectiveDate Datetime,
   EffectiveEndDate Datetime,
   constraint TescaEdw_DimVendor_sk primary key (Vendor_sk)
  )


  --- Dim Hour ---
use [Tesca EDW]


Truncate table TescaEDW.DimHour
drop table   TescaEDW.DimHour


Create table TescaEDW.DimHour
(
 hour_sk int,           --
 hour24 int,           --- --0 to 23
 hour12 int,              ----0-11,12=12[noon], 13=1, 14=2 ---23=11
 hourAP nvarchar(10),        --AM,NOON,PM
 Periodofday nvarchar(50),      
 BusinessHour nvarchar(50),   ---open[8,17] closed
 EffectivestartDate Datetime
 constraint TescaEDW_DimHour_sk primary key(hour_sk)
) 
select * from TescaEdw.DimHour


use [Tesca OLTP]
drop procedure pro_name
Create procedure pro_name(@transid int,@year int)
AS
BEGIN
select * from [Tesca OLTP].dbo.PurchaseTransaction where TransactionID>@transid and YEAR(OrderDate)=@year
END
exec pro_name 100, 2022

USE [Tesca EDW]

CREATE PROCEDURE TescaEdw.spDimHour 

AS
BEGIN
SET NOCOUNT ON;
declare @hour_sk int=0
IF OBJECT_ID('tescaedw.dimhour') is not null
	BEGIN
		IF (select count(*) from TescaEdw.DimHour)>0
			TRUNCATE table TescaEdw.DimHour;

 while @hour_sk<=23
 BEGIN

 Insert into TescaEdw.DimHour(hour_sk,hour12,hour24,hourAP,Periodofday,BusinessHour,EffectivestartDate) 
 Select @hour_sk as hour_sk, @hour_sk as hour24,
		case
		     when @hour_sk>=0 and @hour_sk<=12 then @hour_sk
			 when @hour_sk>=13 and @hour_sk<=23 then @hour_sk -12
		End hour12,
		case
		     when @hour_sk>=0 and @hour_sk<=11 then concat(@hour_sk, 'AM')
			 when @hour_sk=12  then concat(@hour_sk, 'Noon')
			 when @hour_sk>=13 and @hour_sk<=23 then concat(@hour_sk-12, 'pm')
		End hourAP,
		case
		     when @hour_sk>=0 and @hour_sk<=11 then 'Morning'
			 when @hour_sk=12 then 'Noon'
			 when @hour_sk>=13 and @hour_sk<=15 then 'Afternoon'
			 when @hour_sk>=16 and @hour_sk<=18 then 'Evening'
			 when @hour_sk>=19 and @hour_sk<=23 then 'Night'
			 when @hour_sk = 0 then 'MidNight'
		End periodofday,
		case
		     when @hour_sk>=8 and @hour_sk<=17 then 'open'
			 else 'closed'
		End BusinessHour,
		getdate() as Effectivestartdate
select @hour_sk=@hour_sk +1
END
	END
END



select * from TescaEdw.DimHour
 select count(*) from TescaEdw.DimHour
  select 'fred' from TescaEdw.DimHour
 
 
 


 --------Dim Date-----------
 /*

 Generate from 2010 to 2030

 Start Year=2010
   Start Month= 1
         day 1  to EodMonth
	end month 12
End year

while Year
   While Month 
       While Day 
	    print()
	   End day
  End Month 
End Year



Domingo — Sunday

Segunda-feira — Monday

Terça-feira — Tuesday

Quarta-feira — Wednesday

Quinta-feira — Thursday

Sexta-feira — Friday

Sábado — Saturday

Janeiro, Fevereiro, Marco, Abril, MAio, Junho, Julho, Agosto, Setembro, Outubro, Novembro, Dezembro

Muharram 
Safar
Rabi Al-Awwal
Rabi Al-Thani
Jamada Al-Awwal
Jamada Al-Thani
Rajab
Shaban
Ramadan
Shawwal
Dhul Qadah
Dhul Hijjah (month of Hajj)


yaum al-ahad - Sunday; yaum al-ithnayn - Monday; yaum ath-thalatha - Tuesday; yaum al-arbia'a - Wednesday; yaum al- khamis - Thursday; yaum al-jumu`a - Friday.


 */

 drop table TescaEDW.dimdate
truncate table tescaEDW.dimDate

 select *  from tescaEDW.dimDate order by 1 desc

 create table   tescaEDW.dimDate
 (
  datekey int,
  CalendarDate date,
  CalendarYear int,
  CalendarQuarter nvarchar(2),
  CalendarMonth int,
  CalendarEnglishMonth nvarchar(50), --- select DATENAME(Month, GETDATE())
  CalendarIboMonth nvarchar(50),
  CalendarPortugeseMonth nvarchar(50),
  CalendarArabicMonth nvarchar(50),
  CalendarFrenchMonth nvarchar(50),
  calendarDay int,
  CalendarEnglishDay nvarchar(50), ---select DATENAME(DW, GETDATE())
  CalendarIboDay nvarchar(50),  --- Eke, Orio, afor, nkwo, abali ise, abali isii, abali asaa
  CalendarPortugeseDay nvarchar(50),
  CalendarArabicDay nvarchar(50),
  CalendarFrenchDay nvarchar(50),
  CalendarWeek int,  ---select DATENAME(WEEK, GETDATE())
  CalendarDayofYear int,     --- select DATEpart(DAYOFYEAR, GETDATE())
 EffectiveStartDate datetime, 
 constraint  tescaEDW_dimDate_sk primary key(datekey)
 )

 select DATENAME(DW, GETDATE())
 select DATENAME(Month, GETDATE())
 select DATENAME(WEEK, GETDATE())
 select DATENAME(QUARTER, GETDATE())
 select DATEpart(WEEK, GETDATE())
 select DATEpart(DAYOFYEAR, GETDATE())

 /*
 select startdate from
 (
	select  Year(Min(transdate)) as startdate from   [Tesca OLTP].dbo.SalesTransaction
		union 
	select  Year(Min(transdate)) as startdate from   [Tesca OLTP].dbo.PurchaseTransaction
 ) a
 */

exec tescaEDW.DimDateGenerator  2070
 drop 	procedure tescaEDW.DimDateGenerator
 create procedure tescaEDW.DimDateGenerator( @EndYear int)
 AS
 BEGIN
 declare  @startYear int=  (
 

 select startdate from
 (
	select  Year(Min(transdate)) as startdate from   [Tesca OLTP].dbo.SalesTransaction
		union 
	select  Year(Min(transdate)) as startdate from   [Tesca OLTP].dbo.PurchaseTransaction
 ) a
 )
 
 declare  @startMonth int=1
 declare  @endMonth int=12
 declare @startday int =1
 declare @Endday int 
 declare @datekey int
 declare @Calendardate date
 set nocount on
 IF (select Count(*) from TescaEDW.dimDate)>0 
    TRUNCATE TABLE TescaEDW.dimDate

 begin 
  while @startYear<=@endYear    ---2010
	begin
		select @startMonth=1
		while @startMonth<=@endMonth
			BEGIN 
				 select  @startday=1
				 select @Calendardate=DATEFROMPARTS(@StartYear,@StartMonth,@Startday)
				 select @Endday=Day(EOMONTH(@Calendardate))
				 While @startday<=@Endday
				  BEGIN 
						select @Calendardate=DATEFROMPARTS(@StartYear,@StartMonth,@Startday)
						select @datekey=convert(int, CONCAT(@StartYear,  RIGHT(concat('0',@startMonth),2), RIGHT(concat('0',@startDay),2)))
						
						insert into TescaEDW.dimDate(  datekey,CalendarDate, CalendarYear,CalendarQuarter,CalendarMonth,CalendarEnglishMonth,
						   CalendarIboMonth,CalendarPortugeseMonth,CalendarArabicMonth,CalendarFrenchMonth,calendarDay,CalendarEnglishDay,
						   CalendarIboDay, CalendarPortugeseDay,CalendarArabicDay,CalendarFrenchDay,CalendarWeek,
						   CalendarDayofYear,EffectiveStartDate)						
						select @datekey,@Calendardate,@startYear,concat('Q',DATEPART(QUARTER,@Calendardate)), @startMonth,DATENAME(Month, @calendarDate),
						case month(@Calendardate)
						When 1 then 'onwa-mbu'
						When 2 then 'onwa-abuo'
						When 3 then 'onwa-ato'
						When 4 then 'onwa-ano'
						When 5 then 'onwa-ise'
						When 6 then 'onwa-isii'
						When 7 then 'onwa-asaa'
						When 8 then 'onwa-asato' 
						When 9 then 'onwa-itolu'
						When 10 then 'onwa-iri'
						When 11 then 'onwa-iri an ofu'
						When 12 then 'onwa-iri an abuo'
						End, 
						--Janeiro, Fevereiro, Marco, Abril, MAio, Junho, Julho, Agosto, Setembro, Outubro, Novembro, Dezembro
						case month(@Calendardate)
							When 1 then 'Janeiro'
							When 2 then 'Fevereiro'
							When 3 then 'Marco'
							When 4 then 'Abril'
							When 5 then 'MAio'
							When 6 then 'Junho'
							When 7 then 'Julho'
							When 8 then 'Agosto' 
							When 9 then 'Setembro'
							When 10 then 'Outubro'
							When 11 then 'Novembro'
							When 12 then 'Dezembro'
						End,

						case month(@Calendardate)
							When 1 then 'Muharram'
							When 2 then 'Safar'
							When 3 then 'Rabi Al-Awwal'
							When 4 then 'Rabi Al-Thani'
							When 5 then 'Jamada Al-Awwal'
							When 6 then 'Jamada Al-Thani'
							When 7 then 'Rajab'
							When 8 then 'Shaban' 
							When 9 then 'Ramadan'
							When 10 then 'Shawwal'
							When 11 then 'Dhul Qadah'
							When 12 then 'Dhul Hijjah'
						End,
						case month(@Calendardate)
							When 1 then 'Janvier'
							When 2 then 'Fevrier'
							When 3 then 'Mars'
							When 4 then 'Avril'
							When 5 then 'Mai'
							When 6 then 'Juin'
							When 7 then 'Juillet'
							When 8 then 'Aout' 
							When 9 then 'Septembre'
							When 10 then 'Octobre'
							When 11 then 'Novrembre'
							When 12 then 'Decembre'
						End,

						@startday, DATENAME(DW,@Calendardate), 
						case datepart(dw,@Calendardate)
							When 1 then 'Eke'
							When 2 then 'Orio'
							When 3 then 'afor'
							When 4 then 'nkwo'
							When 5 then 'abali ise'
							When 6 then 'abali isii'
							When 7 then 'abali asaa'							
						End,
						case datepart(dw,@Calendardate)
							When 1 then 'Domingo'
							When 2 then 'Segunda-feira'
							When 3 then 'Terça-feira'
							When 4 then 'Quarta-feira'
							When 5 then 'Quinta-feira'
							When 6 then 'Sexta-feira'
							When 7 then 'Sábado'							
						End,
						case datepart(dw,@Calendardate)
							When 1 then 'yaum al-ahad'
							When 2 then 'yaum al-ithnayn'
							When 3 then 'yaum ath-thalatha'
							When 4 then 'yaum al-arbia'
							When 5 then 'yaum al- khamis'
							When 6 then 'yaum al-jumua'
							When 7 then 'Yaoumu Sabt'
						 End,					
						
						
					case DATEPART(dw, @calendardate)
						when 1 then 'Dimanche'	
						when 2 then 'Lundi'
						when 3 then 'Mardi'
						when 4 then 'Mercredi'
						when 5 then 'Jeudi'
						when 6 then 'Vendredi'
						when 7 then 'Samedi'
						End,
					datepart(WEEK,@calendardate),					
					datepart(DAYOFYEAR,@Calendardate), getdate()
					
						Select @startday=@startday+1
				 END
				select @startMonth=@startMonth+1
			END  		
	  select @startYear=@startYear+1
	end

 end 
END

 select * from [TescaEdw].[dimDate]



 select Right('0'+'2',2)
 select datediff(DAY,'2015-01-01:00:00','2019-05-2019:00:00')
 
 declare @startTrans int=0,@endTrans int=1000000
 declare @startDate date='2015-01-01', @endDate date='2019-01-01' 
 declare @numberofdays int= datediff(DAY,@startdate,@endDate)
 declare @currentdate date
 while @starttrans< = 1000000
 begin 
	select @currentdate=convert(date, (dateadd(day, convert(int, rand()*@numberofdays+1),@startDate)))
	print(@currentdate)
  select @startTrans=@startTrans+1
 end 



 select cast(RAND()

 



 

 ----- Fact table creation -------


 ----- SalesFact table table------
 
 use [Tesca OLTP]
 

  IF( select count(*) as EDWCount from [Tesca EDW].TescaEDW.fact_salesTransaction )>0 
	BEGIN
		 select TransactionID, TransactionNo, Transdate, orderDate, deliveryDate, Channelid, CustomerID,  EmployeeID, ProductID, StoreID,
		PromotionID, Quantity, LineAmount, LineDiscountAmount,TaxAmount, getdate() as LoadDate
		 from salesTransaction   Where Convert(date,Transdate)=DATEADD(d,-1,convert(date,getdate()))   ----- yesterday
	END
 ELSE
	 BEGIN 
		select TransactionID, TransactionNo, Transdate, orderDate, deliveryDate, Channelid, CustomerID,  EmployeeID, ProductID, StoreID,
		PromotionID, Quantity, LineAmount,LineDiscountAmount,TaxAmount,getdate() as LoadDate
		from salesTransaction   Where Convert(date,Transdate)<=DATEADD(d,-1,convert(date,getdate()))    ----2013 till n-1
	END


	 IF( select count(*)as EDWCount from [Tesca EDW].TescaEDW.fact_salesTransaction )>0 
	BEGIN
		 select Count(*) as SourceCount
		 from salesTransaction   Where Convert(date,Transdate)=DATEADD(d,-1,convert(date,getdate()))   ----- yesterday
	END
 ELSE
	 BEGIN 
		select Count(*) as SourceCount
		from salesTransaction   Where Convert(date,Transdate)<=DATEADD(d,-1,convert(date,getdate()))    ----2013 till n-1
	END

 --- Staging Salestransaction ---

 use [Tesca Staging]

 Truncate table TescaOltp.SalesTransaction
 drop table TescaOltp.SalesTransaction
 create table TescaOltp.SalesTransaction
 (
 TransactionID int, 
 TransactionNo nvarchar(50), 
 Transdate datetime, 
 orderDate  datetime, 
 deliveryDate datetime,
 Channelid int,
 CustomerID int, 
 EmployeeID int, 
 ProductID int, 
 StoreID int,
 PromotionID int,
 Quantity float, 
 LineAmount float, 
 TaxAmount float,
 LineDiscountAmount float,
 loaddate datetime,
 constraint TescaOltp_salestransaction_pk primary key(transactionID) 
 )
 select * from TescaOltp.SalesTransaction

 ---- Fact Sales Transaction -----
 use  [Tesca Staging]
  select TransactionID, TransactionNo, convert(date,Transdate) as Transdate,   Datepart(hour,Transdate) as Transhour,
  convert(date,OrderDate) OrderDate, DATEPART(hour,Orderdate) as OrderHour, convert(date,deliveryDate) devliveryDate,
  datepart(hour, deliverydate) deliveryhour, Channelid, CustomerID,  EmployeeID, ProductID, StoreID,
		PromotionID, Quantity, LineAmount, LineDiscountAmount,TaxAmount 
		 from TescaOltp.SalesTransaction

 use [Tesca EDW]

 select  count(*) as PreCount from  TescaEDW.Fact_SalesTransaction

 select  count(*) as PostCount from  TescaEDW.Fact_SalesTransaction

 Drop table TescaEDW.Fact_SalesTransaction 

 create table TescaEDW.Fact_SalesTransaction
 (
 sales_sk bigint identity(1,1),  
 TransactionNo nvarchar(50), 
 Transdate_Sk int, 
 TransHour_sk int, 
 orderDate_sk int, 
 orderHour_sk int, 
 deliveryDate_sk int,
 deliveryHour_sk int,
 Channel_sk int,
 Customer_sk int, 
 Employee_sk int, 
 Product_sk int, 
 Store_sk int,
 Promotion_Sk int,
 Quantity float, 
 LineAmount float, 
 TaxAmount float,
 LineDiscountAmount float,
 loaddate datetime,
 constraint tescaEDW_factsalestransaction_sk primary key(Sales_sk),
 constraint edw_Sales_tranDate_fk foreign key (Transdate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_Sales_tranhour_fk foreign key (TransHour_Sk) references TescaEDW.DimHour(hour_sk),
 constraint edw_Sales_OrderDate_fk foreign key (OrderDate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_Sales_Orderhour_fk foreign key (OrderHour_Sk) references TescaEDW.DimHour(hour_sk),
 constraint edw_Sales_DeliveryDate_fk foreign key (DeliveryDate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_Sales_Deliveryhour_fk foreign key (DeliveryHour_Sk) references TescaEDW.DimHour(hour_sk),
 constraint edw_sales_channelid_fk foreign key (Channel_sk) references TescaEDW.DimPOSChannel(Channel_sk),
 constraint edw_sales_customer_fk foreign key (Customer_sk) references TescaEDW.DimCustomer(Customer_sk), 
 constraint edw_sales_employee_fk foreign key (employee_sk) references TescaEDW.DimEmployee(Employee_sk),
 constraint edw_sales_product_fk foreign key (product_sk) references TescaEDW.DimProduct(Product_sk),
 constraint edw_sales_store_fk foreign key (store_sk) references TescaEDW.DimStore(Store_sk),
 constraint edw_sales_promotion_fk foreign key (promotion_sk) references TescaEDW.DimPromotion(Promotion_sk)
 )
 select * from TescaEDW.Fact_SalesTransaction

 --- Purchase Transaction ------
 --- Load Purchase Staging ------
 
 use [Tesca OLTP]

 IF (Select count(*) from [Tesca EDW].TescaEdw.fact_PurchaseTransaction)>0
	BEGIN

 select TransactionID, TransactionNo, Transdate, orderDate, deliveryDate,ShipDate,VendorID, EmployeeID, ProductID, StoreID,
		 Quantity, LineAmount, TaxAmount,GetDate() as LoadDate
		 from PurchaseTransaction   Where Convert(date,Transdate)=DATEADD(d,-1,convert(date,getdate()))   ----- yesterday  N-1
	END
ELSE

	BEGIN

 select TransactionID, TransactionNo, Transdate, orderDate, deliveryDate,ShipDate,VendorID, EmployeeID, ProductID, StoreID,
 Quantity, LineAmount, TaxAmount,GetDate() as LoadDate
	 from PurchaseTransaction   Where Convert(date,Transdate)<=DATEADD(d,-1,convert(date,getdate()))   ----- from the begining till N-1 date

	 END

	 
IF (Select count(*) from [Tesca EDW].TescaEdw.fact_PurchaseTransaction)>0
	BEGIN

 select Count(*) as SourceCount
		 from PurchaseTransaction   Where Convert(date,Transdate)=DATEADD(d,-1,convert(date,getdate()))   ----- yesterday  N-1
	END
ELSE

	BEGIN

 select Count(*) as SourceCount
	 from PurchaseTransaction   Where Convert(date,Transdate)<=DATEADD(d,-1,convert(date,getdate()))   ----- from the begining till N-1 date

	 END
	 
	 
use [Tesca Staging]
Truncate  table TescaOltp.PurchaseTransaction	 
 create table TescaOltp.PurchaseTransaction
 (
 TransactionID int, 
 TransactionNo nvarchar(50), 
 Transdate datetime, 
 orderDate  datetime, 
 deliveryDate datetime,
 ShipDate datetime,
 VendorID int, 
 EmployeeID int, 
 ProductID int, 
 StoreID int, 
 Quantity float, 
 LineAmount float, 
 TaxAmount float, 
 loaddate datetime,
 constraint TescaOltp_PurchaseTransaction_pk primary key(transactionID) 
 )



 ------- fact Purchase Trans---------
 use [Tesca Staging]

 select TransactionID, TransactionNo, convert(date,Transdate) as Transdate,
  convert(date,OrderDate) OrderDate, convert(date,deliveryDate) deliveryDate, convert(date,ShipDate) ShipDate,
   VendorID, EmployeeID, ProductID, StoreID, Quantity, LineAmount, TaxAmount, DATEDIFF(day, orderDate, deliverydate) as differentialdays
   from [TescaOltp].[PurchaseTransaction]


   Select * From TescaOltp.PurchaseTransaction

   use [Tesca EDW]

   select count(*) as PreCount from  TescaEDW.fact_PurchaseTransaction

   select count(*) as PostCount from  TescaEDW.fact_PurchaseTransaction

 drop  table TescaEDW.fact_PurchaseTransaction
   
 create table TescaEDW.fact_PurchaseTransaction
 (
 Purchase_sk bigint identity(1,1), 
 TransactionNo nvarchar(50), 
 Transdate_sk int, 
 orderDate_Sk int, 
 deliveryDate_sk int,
 ShipDate_sk int,
 Vendor_sk int, 
 Employee_sk int, 
 Product_sk int, 
 Store_sk int, 
 Quantity float, 
 LineAmount float, 
 TaxAmount float, 
 differentialdays int,
 loaddate datetime,

 constraint tescaEDW_factpurchasetransaction_sk primary key(purchase_sk),
 constraint edw_purchase_tranDate_fk foreign key (Transdate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_purchase_orderdate_fk foreign key (orderdate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_purchase_deliverydate_fk foreign key (deliverydate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_purchase_shipdate_fk foreign key (shipdate_Sk) references TescaEDW.DimDate(datekey),
 constraint edw_purchase_vendor_fk foreign key (vendor_sk) references TescaEDW.DimVendor(vendor_sk),
 constraint edw_purchase_employee_fk foreign key (employee_sk) references TescaEDW.DimEmployee(Employee_sk),
 constraint edw_purchase_product_fk foreign key (product_sk) references TescaEDW.DimProduct(Product_sk),
 constraint edw_purchase_store_fk foreign key (store_sk) references TescaEDW.DimStore(Store_sk) 
 )

 select * from [TescaEdw].[fact_PurchaseTransaction]
 --------
 use [Tesca Staging]
 Truncate table Hr.OvertimeTransaction
 drop table Hr.OvertimeTransaction

 create table HR.OvertimeTransaction
 ( 
  OvertimeID int,
  EmployeeNo nvarchar(50),
  FirstName nvarchar(50) not null,
  LastName nvarchar(50),
  StartOvertime datetime,
  EndOvertime datetime,
  LoadDate datetime,
  constraint hr_overtimetrans_pk primary key(OvertimeID)
  )

  Select * from HR.OvertimeTransaction
  -------fact table -----
  ----Busines Process -> Grains -> Dimension- Fact
  use [Tesca Staging]
  
  /*select overtimeId, e.Employee_Sk, convert(date,StartOvertime) StartOvertimeDate,datepart(hour,StartOvertime) StartovertimeHour,
  convert(date,EndOvertime) EndOvertimeDate,datepart(hour,EndOvertime) EndOvertimeHour, 
  DATEDIFF(hour, startOvertime,EndOvertime) OvertimeHour
  from Hr.OvertimeTransaction o 
  inner join [Tesca EDW].TescaEDW.DimEmployee e  on o.EmployeeNo=e.EmployeeNo
  Where e.EffectiveEndDate is null
  */
  /** Remimnder to do the filteration on etl pipeline*/


  IF (Select Count(*) as EDWCount from [Tesca EDW].TescaEDW.fact_Overtime)<1
	Select 0 as EDWCount				---from the beginning
		else 
	Select 1 as EDWCount				---  N-1


  use  [Tesca EDW]
 

  select count(*) as PreCount from  TescaEDW.fact_Overtime

  select count(*) as PostCount from  TescaEDW.fact_Overtime

  Drop table TescaEDW.fact_Overtime

  create table TescaEDW.fact_Overtime
 ( 
  Overtime_SK bigint identity(1,1),
  Employee_sk  int,  
  StartOvertimeDate_sk int,
  StartOvertimeHour_sk int,
  EndOvertimeDate_sk int,
  EndOvertimeHour_sk int,
  OvertimeHour int, 
  LoadDate datetime,
  constraint tescaEDW_fact_overtime_sk primary key(Overtime_sk),
  constraint EDW_overtime_employee_fk foreign key (employee_sk) references TescaEDW.DimEmployee(Employee_sk),
  constraint edw_starovertimeDate_fk foreign key (StartOvertimeDate_sk) references TescaEDW.DimDate(datekey),
  constraint edw_startovertimehour_fk foreign key (StartOvertimeHour_sk) references TescaEDW.DimHour(hour_sk),
  constraint edw_endovertimeDate_fk foreign key (EndOvertimeDate_sk) references TescaEDW.DimDate(datekey),
  constraint edw_endovertimehour_fk foreign key (endOvertimeHour_sk) references TescaEDW.DimHour(hour_sk)
  )

  select * from TescaEDW.fact_Overtime

  
  ---- Tesca Control Framework -----

  use[Tesca Control]
  create schema control



  Drop table control.packageType
 Create table control.packageType
 (
 packageTypeID int identity(1,1),
 packageType nvarchar(255),
 constraint control_packagetype_pk primary key (packageTypeID)
 )

 insert into control.packageType(packageType)
 values('dimension'),
 ('fact')

 Drop table control.environment
 create table control.environment
 (EnvironmentId int identity(1,1),
 Environment nvarchar(255),
 constraint control_Environment_pk primary key (EnvironmentId)
 )

 
 insert into control.environment(Environment)
 values('staging'),
 ('EDW')

 select * from control.packageType
 select * from control.environment
  select * from control.FREQUENCY
 
 Drop table control.Frequency
 create table control.Frequency
 (
 FrequencyID INT IDENTITY(1,1),
 Frequency nvarchar(255),
 constraint control_frequency_pk primary key(frequencyID)
 )

 insert into control.Frequency
 Values('daily'),
 ('weekly'),
 ('Monthly'),
 ('yearly')

 Drop table control.package
  create table control.package
  (
	PackageID int identity(1,1),
	PackageName nvarchar(250),       -----stgcustomer.dstx,ewdcustomer.dstx
	PackageTypeID int,   ----can be Fact,Dimension 
	SequenceNo int,   ----100,200,300,400 (spacing to accomodate additional bus process
	EnvironmentId int,
	FrequencyId int,
	RunStartDate date,   ----02-28-2022
	RunEndDate date,  ---03-01-2022
	Active bit,     -----  0-false, 1-true
	LastRunDate datetime,
	constraint control_package_pk primary key(packageID),
	constraint control_packageType_package_fk foreign key(packageTypeID) references control.packageType(packageTypeID),
	constraint control_Environment_package_fk foreign key(EnvironmentID) references control.Environment(EnvironmentID),
	constraint control_Frequency_package_fk foreign key(FrequencyID) references control.Frequency(FrequencyID)
 )

 
  select * from control.package

 drop table control.Metrics
 create table control.Metrics
 (
	MetricID int identity(1,1),
	PackageID int,
	StgSourceCount bigint,  ----oltp ->source
	StgDestcount bigint, ---staging - destination
	precount bigint, ----EDW Metrics
	Currentcount bigint, ----EDW Metrics
	Type1count bigint, ----EDW Metrics
	Type2count bigint, ----EDW Metrics
	Postcount bigint, ----EDW Metrics
	RunDate  datetime, ---auudit information
constraint control_metrics_pk primary key(MetricID),
constraint control_package_metrics_fk foreign key(packageID)  references control.package(packageID)
)

Drop table control.Anomalies
create table control.Anomalies
(
	AnomaliesId int identity(1,1),
	PackageID int,
	TableName nvarchar(255),
	ColumnName nvarchar(255),
	TransID int,
	RunDate datetime,
	constraint control_anomalies_pk primary key(AnomaliesId),
	constraint control_package_Anomalies_fk foreign key(packageID)  references control.package(packageID)
	)



