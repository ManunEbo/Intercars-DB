/******************************************************************************************/
/************************** Extracting Fiscal Sale data by staff **************************/
/******************************************************************************************/

use icp;
drop procedure if exists Fiscal_Sale_by_Staff;
delimiter /

create procedure Fiscal_Sale_by_Staff()
	begin
		drop temporary table if exists Fiscal_Sale_staff;
		create temporary table Fiscal_Sale_staff as
		select a.Staff_id,
				concat(c.Fname, " ", c.Mname," ", c.Lname) as Staff,
				d.Make,
				d.Model,
				d.Reg_Numb,
				b.Sale_Date,
				case
					when  concat(year(b.Sale_Date),"/04/06") < b.Sale_Date and b.Sale_Date < concat(year(b.Sale_Date) + 1,"/04/06") then  year(b.Sale_Date)
					when b.Sale_Date < concat(year(b.Sale_Date),"/04/06") and b.Sale_Date > concat(year(b.Sale_Date) -1,"/04/06") then year(b.Sale_Date) -1
					else year(b.Sale_Date)
				end as financial_year,
				b.Sale_Time,
				b.Sale_Amount

		from icp.Staff a left join
		icp.Names c
		on a.Staff_id = c.Staff_id
		left join icp.Sale b
		on a.Staff_id = b.Staff_id
		left join icp.V5C d
		on b.V5C_id = d.V5C_id
		;

		select * from Fiscal_Sale_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year);

		drop temporary table if exists Fiscal_Sale_staff;

	end /
delimiter ;

