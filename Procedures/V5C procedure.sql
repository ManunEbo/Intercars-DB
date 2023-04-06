/*icp V5C procedure*/
use icp;
drop procedure if exists icp_V5C_Call;
delimiter /
create procedure icp_V5C_Call()
	begin
		if @Prev_owner2_Name ="" and @Prev_owner3_Name ="" and @Prev_owner4_Name="" then 
			begin
				insert into icp.V5C(Reg_numb,Prev_reg_num,Doc_ref_Numb,Date_first_Reg,Date_first_Reg_UK,Make,Model,Body_Type,Tax_Class,Type_Fuel,Nbr_seats,Vehicle_Cat,
				Colour,V5C_Lgbk_issue_date,Cylinder_capty,Nbr_prev_owners,Prev_owner1_Name,Prev_owner1_Addr,Prev_owner1_Acq_date)

				values(@Regnum,@Prev_regnum,@Document_Reference,@First_reg,@first_reg_uk,@Make,@Model,@Bodytype,@TaxClass,@FuelType,@number_Seats,@Vehicle_Category,
				@Colour,@Logbook_Issued_date,@Cylinder_capacity,@nbr_Prev_Owners,@Prev_owner1_Name,@Prev_Owner1_Address,@prev_Owner1_Acq_date);
            end;
        elseif @Prev_owner2_Name <> "" and @Prev_owner3_Name ="" and @Prev_owner4_Name="" then
			begin
				insert into icp.V5C(Reg_numb,Prev_reg_num,Doc_ref_Numb,Date_first_Reg,Date_first_Reg_UK,Make,Model,Body_Type,Tax_Class,Type_Fuel,Nbr_seats,Vehicle_Cat,
				Colour,V5C_Lgbk_issue_date,Cylinder_capty,Nbr_prev_owners,Prev_owner1_Name,Prev_owner1_Addr,Prev_owner1_Acq_date,Prev_owner2_Name,Prev_owner2_Addr,Prev_owner2_Acq_date
				)

				values(@Regnum,@Prev_regnum,@Document_Reference,@First_reg,@first_reg_uk,@Make,@Model,@Bodytype,@TaxClass,@FuelType,@number_Seats,@Vehicle_Category,
				@Colour,@Logbook_Issued_date,@Cylinder_capacity,@nbr_Prev_Owners,@Prev_owner1_Name,@Prev_Owner1_Address,@prev_Owner1_Acq_date,
				@Prev_owner2_Name,@Prev_Owner2_Address,@prev_Owner2_Acq_date);
			end;
            
		elseif @Prev_owner2_Name <> "" and @Prev_owner3_Name <> "" and @Prev_owner4_Name="" then
			begin
				insert into icp.V5C(Reg_numb,Prev_reg_num,Doc_ref_Numb,Date_first_Reg,Date_first_Reg_UK,Make,Model,Body_Type,Tax_Class,Type_Fuel,Nbr_seats,Vehicle_Cat,
				Colour,V5C_Lgbk_issue_date,Cylinder_capty,Nbr_prev_owners,Prev_owner1_Name,Prev_owner1_Addr,Prev_owner1_Acq_date,Prev_owner2_Name,Prev_owner2_Addr,Prev_owner2_Acq_date,
				Prev_owner3_Name,Prev_owner3_Addr,Prev_owner3_Acq_date)

				values(@Regnum,@Prev_regnum,@Document_Reference,@First_reg,@first_reg_uk,@Make,@Model,@Bodytype,@TaxClass,@FuelType,@number_Seats,@Vehicle_Category,
				@Colour,@Logbook_Issued_date,@Cylinder_capacity,@nbr_Prev_Owners,@Prev_owner1_Name,@Prev_Owner1_Address,@prev_Owner1_Acq_date,
				@Prev_owner2_Name,@Prev_Owner2_Address,@prev_Owner2_Acq_date,@Prev_owner3_Name,@Prev_Owner3_Address,@prev_Owner3_Acq_date);
			end;
        elseif @Prev_owner2_Name <> "" and @Prev_owner3_Name <> "" and @Prev_owner4_Name <> "" then
			begin
				insert into icp.V5C(Reg_numb,Prev_reg_num,Doc_ref_Numb,Date_first_Reg,Date_first_Reg_UK,Make,Model,Body_Type,Tax_Class,Type_Fuel,Nbr_seats,Vehicle_Cat,
				Colour,V5C_Lgbk_issue_date,Cylinder_capty,Nbr_prev_owners,Prev_owner1_Name,Prev_owner1_Addr,Prev_owner1_Acq_date,Prev_owner2_Name,Prev_owner2_Addr,Prev_owner2_Acq_date,
				Prev_owner3_Name,Prev_owner3_Addr,Prev_owner3_Acq_date,Prev_owner4_Name,Prev_owner4_Addr,Prev_owner4_Acq_date)

				values(@Regnum,@Prev_regnum,@Document_Reference,@First_reg,@first_reg_uk,@Make,@Model,@Bodytype,@TaxClass,@FuelType,@number_Seats,@Vehicle_Category,
				@Colour,@Logbook_Issued_date,@Cylinder_capacity,@nbr_Prev_Owners,@Prev_owner1_Name,@Prev_Owner1_Address,@prev_Owner1_Acq_date,
				@Prev_owner2_Name,@Prev_Owner2_Address,@prev_Owner2_Acq_date,@Prev_owner3_Name,@Prev_Owner3_Address,@prev_Owner3_Acq_date,
				@Prev_owner4_Name,@Prev_Owner4_Address,@prev_Owner4_Acq_date);
            end;
            
		end if;
    
    end /
delimiter ;