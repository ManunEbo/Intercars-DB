/************************************************************************************************************/
/******************************** Extracting Fiscal Revenue and Profit by Make ******************************/
/************************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Total_Revenue_and_Profit_by_Make_call;
delimiter /

create procedure Fiscall_Total_Revenue_and_Profit_by_Make_call()
	begin
    
		-- *Creating view 'a' to extract fiscal cost of service *
		drop temporary table if exists a;
		create temporary table a as 
		select a.V5C_id,
				a.Make,
				a.Model,
				d.Serv_Invoice_nbr,
				d.Serv_Invoice_Date,
				case 
							when  concat(year(d.Serv_Invoice_Date),"/04/06") < d.Serv_Invoice_Date and d.Serv_Invoice_Date < concat(year(d.Serv_Invoice_Date) + 1,"/04/06") then  year(d.Serv_Invoice_Date)

							when d.Serv_Invoice_Date < concat(year(d.Serv_Invoice_Date),"/04/06") and d.Serv_Invoice_Date > concat(year(d.Serv_Invoice_Date) -1,"/04/06") then year(d.Serv_Invoice_Date) -1
							else year(d.Serv_Invoice_Date)
							end as financial_year_invoice,
				d.Price
		from icp.V5C as a left join
			icp.Op_service as d
				on a.V5C_id = d.V5C_id;



		-- *** Selecting fiscal a ***
		drop temporary table if exists Fiscal_a;
		create temporary table Fiscal_a as
		select * from a
		where financial_year_invoice = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year_inv);


		-- *Creating view b to extract fiscal deposit revenue*
		drop temporary table if exists b;      
		create temporary table b as 
		select a.V5C_id,
				a.Make,
				a.Model,        
				c.Deposit_Date,
				case 
							when  concat(year(c.Deposit_Date),"/04/06") < c.Deposit_Date and c.Deposit_Date < concat(year(c.Deposit_Date) + 1,"/04/06") then  year(c.Deposit_Date)

							when c.Deposit_Date < concat(year(c.Deposit_Date),"/04/06") and c.Deposit_Date > concat(year(c.Deposit_Date) -1,"/04/06") then year(c.Deposit_Date) -1
							else year(c.Deposit_Date)
							end as financial_year_Deposit,
				c.Deposit_Amount
				
		from icp.V5C as a left join
			 icp.Deposit as c
				on a.V5C_id = c.V5C_id;

		-- *** Selecting fiscal b ***
		drop temporary table if exists Fiscal_b;
		create temporary table Fiscal_b as
		select * from b
		where financial_year_Deposit = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year_dep);

		-- *Creating view c to extract fiscal sale revenue*
		drop temporary table if exists c;
		create temporary table c as 
		select a.V5C_id,
				a.Make,
				a.Model, 
				b.Sale_Date,
				case 
							when  concat(year(b.Sale_date),"/04/06") < b.Sale_date and b.Sale_date < concat(year(b.Sale_date) + 1,"/04/06") then  year(b.Sale_date)

							when b.Sale_date < concat(year(b.Sale_date),"/04/06") and b.Sale_date > concat(year(b.Sale_date) -1,"/04/06") then year(b.Sale_date) -1
							else year(b.Sale_date)
							end as financial_year_sale,
				b.Sale_Amount
				
		from icp.V5C as a left join
			 icp.Sale as b
				on a.V5C_id= b.V5C_id;

		-- *** Selecting fiscal c ***
		drop temporary table if exists Fiscal_c;
		create temporary table Fiscal_c as 
		select * from c
		where financial_year_sale = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year_sal);

		-- *************************************************************************************************************
		drop temporary table if exists Fiscal_a_b_c;
		create temporary table Fiscal_a_b_c as 
		select a.Make,
				sum(distinct ifnull(d.Sale_Amount,0))+ sum(distinct ifnull(c.Deposit_Amount,0)) as Total_Revenue,
				sum(distinct ifnull(e.Total,0)) as Vehicle_Purchase_Price,
				sum(distinct ifnull( d.Sale_Amount,0))+ sum(distinct ifnull(c.Deposit_Amount,0)) - sum(distinct ifnull(b.Price,0)) - sum(distinct ifnull(e.Total,0)) as Profit
		from icp.V5C as a left join
		Fiscal_a as b 
		on a.V5C_id = b.V5C_id 
		left join 
		Fiscal_b as c
		on a.V5C_id = c.V5C_id
		left join
		Fiscal_c as d
		on a.V5C_id = d.V5C_id
		left join
		icp.Auction_invoice as e
		on a.V5C_id = e.V5C_id
		group by a.Make
		order by Total_Revenue desc;

		select * from Fiscal_a_b_c;
		
		drop temporary table if exists a;
		drop temporary table if exists Fiscal_a;
		drop temporary table if exists b;
		drop temporary table if exists Fiscal_b;
		drop temporary table if exists c;
		drop temporary table if exists Fiscal_c;
		drop temporary table if exists Fiscal_a_b_c;

	end /
delimiter ;