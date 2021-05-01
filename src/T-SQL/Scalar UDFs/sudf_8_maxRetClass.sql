--Class of items that is returned the most on catalog in the curent cycle (non-history).

create or alter function maxReturnClass()
returns char (50) as  
begin
	declare c1 cursor static for 
	(select i_class, count(i_class) as cnt
	from catalog_returns, item
	where i_item_sk = cr_item_sk
	group by i_class
	);
	declare @count int;
	declare @class char(50);
	declare @maxClass char(50);
	declare @maxReturn int =0;
	open c1;
	fetch next from c1 into @class, @count;
	while(@@fetch_status=0)
	begin
		if(@count>@maxReturn)
		begin
			set @maxReturn = @Count;
			set @maxclass = @class;
		end
		fetch next from c1 into @class, @count;
	end
	close c1;
	deallocate c1;
	return @maxClass;
end
go