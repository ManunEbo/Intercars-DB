/**************************************************************************************************/
/******************************** Extracting Fiscal Call_log by Make ******************************/
/**************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_Make;
delimiter /

create procedure Fiscal_Call_Log_by_Make()
	begin
		drop temporary table if exists Fiscal_call_log;
		create temporary table Fiscal_call_log as
		select a.Call_log_id,
				a.Name,
				a.Customer_sex,
				a.Tel,
				a.City_or_village,
				a.Vehicle_of_interest,
				a.V5C_id,
				b.Make,
				b.Model,
				b.Reg_numb,
				a.Date_of_call,
				case 
					when  concat(year(a.Date_of_call),"/04/06") < a.Date_of_call and a.Date_of_call < concat(year(a.Date_of_call) + 1,"/04/06") then  year(a.Date_of_call)

					when a.Date_of_call < concat(year(a.Date_of_call),"/04/06") and a.Date_of_call > concat(year(a.Date_of_call) -1,"/04/06") then year(a.Date_of_call) -1
					else year(a.Date_of_call)
				end as financial_year,
				a.Time_of_Call,
                a.Deposit_flag,
				a.Date_added
		from icp.Op_call_Log as a left join
			 icp.V5C as b
			 on a.V5C_id = b.V5C_id;


			-- ***** Extracting Fiscal Make frequency of calls *****
			select Make,
					count(distinct Reg_numb) as Make_frequency,
					count(V5C_id) as Call_frequency,
					sum(Deposit_flag) as Call_Deposit_frequency
			from Fiscal_call_log
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)	 
			 group by Make
			 order by Call_frequency desc;
	drop temporary table if exists Fiscal_call_log;
    
	end /
delimiter ;