/*MOT Refusal procedure*/
use icp;
drop procedure if exists icp_MOT_Refusal_call()
delimiter /
create procedure icp_MOT_Refusal_call()
	begin    
		insert into icp.MOT_Refusal(V5C_id,Vehicle_Reg_MOT_Date,Test_comp,Test_Addr,
			Test_Date,Ref_Reason1,Ref_Reason2,Ref_Reason3,Ref_Reason4,Ref_Reason5)
		VALUES(@V5C_ID,@Vehicle_Reg_MOT_Date,@Test_comp,@Test_Addr,@Test_Date,
			@Ref_Reason1,@Ref_Reason2,@Ref_Reason3,@Ref_Reason4,@Ref_Reason5);
	end /
delimiter ;