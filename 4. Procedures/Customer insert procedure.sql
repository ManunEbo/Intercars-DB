use icp;

/*Creating procedure for Customer insert*/
drop procedure if exists Customer_Insert_call;
delimiter /
create procedure Customer_Insert_call()
begin
	insert into icp.Customer()
    values();
end /
delimiter ;