use icp;
drop procedure if exists icp_service_history_call;
delimiter /
create procedure icp_service_history_call()
	begin
		insert into icp.Service_History(V5C_id,Vehicle_Reg_serv_Date,Serv_comp,
		Serv_Addr,Serv_Date,Serv_Parts_desc,Quantity,Unit_price,Sum_per_Parts,
		Total_Labour,Total_Parts,MOT_Fee,VAT,Grand_Total)
		values(@V5C_id,@Vehicle_Reg_serv_Date,@Serv_comp,@Serv_Addr,@Serv_Date,
		@Serv_Parts_desc, @Quantity, @Unit_price, @Sum_per_Parts, @Total_Labour,
		@Total_Parts,@MOT_Fee,@VAT,@Grand_Total);
    end /
delimiter ;


