/******************************************************************************************************/
/********************* Extracting Fiscal Vehicle viewing by Make and Sale flag =1 *********************/
/******************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Make_Viewing_frequency_Sale_call;
delimiter /

create procedure Fiscall_Make_Viewing_frequency_Sale_call()
	begin
		drop temporary table if exists Fiscal_Vehicle_viewing;
		create temporary table Fiscal_Vehicle_viewing as
		 select a.Vehicle_viewing_id,
				a.Vehicle_of_interest,
				a.V5C_id,
				b.Make,
				b.Model,
				b.Reg_numb,
				a.Nbr_Vehicles_viewed,
				a.Customer_Age_Bracket,
				a.Customer_sex,
				a.City_or_village,
				a.Viewing_date,
				case 
					when  concat(year(a.Viewing_date),"/04/06") < a.Viewing_date and a.Viewing_date < concat(year(a.Viewing_date) + 1,"/04/06") then  year(a.Viewing_date)

					when a.Viewing_date < concat(year(a.Viewing_date),"/04/06") and a.Viewing_date > concat(year(a.Viewing_date) -1,"/04/06") then year(a.Viewing_date) -1
					else year(a.Viewing_date)
				end as financial_year,
				a.Viewing_time,
				a.Deposit_Flag,
				a.Sale_Flag,
				a.Date_added
		from icp.Op_vehicle_viewing as a left join
			 icp.V5C as b
			 on a.V5C_id = b.V5C_id;

			-- ***** Extracting Fiscal Make Vehicle viewing frequency *****
			select Make,
					count(V5C_id) as Fiscal_Viewing_frequency,
					sum(Deposit_Flag) as Deposit_frequency,
					sum(Sale_Flag) as Sale_frequency
			from Fiscal_Vehicle_viewing
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year) and  Sale_Flag = 1
			 group by Make
			 order by Fiscal_Viewing_frequency desc;
             
		drop temporary table if exists Fiscal_Vehicle_viewing;
        
	end /
delimiter ;