/*Creating procedure for icp.Op_vehicle_viewing*/

drop procedure if exists Op_vehicle_viewing_call
delimiter /
create procedure Op_vehicle_viewing_call()
	begin
		insert into icp.Op_vehicle_viewing(Vehicle_of_interest,V5C_id,Nbr_Vehicles_viewed,Customer_Age_Bracket,Customer_sex,
									City_or_village,Viewing_date,Viewing_time,Deposit_Flag,Sale_Flag)
		values(@Vehicle_of_interest,@V5C_id,@Nbr_Vehicles_viewed,@Customer_Age_Bracket,@Customer_sex,
									@City_or_village,@Viewing_date,@Viewing_time,@Deposit_Flag,@Sale_Flag);
    end /
delimiter ;