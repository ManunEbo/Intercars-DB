	/*Mileage History procedure*/

drop procedure if exists icp_Mileage_History_call;
delimiter /
create procedure icp_Mileage_History_call()
	begin
		insert into icp.Mileage_History(V5C_id,Vehicle_Reg_MOT_Date,Source,Mileage,Date)
		Values(@V5C_id,@Vehicle_Reg_MOT_Date,@Source,@Mileage,@Date);
	end /
delimiter ;