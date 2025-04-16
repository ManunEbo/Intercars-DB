/*icp Auction Invoice procedure*/

use icp;

drop procedure if exists icp_Auction_invoice_call;

Delimiter /

create procedure icp_Auction_invoice_call()
	begin
		insert into icp.Auction_invoice(V5C_id,Auction_id,Vendor_id,Invoice_nbr,Invoice_Date,Reg_nbr,Make,Model,
								Date_first_Reg,MOT,MOT_Expiry_date,Mileage,Cash_Payment,Price,Buyers_Fee,
								Assurance_Fee,Other_Fee,Storage_Fee,Cash_Handling_fee,Auction_VAT,Total)
			Values(@V5C_id,@Auction_id,@Vendor_id,@Invoice_nbr,@Invoice_Date,@Reg_nbr,@Make,@Model,@Date_first_Reg,
					@MOT,@MOT_Expiry_date,@Mileage,@Cash_Payment,@Price,@Buyers_Fee,@Assurance_Fee,@Other_Fee,@Storage_Fee,
                    @Cash_Handling_fee,@Auction_VAT,@Total);
    end /
Delimiter ;