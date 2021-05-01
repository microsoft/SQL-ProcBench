CREATE or ALTER TRIGGER dateTableChanges ON date_dim
after INSERT
AS  
	declare @year int, @month int, @day int;
	declare @date date;
	set @year = (select d_year from inserted);
	set @month = (select d_moy from inserted);
	set @day = (select d_dom from inserted);
	set @date = (select d_date from inserted);

	if(@year=NULL or @year<2100 or (@year=2100 and @month=01 and @day=01))
	begin
		RAISERROR('illegal insert in date table', 10, 1);
		rollback transaction;
		return;
	end

	if(@date is NULL and (@year is NULL or @month is NULL or @day is NULL))
	begin
		RAISERROR('cannot insert incomplete date information', 10, 1);
		rollback transaction;
		return;
	end

	if(@date is not NULL)
	begin	
		declare @dDay int = DAY(@date);
		declare @dMonth int = MONTH(@date);
		declare @dYear int = YEAR(@date);
		if((@year is not NULL and @year!=@dYear) or (@month is not NULL and @month!=@dMonth) or (@day is not NULL and @day!=@dDay))
		begin
			RAISERROR('Inconsistent data values', 10, 1);
			rollback transaction;
			return;
		end
	end

GO 

--invocation query
insert into date_dim (d_date_sk, d_date_id, d_date, d_year, d_moy, d_dom) values (3488070, 'ACHOFIRSYCHGRUFG', '3022-01-19', 3022, 01, 19);