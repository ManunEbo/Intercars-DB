/*Creating the Op_Service procedures
	1: New service insert procedure
    2: Return from service update procedure
    3: Invoice update procedure
*/
use icp;

	/*1: New service insert procedure*/
drop procedure if exists Op_new_serv_call;

delimiter /
create procedure Op_new_serv_call()
	begin
		if @Mech_Grg_id <> "" then 
			begin
				insert into icp.Op_service(Mech_Grg_id,V5C_id,Serv_date,Serv_type,Description)
                values(@Mech_Grg_id,@V5C_id,@serv_date,@serv_type,@Description);
			end;
            
		elseif @Elect_mech_id <> "" then
			begin
				insert into icp.Op_service(Elect_mech_id,V5C_id,Serv_date,Serv_type,Description)
                values(@Elect_mech_id,@V5C_id,@serv_date,@serv_type,@Description);				
			end;
            
		elseif @MOT_Grg_id <> "" then
			begin
				insert into icp.Op_service(MOT_Grg_id,V5C_id,Serv_date,Serv_type,Description)
                values(@MOT_Grg_id,@V5C_id,@serv_date,@serv_type,@Description);
			end;
		elseif @Carwash_id <> "" then
			begin
				insert into icp.Op_service(Carwash_id,V5C_id,Serv_date,Serv_type,Description)
                values(@Carwash_id,@V5C_id,@serv_date,@serv_type,@Description);
			end;
		end if;
	end /
delimiter ;
    
			/*2: Return from service update procedure*/
            /*   Update the table with the service quality checks on the date
                 the vehicle returned from service
			*/
drop procedure if exists Return_from_service_call;
delimiter /
create procedure Return_from_service_call()
	begin
		if @Mech_Grg_id <> "" then 
			begin
				update icp.Op_service 
                set Serv_return_date = @Serv_return_date,
                    Service_quality_check_done = @Service_quality_check_done,
                    Service_quality_description = @Service_quality_description
				where Serv_date = @Serv_date and Mech_Grg_id = @Mech_Grg_id and V5C_id =@V5C_id;
			end;
		elseif @Elect_mech_id <> "" then
			begin
				update icp.Op_service 
                set Serv_return_date = @Serv_return_date,
                    Service_quality_check_done = @Service_quality_check_done,
                    Service_quality_description = @Service_quality_description
				where Serv_date = @Serv_date and Elect_mech_id = @Elect_mech_id and V5C_id =@V5C_id;
			end;
		elseif @MOT_Grg_id <> "" then
			begin
				update icp.Op_service 
                set Serv_return_date = @Serv_return_date,
                    Service_quality_check_done = @Service_quality_check_done,
                    Service_quality_description = @Service_quality_description
				where Serv_date = @Serv_date and MOT_Grg_id = @MOT_Grg_id and V5C_id =@V5C_id;
			end;
            
		elseif @Carwash_id <> "" then
			begin
				update icp.Op_service 
                set Serv_return_date = @Serv_return_date,
                    Service_quality_check_done = @Service_quality_check_done,
                    Service_quality_description = @Service_quality_description
				where Serv_date = @Serv_date and Carwash_id = @Carwash_id and V5C_id =@V5C_id;
			end;
		end if;
	end /
delimiter ;

					/*3: Invoice update procedure*/
					/* Update the table when the invoice for the vehicles has been sent
                       Update the Description to the service supplied on the invoice
                    */
drop procedure if exists Invoice_Update_call;
delimiter /

create procedure Invoice_Update_call()
	begin
		if @Mech_Grg_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and Mech_Grg_id = @Mech_Grg_id and V5C_id =@V5C_id;
			end;
		elseif @Elect_mech_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and Elect_mech_id = @Elect_mech_id and V5C_id =@V5C_id;
			end;
		elseif @MOT_Grg_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and MOT_Grg_id = @MOT_Grg_id and V5C_id =@V5C_id;
			end;
		elseif @Carwash_id <> "" then 
			begin
				update icp.Op_service 
					set Serv_Invoice_nbr = @Serv_Invoice_nbr,
                        Serv_Invoice_Date = @Serv_Invoice_Date,
                        Description = @Description,
                        Price = @Price
					where Serv_date = @Serv_date and Serv_return_date = @Serv_return_date and Carwash_id = @Carwash_id and V5C_id =@V5C_id;
			end;
		end if;
	end /
delimiter ;

