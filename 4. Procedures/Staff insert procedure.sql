use icp;

/*Creating procedure for Staff insert*/
drop procedure if exists Staff_Insert_call;
delimiter /
create procedure Staff_Insert_call()
begin
	insert into icp.Staff(Passwd,Iv)
    values(@Passwd ,@random_bytes);
end /
delimiter ;