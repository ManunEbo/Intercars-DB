/*icp MOT History procedure*/
use icp;
drop procedure if exists icp_MOT_History_call;
delimiter /
create procedure  icp_MOT_History_call ()
Begin
		Insert into icp.MOT_History(V5C_ID,Vehicle_Reg_MOT_Date,Test_Org,Test_Addr,
				Test_Date,Expiry_date,Advisory1,Advisory2,Advisory3,Advisory4,Advisory5,
				MOT_tst_Cert_Nbr,Price)
		values(@V5C_ID,@Vehicle_Reg_MOT_Date,@Test_Org,@Test_Addr,
				@Test_Date, @Expiry_date,@Advisory1,@Advisory2,
				@Advisory3,@Advisory4,@Advisory5,@MOT_tst_Cert_Nbr,@Price);
end /
delimiter ;