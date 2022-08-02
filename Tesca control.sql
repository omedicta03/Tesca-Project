
Truncate table control.Metrics

select  * from control.package
select  * from control.Metrics
select  * from control.Anomalies
select  * from control.packageType
select  * from control.environment
select  * from control.Frequency

use [Tesca Control]

  
  insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgProduct.dtsx', 1, 1000,1, 1,GETDATE(),1 )

   insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values ('stgStore.dtsx', 1, 2000,1, 1,GETDATE(),1 )

    insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgPromotion.dtsx', 1, 3000,1, 1,GETDATE(),1 )

   insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgCustomer.dtsx', 1, 4000,1, 1,GETDATE(),1 )

    insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgEmployee.dtsx', 1, 5000,1, 1,GETDATE(),1 )

   insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgPOSChannel.dtsx', 1, 6000,1, 1,GETDATE(),1 )

     insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgVendor.dtsx', 1, 7000,1, 1,GETDATE(),1 )

   insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgSalesTrans.dtsx', 2, 10000,1, 1,GETDATE(),1 )

  insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgPurchaseTrans.dtsx', 2, 11000,1, 1,GETDATE(),1 )

  insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('stgOvertimeTrans.dtsx', 2, 12000,1, 1,GETDATE(),1 )

insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values ('dimProduct.dtsx', 1, 20000,2, 1,GETDATE(),1 ),
  ('dimStore.dtsx', 1, 21000,2, 1,GETDATE(),1 ),
  ('dimPromotion.dtsx', 1, 22000,2, 1,GETDATE(),1 ),
  ('dimCustomer.dtsx', 1, 23000,2, 1,GETDATE(),1 ),
  ('dimEmployee.dtsx', 1, 24000,2, 1,GETDATE(),1 ),
  ('dimPOSChannel.dtsx', 1, 25000,2, 1,GETDATE(),1 ),
  ('dimVendor.dtsx', 1, 26000,2, 1,GETDATE(),1 )

  insert into control.package(packageName, PackageTypeID, SequenceNo, EnvironmentId, FrequencyID,RunStartDate,Active)
  values('fact_SalesTrans.dtsx', 2, 30000,2, 1,GETDATE(),1 ),
  ('fact_PurchaseTrans.dtsx', 2, 31000,2, 1,GETDATE(),1 ),
  ('fact_OvertimeTrans.dtsx', 2, 32000,2, 1,GETDATE(),1 )




declare @SourceCount bigint=?
declare @DesCount bigint=?
declare @PackageID int=?

insert into control.Metrics(PackageId, StgSourceCount, StgDestCount,Rundate)
select @PackageID,@SourceCount,@DesCount, Getdate()

Update control.Package set  LastRundate=GETDATe() Where packageID=@PackageID



/*
IF( select count(*) as EDWCount from [Tesca EDW].TescaEDW.fact_salesTransaction )>0 
BEGIN
 select TransactionID, TransactionNo, Transdate, orderDate, deliveryDate, Channelid, CustomerID,  EmployeeID, ProductID, StoreID,
		PromotionID, Quantity, LineAmount, LineDiscountAmount,TaxAmount 
		 from salesTransaction   Where Convert(date,Transdate)=DATEADD(d,-1,convert(date,getdate()))   
END
ELSE

BEGIN

 select TransactionID, TransactionNo, Transdate, orderDate, deliveryDate, Channelid, CustomerID,  EmployeeID, ProductID, StoreID,
		PromotionID, Quantity, LineAmount, LineDiscountAmount,TaxAmount 
		 from salesTransaction   Where Convert(date,Transdate)<=DATEADD(d,-1,convert(date,getdate()))   
END
*/

Select * from control.Frequency

select * from control.Package


select PackageID, PackageName ,SequenceNo from control.Package
Where EnvironmentId= 1 and Active=1 and RunStartDate<=convert(date,GETDATE())  
and (RunEndDate is null or RunEndDate>=convert(date,getdate()))  and FrequencyID=1
order by SequenceNo asc

IF datepart(WEEKDAY, GETDATE())=7
	BEGIN 
		select packageID,packageName, SequenceNo from (
		select PackageID, PackageName ,SequenceNo from control.Package
		Where EnvironmentId= 1 and Active=1 and RunStartDate<=convert(date,GETDATE())  
		and (RunEndDate is null or RunEndDate>=convert(date,getdate()))  and FrequencyID=1
		union
		select PackageID, PackageName ,SequenceNo from control.Package
		Where EnvironmentId= 1 and Active=1 and RunStartDate<=convert(date,GETDATE())  
		and (RunEndDate is null or RunEndDate>=convert(date,getdate())) and FrequencyID=2
		) weekdayrun  order by SequenceNo
 END
Order By SequenceNo  asc

---package control command metrics--

declare @PackageID int=?
Update control.Package set  LastRundate=GETDATe() Where packageID=@PackageID

---EDW control command metrics---
declare @PreCount bigint=?
declare @CurrentCount bigint=?
declare @Type1Count bigint=?
declare @Type2Count bigint=?
declare @PostCount bigint=?
declare @PackageID int=?

insert into control.Metrics(PackageId,PreCount,CurrentCount,Type1Count,Type2Count,PostCount,Rundate)
select @PackageId,@PreCount,@CurrentCount,@Type1Count,@Type2Count,@PostCount, Getdate()

Update control.Package set  LastRundate=GETDATe() Where packageID=@PackageID


---fact table metrics---

declare @PreCount bigint=?
declare @CurrentCount bigint=?
declare @PostCount bigint=?
declare @PackageID int=?

insert into control.Metrics(PackageId,PreCount,CurrentCount,PostCount,Rundate)
select @PackageId,@PreCount,@CurrentCount,@PostCount, Getdate()

Update control.Package set  LastRundate=GETDATe() Where packageID=@PackageID

--EDW package Control--

select PackageID, PackageName ,SequenceNo from control.Package
Where EnvironmentId= 2 and Active=1 and RunStartDate<=convert(date,GETDATE())  
and (RunEndDate is null or RunEndDate>=convert(date,getdate()))  and FrequencyID=1
order by SequenceNo asc


declare @PackageID int=?
Update control.Package set  LastRundate=GETDATe() Where PackageID=@PackageID


---Report for Staging--

select m.MetricID,p.PackageName,p.Active,e.Environment,m.StgSourceCount,m.StgDestcount,
case
When m.StgSourceCount=m.StgDestcount then 'Data Pass'
ELSE
'Data Failure'
END DataStatus,
f.Frequency,pt.packageType,p.RunStartDate,p.RunEndDate
from control.Metrics m
inner join control.package p on m.packageID=p.PackageID
inner join control.environment e on p.EnvironmentId=e.EnvironmentId
inner join control.Frequency f on p.FrequencyId=f.FrequencyID
inner join control.packageType pt on p.PackageTypeID=pt.packageTypeID
where e.EnvironmentId=1 and p.Active=1
order by p.PackageTypeID asc

--Report EDW---
select m.MetricID,p.PackageName,p.Active,e.Environment,m.precount,m.Currentcount,m.Type1count,m.type2count,m.postcount,
case
When m.precount+m.Currentcount=m.Postcount then 'Data Pass'
ELSE
'Data Failure'
END DataStatus,
f.Frequency,pt.packageType,p.RunStartDate,p.RunEndDate
from control.Metrics m
inner join control.package p on m.packageID=p.PackageID
inner join control.environment e on p.EnvironmentId=e.EnvironmentId
inner join control.Frequency f on p.FrequencyId=f.FrequencyID
inner join control.packageType pt on p.PackageTypeID=pt.packageTypeID
where e.EnvironmentId=2 and p.Active=1
order by p.PackageTypeID asc