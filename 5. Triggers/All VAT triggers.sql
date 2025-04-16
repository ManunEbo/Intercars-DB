use icp;
-- desc icp.Op_VAT;

/*The icp.Op_VAT table is filled using trigger*/
-- Gross_Price
-- VAT_rate
-- VAT
-- Net

/*1: Trigger after insert on Op_service_Receipt*/

Drop Trigger if exists Op_Vat_service_Receipt_insert;
delimiter /
create trigger Op_Vat_service_Receipt_insert
	after insert on icp.Op_service_Receipt
		for each row
			begin

				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_service_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_service_id,new.Amount,@VAT_rate, @VAT, @Net);
                        
					end;
				end if;
			end /
delimiter ;

/*2: Trigger after insert on Op_bank_transfer*/

Drop Trigger if exists Op_Vat_bank_transfer_insert;
delimiter /
create trigger Op_Vat_bank_transfer_insert
	after insert on icp.Op_bank_transfer
		for each row
			begin

				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_service_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_service_id,new.Transfer_amount,@VAT_rate, @VAT, @Net);
                        
					end;
				end if;
			end /
delimiter ;

/*3: Trigger after insert on Op_misc_Receipt*/

Drop Trigger if exists Op_Vat_misc_Receipt_insert;
delimiter /
create trigger Op_Vat_misc_Receipt_insert
	after insert on icp.Op_misc_Receipt
		for each row
			begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_misc_Receipt_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_misc_Receipt_id,@Gross_Price,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end /
delimiter ;

/*4: Trigger after insert on Auction_invoice*/

Drop Trigger if exists Op_Vat_Auction_invoice_insert;
delimiter /
create trigger Op_Vat_Auction_invoice_insert
	after insert on icp.Auction_invoice
		for each row
			begin
				insert into icp.Op_VAT(Auct_Invoice_id,Gross_Price,VAT_rate,VAT,Net)
				values(new.Auct_Invoice_id,new.Total,@VAT_rate, new.Auction_VAT, new.Total - new.Auction_VAT);
			end /
delimiter ;