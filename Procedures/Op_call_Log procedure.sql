/*Creating procedure for icp.Op_call_Log*/
use icp;

drop procedure if exists Op_call_Log_call;
delimiter /
create procedure Op_call_Log_call()
	begin
		insert into icp.Op_call_Log(Name,Customer_sex,Tel,City_or_village,Vehicle_of_interest,V5C_id,Date_of_call,Time_of_Call,Deposit_flag)
		values(@Name,@Customer_sex,@Tel,@City_or_village,@Vehicle_of_interest,@V5C_id,@Date_of_call,@Time_of_Call,@Deposit_flag);
    end /
delimiter ;