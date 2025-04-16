/* Creating the Op_misc_Receipt procedure */
use icp;

drop procedure if exists Op_misc_receipt_Call;
delimiter /
create procedure Op_misc_receipt_Call()
	begin
		insert into icp.Op_misc_Receipt(Venue,Vat_registration,Item,Price,Quantity,Total,Auth_Code,Receipt_nbr,Receipt_date,Receipt_time)
		Values(@Venue,@Vat_registration,@Item,@Price,@Quantity,@Total,@Auth_Code,@Receipt_nbr,@Receipt_date,@Receipt_time);
	end /
delimiter ;