if db_id('homeutiltyprovider') is null
create database homeutiltyprovider
go
use homeutiltyprovider
go

---------01------
create table workareas
(
	workareaid int not null primary key,
	skill nvarchar (40) not null
)
go
----------02-----
create table workers
(
	workerid int not null primary key,
	workername nvarchar (40) not null,
	phone nvarchar (20) not null,
	payrate money not null

)
go
------ table 03---- 
create table workerareas 
(
	workerid int not null references  workers (workerid),
	areaid int not null references workareas  (workareaid),
	primary key (workerid, areaid )
)
go
-------- table 04 ------
create table works
(
	workid int not null primary key,
	customename nvarchar (50) not null,
	customeraddress nvarchar (150) not null,
	workareaid int not null references workareas  (workareaid ),
	workdescription nvarchar (100) not null,
	startdate date not null,
	endtime datetime null
)
go
------ table 05---- 
create table workerpayments
(
	workid int not null references works (workid ),
	workerid int not null references workers (workerid ),
	totalworkhour float null,
	totalpayment money null,
	primary key (workid, workerid )
)
go

--- insert procedure-----------

create proc spinsertworkareas
@workareaid int,
@skill nvarchar(30)
as
begin try insert into 
workareas(workareaid,skill)
values(@workareaid, @skill)
end try
begin catch
     declare @msg nvarchar(1000)
	 select @msg = error_message()
	 ;
	 throw 50001, @msg, 1
end catch
go



---------- table workers 02--------
create proc spinsertworkers
@workerid int,
@workername nvarchar(30),
@phone nvarchar (20),
@payrate money
as
begin try insert into 
workers(workerid,workername,phone,payrate)
values(@workerid, @workername,@phone,@payrate)
end try
begin catch
     declare @msg nvarchar(1000)
	 select @msg = error_message()
	 ;
	 throw 50001, @msg, 1
end catch
go
create proc spupdateworkareas
			@workareaid int,
			@skill nvarchar(30)
as
begin try update workareas
			
		set	workareaid=@workareaid,
			skill=@skill
			where workareaid=@workareaid
end try
begin catch
  
	 ;
	 throw 50002, 'update fail', 1
end catch
go




---------- table workers 02--------
create proc spupdateworkers
				@workerid int,
				@workername nvarchar(30),
				@phone nvarchar (20),
				@payrate money
as
begin try update workers
			
		set	workerid=@workerid,
			workername=@workername,
			phone=@phone,
			payrate=@payrate
			where workerid=@workerid
end try
begin catch
  
	 ;
	 throw 50002, 'update fail', 1
end catch
go
create proc spupdateworks
				@workid int,
				@customename nvarchar(30),
				@customeraddress nvarchar(40),
				@workareaid int,
				@workdescription nvarchar(40),
				@startdate date,
				@endtime datetime
as
begin try update works
			
		set workid=@workid,
			customename=@customename,
			customeraddress=@customeraddress,
			workareaid=@workareaid,
			workdescription=@workdescription,
			startdate=@startdate,
			endtime=@endtime
			where workid=@workid
end try
begin catch
  
	 ;
	 throw 50002, 'update fail', 1
end catch
go

create proc spdeleteworkareas
			@workareaid int
as
begin try
      delete workareas
	  where workareaid = @workareaid
end try
begin catch
         ;
		 throw 50001, 'can not deleted', 1
end catch
go
--------- table workerareas 03------

create proc spinsertworkerareas
@workerid int,
@areaid int
as
begin try insert into 
workerareas(workerid,areaid)
values(@workerid ,@areaid)
end try
begin catch
     declare @msg nvarchar(1000)
	 select @msg = error_message()
	 ;
	 throw 50001, @msg, 1
end catch
go
create proc spupdateworkerareas
				@workerid int,
				@areaid int
as
begin try update workerareas
			
		set	workerid=@workerid,
			areaid=@areaid
			where areaid=@areaid
end try
begin catch
  
	 ;
	 throw 50002, 'update fail', 1
end catch
go

--------- table works 04------

create proc spinsertworks
@workid int,
@customename nvarchar(30),
@customeraddress nvarchar(40),
@workareaid int,
@workdescription nvarchar(40),
@startdate date,
@endtime datetime
as
begin try insert into 
works(workid,customename,customeraddress,workareaid,
workdescription,startdate,endtime)
values(@workid ,@customename,@customeraddress,@workareaid,
@workdescription,@startdate,@endtime)
end try
begin catch
     declare @msg nvarchar(1000)
	 select @msg = error_message()
	 ;
	 throw 50001, @msg, 1
end catch
go



---------- table workerpayments 05--------

create proc spinsertworkerpayments
@workid int,
@workerid int,
@totalworkhour float,
@totalpayment money
as
begin try insert into 
workerpayments(workid,workerid,totalworkhour,totalpayment)
values(@workid,@workerid,@totalworkhour,@totalpayment)
end try
begin catch
     declare @msg nvarchar(1000)
	 select @msg = error_message()
	 ;
	 throw 50001, @msg, 1
end catch
go
create proc spdeleteworkers
			@workerid int
as
begin try
      delete workers
	  where workerid = @workerid
end try
begin catch
         ;
		 throw 50001, 'can''t deleted', 1
end catch
go

----- table 3 workerareas ----------

create proc spdeleteworkerareas
			@workerid int
as
begin try
      delete workerareas
	  where workerid = @workerid
end try
begin catch
         ;
		 throw 50001, 'can not deleted', 1
end catch
go

----- table 4 works ----------

create proc spdelete @workid int
			
as
begin try
      delete works
	  where workid = @workid
end try
begin catch
         ;
		 throw 50001, 'can not deleted', 1
end catch
go
----- table 5 workerpayments ----------

create proc spdeleteworkerpayments
			@workerid int
as
begin try
      delete workerpayments
	  where workerid = @workerid
end try
begin catch
         ;
		 throw 50001, 'can not deleted', 1
end catch
go


---  join---
create view vdetails
as
select wp.workid,wp.workerid,totalpayment,totalworkhour
,wk.workername,phone,payrate,wa.areaid,wr.workareaid,wr.skill,
w.customename,endtime,startdate,workdescription
from workerpayments as wp
join workers wk on wp.workerid=wk.workerid
join workerareas wa on wk.workerid=wa.workerid
join workareas wr on wa.areaid=wr.workareaid
join works w on wr.workareaid=w.workareaid
go

-------- view ---------- 
create view  workerdetails
as 
select wp.workerid,workername,phone,payrate
,totalpayment
from workerpayments as wp
join workers wk on wp.workerid=wk.workerid
where workername = 'md.kafi';
go


-------- view 2 -------
create view  worksdetails
as 
select w.workid,wa.workareaid,customename,customeraddress,
startdate,endtime,skill
from works w
join workareas wa on w.workareaid=wa.workareaid
where workid = '501';

go
--udf
create function fnworkerlist(@workid int) returns table
as
return
(
	select w.workid, w.customename, w.customeraddress, w.startdate, w.endtime, wk.workername
	from works w
	inner join workerpayments wp on wp.workid = w.workid
	inner join workers wk on wp.workerid = wk.workerid
	where w.workid = @workid
)
go
create trigger trworkdelete
on works
after delete
as
begin
 declare @workid int
 select @workid = workid from inserted
 delete from workerpayments where workerid=@workid
end
go
