/*icp V5C update procedure*/
use icp;
drop procedure if exists icp_V5C_UpdateCall;
delimiter /
create procedure icp_V5C_UpdateCall()
	begin
		if @prev_Owner2_Acq_date = "" then
			set @prev_Owner2_Acq_date = null;
		end if;
        
        if @prev_Owner3_Acq_date = "" then
			set @prev_Owner3_Acq_date = null;
		end if;
        
        if @prev_Owner4_Acq_date = "" then
			set @prev_Owner4_Acq_date = null;
		end if;
        
		update icp.V5C set 
			Reg_numb = @Regnum,
			Prev_reg_num = @Prev_regnum,
			Doc_ref_Numb = @Document_Reference,
			Date_first_Reg = @First_reg,
			Date_first_Reg_UK = @first_reg_uk,
			Make = @Make,
			Model = @Model,
			Body_Type = @Bodytype,
			Tax_Class = @TaxClass,
			Type_Fuel = @FuelType,
			Nbr_seats = @number_Seats,
			Vehicle_Cat = @Vehicle_Category,
			Colour = @Colour,
			V5C_Lgbk_issue_date = @Logbook_Issued_date,
			Cylinder_capty = @Cylinder_capacity,
			Nbr_prev_owners = @nbr_Prev_Owners,
			Prev_owner1_Name = @Prev_owner1_Name,
			Prev_owner1_Addr = @Prev_Owner1_Address,
			Prev_owner1_Acq_date = @prev_Owner1_Acq_date,
			Prev_owner2_Name = @Prev_owner2_Name,
			Prev_owner2_Addr = @Prev_Owner2_Address,
			Prev_owner2_Acq_date = @prev_Owner2_Acq_date,
			Prev_owner3_Name = @Prev_owner3_Name,
			Prev_owner3_Addr = @Prev_Owner3_Address,
			Prev_owner3_Acq_date = @prev_Owner3_Acq_date,
			Prev_owner4_Name = @Prev_owner4_Name,
			Prev_owner4_Addr = @Prev_Owner4_Address,
			Prev_owner4_Acq_date = @prev_Owner4_Acq_date,
			Date_added = @date_added
			where V5C_id = @V5C_id;
    end /
delimiter ;


