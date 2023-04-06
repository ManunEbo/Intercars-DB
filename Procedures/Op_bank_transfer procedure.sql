/*Creating the Op_bank_transfer procedure*/

use icp;
drop procedure if exists Op_bank_transfer_call;
delimiter /

create procedure Op_bank_transfer_call()
	begin
		insert into  icp.Op_bank_transfer(Op_service_id,Split_payment,Transfer_amount,Transfer_date)
		values(@Op_service_id,@Split_payment,@Transfer_amount,@Transfer_date);
	end /
delimiter ;