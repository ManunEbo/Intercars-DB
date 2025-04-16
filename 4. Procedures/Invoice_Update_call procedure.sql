					/*3: Invoice update procedure*/
					/* Update the table when the invoice for the vehicles has been sent
                       Update the Serv_Invoice_Description to the service supplied on the invoice */
drop procedure if exists Invoice_Update_call;
delimiter /

create procedure Invoice_Update_call()
	begin
		if @Mech_Grg_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Serv_Invoice_Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and Mech_Grg_id = @Mech_Grg_id and V5C_id =@V5C_id;
			end;
		elseif @Elect_mech_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Serv_Invoice_Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and Elect_mech_id = @Elect_mech_id and V5C_id =@V5C_id;
			end;
		elseif @MOT_Grg_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Serv_Invoice_Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and MOT_Grg_id = @MOT_Grg_id and V5C_id =@V5C_id;
			end;
		elseif @Carwash_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Serv_Invoice_Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and Carwash_id = @Carwash_id and V5C_id =@V5C_id;
			end;
		end if;
	end /
delimiter ;