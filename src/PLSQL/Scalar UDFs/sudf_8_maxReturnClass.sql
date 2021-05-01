create or replace function maxReturnClass
return char is   --i_class is char(50) data type
    cnt number;
    cls char(50);
    maxClass char(50);
    maxReturn number;
    cursor c1 is  
        select i_class, count(i_class) as cnt
        from catalog_returns, item
        where i_item_sk = cr_item_sk
        group by i_class;
begin
	maxReturn := 0;
    open c1;
    loop
        fetch c1 into cls, cnt;
        exit when c1%NOTFOUND;
        if cnt>maxReturn then
            maxReturn := cnt;
            maxclass := cls;
        end if;
    end loop;
    close c1;
	return maxClass;
end;


select maxReturnClass from DUAL
