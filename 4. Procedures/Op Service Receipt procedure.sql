/*Creating the procedure for Operation Service Receipt*/
use icp;
drop procedure if exists Op_service_receipt_call;
delimiter /
create procedure Op_service_receipt_call()
	begin
		insert into icp.Op_service_Receipt(Op_service_id,Split_payment,Trans_Date,Trans_time,Auth_code,Receipt_nbr,Amount)
		values(@Op_service_id,@Split_payment,@Trans_Date,@Trans_time,@Auth_code,@Receipt_nbr,@Amount);
	end /
delimiter ;