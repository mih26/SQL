Create Database homeutiltyprovider
go
use homeutiltyprovider
go
exec spinsertworkareas 1,'electrical work'
go 
exec spinsertworkareas 2,'electronics work'
go
exec spinsertworkareas 3,'plumbing work'
go
exec spinsertworkareas 4,'general labour'
go
exec spinsertworkareas 5,'food server'
go
select * from workareas
go
--- table 2 ---
exec spinsertworkers 101,'md.rahim','01720151533',950.00
go 
exec spinsertworkers 102,'abdul kadir','01829415557',780.00
go
exec spinsertworkers 103,'sakib khan','01711695986',790.00
go
exec spinsertworkers 104,'md.abdullah','01987032087',550.00
go
exec spinsertworkers 105,'tuhin sarker','01642405277',550.00
go
exec spinsertworkers 106,'sifat hasan','01908355205',760.00
go
exec spinsertworkers 107,'md.akash','01871282593',690.00
go
select* from workers

---- table 03----
exec spinsertworkerareas 101,1
go 
exec spinsertworkerareas 101,2
go 
exec spinsertworkerareas 102,3
go 
exec spinsertworkerareas 103,4
go 
exec spinsertworkerareas 103,5
go 
exec spinsertworkerareas 104,4
go 
exec spinsertworkerareas 105,3
go 
exec spinsertworkerareas 106,2
go 
exec spinsertworkerareas 107,1
go 
exec spinsertworkerareas 105,5
go 
select* from workerareas

--- table 04--- 

exec spinsertworks 501,'md.jony','12, gulshan-1',1,
'swage pipe replacement ','2020-01-01','2020-8-04'
go 
exec spinsertworks 502,'md.jowel','15, bonani-3',2,
'garage electric wiring ','2020-01-06','2020-5-04'
go 
exec spinsertworks 503,'md.shajib','44,dhanmondi-1',3,
'house cleaning ','2020-02-05','2020-9-04'
go 
exec spinsertworks 504,'md.faruk','33,rajarbag-4',4,
'garden water line replace ','2020-03-01','2020-7-04'
go 
exec spinsertworks 505,'md.shahin','15, arambag-4',5,
'new electic line','2020-04-01','2020-06-04'
go 
exec spinsertworks 506,'md.jamir','15, arambag-5',5,
'electrical repair','2020-04-01',null
go 
select* from works
go
select* from workerdetails
-------- table 05 -
declare @h1 int , @h2 int
set @h1 =datediff (hour, '2020-01-01','2020-08-04')
set @h2 = datediff (hour, '2020-01-01','2020-08-04')*900
exec spinsertworkerpayments  501, 101,@h1 ,@h2
exec spinsertworkerpayments  502, 102,@h1 ,@h2
exec spinsertworkerpayments  503, 102,@h1 ,@h2
exec spinsertworkerpayments  504, 103,@h1 ,@h2
exec spinsertworkerpayments  505, 104,@h1 ,@h2
go 
select * from vdetails
go
select * from workerdetails
go
select * from worksdetails
go
select * from fnworkerlist(1)
go
/*
 ***********************************************************************
 * --queries added
 ***********************************************************************
 **/
--1 join inner 
-------------------------------------------------------------------------
select        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
go
--2 specific work
-----------------------------------------------
select        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
where woa.skill = 'plumbing'
-- 3 specific worker
--------------------------------------------------------------------
select        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
where wo.workername = 'md.mahidol'
go
--4 outer 
-----------------------------------------------------------------------------------------------------------
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
left outer join
                         workerpayments wp on wo.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and wa.workareaid = w.workareaid
--5 same with cte
------------------------------------
with cte as
(

select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, woa.areaid, wa.workareaid
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
)
select cte.workername, cte.phone, cte.payrate, cte.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from cte 
left outer join
                         workerpayments wp on cte.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and cte.workareaid = w.workareaid
--6 not matched for left join
-----------------------------------------------------------------------------------------------------------
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
left outer join
                         workerpayments wp on wo.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and wa.workareaid = w.workareaid
where w.customename is null and wp.workid is null
go
--7 same with subquery
-----------------------------------------------------------------------------------------------------------
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
left outer join
                         workerpayments wp on wo.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and wa.workareaid = w.workareaid
where wo.workerid not in (select workerid from workerpayments)
--8 aggregate
-----------------------------------------------------------------------------------------------------------
select        wo.workername, sum(wp.totalworkhour) 'totalhour', sum(wp.totalpayment) 'totalpayment'
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
group by wo.workername
--9 aggregate and having
------------------------------------------------------------------------------
select        wo.workername, sum(wp.totalworkhour) 'totalhour', sum(wp.totalpayment) 'totalpayment'
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
group by wo.workername
having wo.workername='sakib khan'
go
--10 windowing
---------------------------------------------------------------------------------------------
select        wo.workername, 
sum(wp.totalworkhour) over(order by wo.workerid) 'totalhour', 
sum(wp.totalpayment) over(order by wo.workerid) 'totalpayment',
row_number()  over(order by wo.workerid) 'rownum',
rank()  over(order by wo.workerid) 'rank',
dense_rank()  over(order by wo.workerid) 'denserank',
ntile(2)  over(order by wo.workerid) 'ntile (2)'
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
go
--11 -select case
--------------------------------------------------------------------
select customename, customeraddress, workdescription, startdate,
case
	when endtime is null then 'running'
	else cast(endtime as varchar)
end endtime
from works
