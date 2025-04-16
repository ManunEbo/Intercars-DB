/******************************************************************************************************/
/************************** Extracting Fiscal deposit data by staff and Make **************************/
/******************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Deposit_freq_amount_by_Make;
delimiter /

create procedure Fiscal_Deposit_freq_amount_by_Make()
	begin

		drop temporary table if exists Fiscal_deposit_staff;
		create temporary table Fiscal_deposit_staff as
		select a.Staff_id,
				concat(c.Fname, " ", c.Mname," ", c.Lname) as Staff,
				d.Make,
				d.Model,
				d.Reg_Numb,
				b.Deposit_Date,
				case
					when  concat(year(b.Deposit_Date),"/04/06") < b.Deposit_Date and b.Deposit_Date < concat(year(b.Deposit_Date) + 1,"/04/06") then  year(b.Deposit_Date)
					when b.Deposit_Date < concat(year(b.Deposit_Date),"/04/06") and b.Deposit_Date > concat(year(b.Deposit_Date) -1,"/04/06") then year(b.Deposit_Date) -1
					else year(b.Deposit_Date)
				end as financial_year,
				b.Deposit_Time,
				b.Deposit_Amount

		from icp.Staff a left join
		icp.Names c
		on a.Staff_id = c.Staff_id
		left join icp.Deposit b
		on a.Staff_id = b.Staff_id
		left join icp.V5C d
		on b.V5C_id = d.V5C_id
		;

		select Staff_id,
				Staff,
                Make,
                count(Reg_Numb) as Fiscal_deposit_frequency,
                format(sum(Deposit_Amount),2) as Fiscal_deposit_amount
        from Fiscal_deposit_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year)
		group by Staff_id,Staff,Make
        order by Fiscal_deposit_amount desc;

		drop temporary table if exists Fiscal_deposit_staff;

	end /
delimiter ;