/************************************************************************************************************/
/******************************************** ICP all procedures ********************************************/
/************************************************************************************************************/


/*icp Auction Invoice procedure*/

use icp;

drop procedure if exists icp_Auction_invoice_call;

Delimiter /

create procedure icp_Auction_invoice_call()
	begin
		insert into icp.Auction_invoice(V5C_id,Auction_id,Vendor_id,Invoice_nbr,Invoice_Date,Reg_nbr,Make,Model,
								Date_first_Reg,MOT,MOT_Expiry_date,Mileage,Cash_Payment,Price,Buyers_Fee,
								Assurance_Fee,Other_Fee,Storage_Fee,Cash_Handling_fee,Auction_VAT,Total)
			Values(@V5C_id,@Auction_id,@Vendor_id,@Invoice_nbr,@Invoice_Date,@Reg_nbr,@Make,@Model,@Date_first_Reg,
					@MOT,@MOT_Expiry_date,@Mileage,@Cash_Payment,@Price,@Buyers_Fee,@Assurance_Fee,@Other_Fee,@Storage_Fee,
                    @Cash_Handling_fee,@Auction_VAT,@Total);
    end /
Delimiter ;


/************************************************************************************************************/

/*Creating the current financial year expenditure pie chart procedure*/

use icp;
drop procedure if exists Cur_fin_expenditure_pie_c_call;
delimiter /

create procedure Cur_fin_expenditure_pie_c_call()
	begin
			
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Retrieving data for current financial year pie chart ****

		select Auction_id,
		Entity_Name,
		sum(Auction_VAT) as Total_vat,
		sum(Total) as Summary
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
                when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)
		group by Auction_id, Entity_Name
		order by Auction_id, Entity_Name;
        
        drop temporary table if exists fin_year;
	end /
delimiter ;

/************************************************************************************************************/
use icp;

/*Creating procedure for Customer insert*/
drop procedure if exists Customer_Insert_call;
delimiter /
create procedure Customer_Insert_call()
begin
	insert into icp.Customer()
    values();
end /
delimiter ;

/************************************************************************************************************/

/*Creating the current financial year auction invoice data */

use icp;
drop procedure if exists Fiscal_auction_invoice_by_auction_call;
delimiter /

create procedure Fiscal_auction_invoice_by_auction_call()
	begin
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
                year(b.Invoice_Date) as Invoice_Year,
                month(b.Invoice_Date) as Invoice_Month,
                concat(year(b.Invoice_Date), "/",month(b.Invoice_Date)) as Year_and_month,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
                b.Date_added,
                
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Monthly fiscal Summary VAT and expenditure overall****

		select Auction_id,
		Entity_Name,
        count(Auction_id) as Auction_frequency,
		sum(ifnull(Auction_VAT,0)) as Total_Vat,
		sum(ifnull(Total,0)) as Expenditure
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)
		group by Auction_id,Entity_Name
		order by Expenditure desc
		;
        
        drop temporary table if exists fin_year;
	end /
delimiter ;

/************************************************************************************************************/

/*Creating the current financial year auction invoice data */

use icp;
drop procedure if exists Fiscal_auction_invoice_by_year_and_month_call;
delimiter /

create procedure Fiscal_auction_invoice_by_year_and_month_call()
	begin
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
                year(b.Invoice_Date) as The_year,
                month(b.Invoice_Date) as The_month,
                concat(year(b.Invoice_Date), "/",month(b.Invoice_Date)) as Year_and_month,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
                b.Date_added,
                
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Monthly fiscal Summary VAT and expenditure by year and month****

		select The_year,
		The_month,
        Year_and_month,
        count(Auction_id) as Auction_frequency,
		sum(ifnull(Auction_VAT,0)) as Total_Vat,
		sum(ifnull(Total,0)) as Expenditure
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)
		group by The_year,The_month,Year_and_month
		order by Expenditure desc
		;
        drop temporary table if exists fin_year;
	end /
delimiter ;

/************************************************************************************************************/

/*Creating the current financial year auction invoice data */

use icp;
drop procedure if exists Fiscal_auction_invoice_data_call;
delimiter /

create procedure Fiscal_auction_invoice_data_call()
	begin
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
                year(b.Invoice_Date) as Invoice_Year,
                month(b.Invoice_Date) as Invoice_Month,
                concat(year(b.Invoice_Date), "/",month(b.Invoice_Date)) as Year_and_month,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
                b.Date_added,
                
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Selecting fiscal auction invoice data****

		select Auction_id,
		Entity_Name,
		Invoice_nbr,
		Invoice_Date,
		financial_year,
		Invoice_Year,
		Invoice_Month,
		Year_and_month,
		Reg_nbr,
		Make,
		Model,
		Date_first_Reg,
		MOT_Expiry_date,
		Mileage,
		Cash_Payment,
		Price,
		Buyers_Fee,
		Assurance_Fee,
		Other_Fee,
		Storage_Fee,
		Cash_Handling_fee,
		Auction_VAT,
		Total,
		Date_added
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)
		;
        drop temporary table if exists fin_year;
	end /
delimiter ;

/*****************************************************************************************************************************/
/******************************** Extracting Fiscal City_or_village and Make frequency of calls ******************************/
/*****************************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_City_or_village_Make;
delimiter /

create procedure Fiscal_Call_Log_by_City_or_village_Make()
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

			-- ***** Extracting Fiscal City_or_village Make frequency of calls *****
			select City_or_village,
					Make,
					count(distinct Reg_numb) as Make_frequency,
					count(V5C_id) as Fiscal_Call_frequency,
					sum(Deposit_flag) as Call_Deposit_frequency
			from Fiscal_call_log
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)
			 group by City_or_village, Make
			 order by Fiscal_Call_frequency desc;
             
             drop temporary table if exists Fiscal_call_log;
	end /
delimiter ;

/*****************************************************************************************************************************/
/******************************** Extracting Fiscal City_or_village and Make frequency of calls ******************************/
/*****************************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_City_or_village_Model;
delimiter /

create procedure Fiscal_Call_Log_by_City_or_village_Model()
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
				a.Date_added
		from icp.Op_call_Log as a left join
			 icp.V5C as b
			 on a.V5C_id = b.V5C_id;

			 -- ***** Extracting Fiscal city_or_village Model frequency of calls *****
			select City_or_village,
					Make,
					Model,        
					count(V5C_id) as Fiscal_Call_frequency
			from Fiscal_call_log
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)	 
			 group by City_or_village, Make, Model
			 order by Fiscal_Call_frequency desc;
             
	drop temporary table if exists Fiscal_call_log;
             
	end /
delimiter ;

/********************************************************************************************************************/
/******************************** Extracting Fiscal City_or_village frequency of calls ******************************/
/********************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_City_or_village;
delimiter /

create procedure Fiscal_Call_Log_by_City_or_village()
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

			-- ***** Extracting Fiscal City_or_village frequency of calls *****
			select City_or_village,
					count(V5C_id) as Fiscal_Call_frequency
			from Fiscal_call_log
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)	 
			 group by City_or_village
			 order by Fiscal_Call_frequency desc;
	drop temporary table if exists Fiscal_call_log;
	end /
delimiter ;

/**************************************************************************************************/
/******************** Extracting Fiscal Call_log by Make where Deposit_flag =1 ********************/
/**************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_Make_Deposit_flag_1;
delimiter /

create procedure Fiscal_Call_Log_by_Make_Deposit_flag_1()
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


			-- ***** Extracting Fiscal Make frequency of calls where Deposit_flag =1 *****
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
						end as fin_year) and Deposit_flag=1
			 group by Make
			 order by Call_frequency desc;
	drop temporary table if exists Fiscal_call_log;
	end /
delimiter ;

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

/**************************************************************************************************/
/******************** Extracting Fiscal Call_log by Model where Deposit_flag =1 *******************/
/**************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_Model_Deposit_flag_1;
delimiter /

create procedure Fiscal_Call_Log_by_Model_Deposit_flag_1()
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

				-- ***** Extracting Fiscal Model frequency of calls where  Deposit_flag =1*****
				select Make,
						Model,
						count(distinct Reg_numb) as Model_frequency,
						count(V5C_id) as Call_frequency,
						sum(Deposit_flag) as Call_Deposit_frequency

				from Fiscal_call_log
				 where financial_year  = (select case 
							when month(curdate()) in (1,2,3) then year(curdate()) -1
							when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
							when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
							when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
							end as fin_year)	and  Deposit_flag =1
				 group by Make, Model
				 order by Call_frequency desc;
                 
		drop temporary table if exists Fiscal_call_log;
	end /
delimiter ;


/**************************************************************************************************/
/******************************** Extracting Fiscal Call_log by Model ******************************/
/**************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log_by_Model;
delimiter /

create procedure Fiscal_Call_Log_by_Model()
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

			-- ***** Extracting Fiscal Model frequency of calls *****
			select Make,
					Model,
					count(distinct Reg_numb) as Model_frequency,
					count(V5C_id) as Call_frequency,
					sum(Deposit_flag) as Call_Deposit_frequency

			from Fiscal_call_log
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)	 
			 group by Make, Model
			 order by Call_frequency desc;
	drop temporary table if exists Fiscal_call_log;
	end /
delimiter ;


/*******************************************************************************************/
/******************************** Extracting Fiscal Call_log  ******************************/
/*******************************************************************************************/

use icp;
drop procedure if exists Fiscal_Call_Log;
delimiter /

create procedure Fiscal_Call_Log()
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


		-- *Extracting Fiscal call_log*
		select * 
		from Fiscal_call_log
		 where financial_year  = (select case 
					when month(curdate()) in (1,2,3) then year(curdate()) -1
					when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
					when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
					when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
					end as fin_year);
                    
		drop temporary table if exists Fiscal_call_log;
	end /
delimiter ;

/*********************************************************************************************/
/************************** Extracting Fiscal deposit data by staff **************************/
/*********************************************************************************************/

use icp;
drop procedure if exists Fiscal_Deposit_by_Staff;
delimiter /

create procedure Fiscal_Deposit_by_Staff()
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

		select * from Fiscal_deposit_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year);

		drop temporary table if exists Fiscal_deposit_staff;

	end /
delimiter ;

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

/******************************************************************************************************/
/************************** Extracting Fiscal deposit data by staff and Model *************************/
/******************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Deposit_freq_amount_by_Model;
delimiter /

create procedure Fiscal_Deposit_freq_amount_by_Model()
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
                Model,
                count(Reg_Numb) as Fiscal_deposit_frequency,
                format(sum(Deposit_Amount),2) as Fiscal_deposit_amount
        from Fiscal_deposit_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year)
		group by Staff_id,Staff,Make,Model
        order by Fiscal_deposit_amount desc;

		drop temporary table if exists Fiscal_deposit_staff;

	end /
delimiter ;


/*********************************************************************************************/
/************************** Extracting Fiscal deposit data by staff **************************/
/*********************************************************************************************/

use icp;
drop procedure if exists Fiscal_Deposit_freq_amount_by_Staff;
delimiter /

create procedure Fiscal_Deposit_freq_amount_by_Staff()
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
                count(Reg_Numb) as Fiscal_deposit_frequency,
                sum(Deposit_Amount) as Fiscal_deposit_amount
        from Fiscal_deposit_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year)
		group by Staff_id,Staff
        order by Fiscal_deposit_amount desc;

		drop temporary table if exists Fiscal_deposit_staff;

	end /
delimiter ;


/********************************************************************************************************************/
/******************************** Extracting Fiscal Deposit Revenue and Profit by Make ******************************/
/********************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Deposit_Revenue_by_Make_call;
delimiter /

create procedure Fiscal_Deposit_Revenue_by_Make_call()
	begin
    
		-- *Creating table 'a' to extract fiscal cost of service *
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

		-- *Creating table c to extract fiscal sale revenue*
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
				sum(distinct ifnull(c.Deposit_Amount,0)) as Deposit_Revenue
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
		order by Deposit_Revenue desc;

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


/********************************************************************************************************************/
/******************************** Extracting Fiscal Deposit Revenue and Profit by Make ******************************/
/********************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Deposit_Revenue_by_Model_call;
delimiter /

create procedure Fiscal_Deposit_Revenue_by_Model_call()
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
				a.Model,
				sum(distinct ifnull(c.Deposit_Amount,0)) as Deposit_Revenue
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
		group by a.Make, a.Model
		order by Deposit_Revenue desc;

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


/***********************************************************************************************************************/
/*********************** Extracting fiscal garages service frequencies and price by Entity_Name ************************/
/***********************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Garages_service_freq_price_by_Entity_call;

delimiter /

create procedure Fiscal_Garages_service_freq_price_by_Entity_call()
	begin 

		drop temporary table if exists Fiscal_garages_service_freq_pri;
		create temporary table Fiscal_garages_service_freq_pri as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,                
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

				select Garage_type,
						Entity_Name,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Fiscal_garages_service_freq_pri
                where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)
                        
						group by Garage_type,Entity_Name
						order by Total_service_cost desc;

				drop temporary table if exists Fiscal_garages_service_freq_pri;
                
	end /
delimiter ;


/****************************************************************************************************************/
/*********************** Extracting fiscal garages service frequencies and price by Make ************************/
/****************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Garages_service_freq_price_by_Make_call;

delimiter /

create procedure Fiscal_Garages_service_freq_price_by_Make_call()
	begin 

		drop temporary table if exists Fiscal_garages_service_freq_pri;
		create temporary table Fiscal_garages_service_freq_pri as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,                
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

				select Garage_type,
						Entity_Name,
                        Make,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Fiscal_garages_service_freq_pri
                where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)
                        
						group by Garage_type,Entity_Name,Make
						order by Total_service_cost desc;

				drop temporary table if exists Fiscal_garages_service_freq_pri;
	end /
delimiter ;


/*****************************************************************************************************************/
/*********************** Extracting fiscal garages service frequencies and price by Model ************************/
/*****************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Garages_service_freq_price_by_Model_call;
delimiter /
create procedure Fiscal_Garages_service_freq_price_by_Model_call()
	begin 

		drop temporary table if exists Fiscal_garages_service_freq_pri;
		create temporary table Fiscal_garages_service_freq_pri as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,                
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

				select Garage_type,
						Entity_Name,
                        Make,
                        Model,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Fiscal_garages_service_freq_pri
                where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)
                        
						group by Garage_type,Entity_Name,Make,Model
						order by Total_service_cost desc;

				drop temporary table if exists Fiscal_garages_service_freq_pri;
	end /
delimiter ;


/********************************************************************************************************/
/*********************** Extracting fiscal garages service frequencies and price ************************/
/********************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Garages_service_freq_price_call;

delimiter /

create procedure Fiscal_Garages_service_freq_price_call()
	begin 

		drop temporary table if exists Fiscal_garages_service_freq_pri;
		create temporary table Fiscal_garages_service_freq_pri as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,                
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

				select Garage_type,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Fiscal_garages_service_freq_pri
                where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)
                        
						group by Garage_type
						order by Total_service_cost desc;

				drop temporary table if exists Fiscal_garages_service_freq_pri;
	end /
delimiter ;


/***********************************************************************************/
/*********************** Extracting fiscal garages services ************************/
/***********************************************************************************/

use icp;
drop procedure if exists Fiscal_Garages_type_service_call;

delimiter /

create procedure Fiscal_Garages_type_service_call()
	begin 

		drop temporary table if exists Fiscal_garages_service;
		create temporary table Fiscal_garages_service as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,                
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						case 
							when  concat(year(e.Serv_date),"/04/06") < e.Serv_date and e.Serv_date < concat(year(e.Serv_date) + 1,"/04/06") then  year(e.Serv_date)

							when e.Serv_date < concat(year(e.Serv_date),"/04/06") and e.Serv_date > concat(year(e.Serv_date) -1,"/04/06") then year(e.Serv_date) -1
							else year(e.Serv_date)
						end as financial_year,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

				select * from Fiscal_garages_service
				where financial_year  = (select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year);

				drop temporary table if exists Fiscal_garages_service;
	end /
delimiter ;

/*********************************************************************************************************/
/************************* Extracting Fiscal Vehicle viewing by City or village **************************/
/*********************************************************************************************************/

use icp;
drop procedure if exists Fiscall_City_or_village_Viewing_frequency_call;
delimiter /

create procedure Fiscall_City_or_village_Viewing_frequency_call()
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

			-- ***** Extracting Fiscal City_or_village Vehicle viewing frequency *****
			select City_or_village,
					count(V5C_id) as Fiscal_Viewing_frequency,
					sum(Deposit_Flag) as Deposit_frequency,
					sum(Sale_Flag) as Sale_frequency
			from Fiscal_Vehicle_viewing
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)	 
			 group by City_or_village
			 order by Fiscal_Viewing_frequency desc;
		
        drop temporary table if exists Fiscal_Vehicle_viewing;
	end /
delimiter ;

/*********************************************************************************************************/
/******************************** Extracting Fiscal Vehicle viewing by Make ******************************/
/*********************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Make_Viewing_frequency_call;
delimiter /

create procedure Fiscall_Make_Viewing_frequency_call()
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
						end as fin_year)	 
			 group by Make
			 order by Fiscal_Viewing_frequency desc;
			
		drop temporary table if exists Fiscal_Vehicle_viewing;
	end /
delimiter ;

/*********************************************************************************************************/
/********************* Extracting Fiscal Vehicle viewing by Make and deposit flag =1 *********************/
/*********************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Make_Viewing_frequency_Deposit_call;
delimiter /

create procedure Fiscall_Make_Viewing_frequency_Deposit_call()
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
						end as fin_year) and  Deposit_Flag = 1
			 group by Make
			 order by Fiscal_Viewing_frequency desc;
		
        drop temporary table if exists Fiscal_Vehicle_viewing;
        
	end /
delimiter ;


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


/******************************************************************************************************************/
/************************** Extracting Fiscal Vehicle viewing by Model deposit frequency **************************/
/******************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Model_Viewing_Deposit_frequency_call;
delimiter /

create procedure Fiscal_Model_Viewing_Deposit_frequency_call()
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

			-- ***** Extracting Fiscal Model Vehicle viewing frequency *****
			select Make,
					Model,
					count(V5C_id) as Fiscall_Viewing_frequency,
					sum(Deposit_Flag) as Deposit_frequency,
					sum(Sale_Flag) as Sale_frequency
			from Fiscal_Vehicle_viewing
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year) and Deposit_Flag = 1
			 group by Make, Model
			 order by Fiscall_Viewing_frequency desc;
             
		drop temporary table if exists Fiscal_Vehicle_viewing;
        
	end /
delimiter ;

/**********************************************************************************************************/
/******************************** Extracting Fiscal Vehicle viewing by Model ******************************/
/**********************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Model_Viewing_frequency_call;
delimiter /

create procedure Fiscal_Model_Viewing_frequency_call()
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

			-- ***** Extracting Fiscal Model Vehicle viewing frequency *****
			select Make,
					Model,
					count(V5C_id) as Fiscal_Viewing_frequency,
					sum(Deposit_Flag) as Deposit_frequency,
					sum(Sale_Flag) as Sale_frequency
			from Fiscal_Vehicle_viewing
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year)
			 group by Make, Model
			 order by Fiscal_Viewing_frequency desc;
             
		drop temporary table if exists Fiscal_Vehicle_viewing;
        
	end /
delimiter ;


/***************************************************************************************************************/
/************************** Extracting Fiscal Vehicle viewing by Model Sale frequency **************************/
/***************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Model_Viewing_Sale_frequency_call;
delimiter /

create procedure Fiscal_Model_Viewing_Sale_frequency_call()
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

			-- ***** Extracting Fiscal Model Vehicle viewing frequency *****
			select Make,
					Model,
					count(V5C_id) as Fiscall_Viewing_frequency,
					sum(Deposit_Flag) as Deposit_frequency,
					sum(Sale_Flag) as Sale_frequency
			from Fiscal_Vehicle_viewing
			 where financial_year  = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year) and Sale_Flag = 1
			 group by Make, Model
			 order by Fiscall_Viewing_frequency desc;
             
             -- Dropping the temporary table to clean up the database
             drop temporary table if exists Fiscal_Vehicle_viewing;
	end /
delimiter ;

/************************************************************************************************************/
/******************************** Extracting Fiscal Revenue and Profit by Make ******************************/
/************************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Revenue_and_Profit_by_Make_call;
delimiter /

create procedure Fiscall_Revenue_and_Profit_by_Make_call()
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
				count(distinct a.V5C_id) as Make_frequency,
				count(distinct b.Serv_Invoice_nbr) as Service_frequency,
				sum(distinct ifnull(b.Price,0)) as Service_Cost,
				sum(distinct ifnull(c.Deposit_Amount,0)) as Deposit_Revenue,
				sum(distinct ifnull(d.Sale_Amount,0)) as Sale_Revenue,
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

/*************************************************************************************************************/
/******************************** Extracting Fiscal Revenue and Profit by Model ******************************/
/*************************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Revenue_and_Profit_by_Model_call;
delimiter /

create procedure Fiscall_Revenue_and_Profit_by_Model_call()
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

					drop temporary table if exists Fiscal_a_b_c_Model;
					create temporary table Fiscal_a_b_c_Model as 
					select a.Make,
							a.Model,
							count(distinct a.V5C_id) as Model_frequency,
							count(distinct b.Serv_Invoice_nbr) as Service_frequency,
							sum(distinct ifnull(b.Price,0)) as Service_Cost,
							sum(distinct ifnull(c.Deposit_Amount,0)) as Deposit_Revenue,
							sum(distinct ifnull(d.Sale_Amount,0)) as Sale_Revenue,
							sum(distinct ifnull( d.Sale_Amount,0))+ sum(distinct ifnull(c.Deposit_Amount,0)) as Total_Revenue,
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
							
					group by a.Make, a.Model
					order by Total_Revenue desc;

					select * from Fiscal_a_b_c_Model;
		
		drop temporary table if exists a;
        drop temporary table if exists Fiscal_a;
        drop temporary table if exists b;
        drop temporary table if exists Fiscal_b;
        drop temporary table if exists c;
        drop temporary table if exists Fiscal_c;
        drop temporary table if exists Fiscal_a_b_c_Model;

	end /
delimiter ;

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

/*************************************************************************************************************/
/******************************** Extracting Fiscal Revenue and Profit by Model ******************************/
/*************************************************************************************************************/

use icp;
drop procedure if exists Fiscall_Total_Revenue_and_Profit_by_Model_call;
delimiter /

create procedure Fiscall_Total_Revenue_and_Profit_by_Model_call()
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
				a.Model,
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
		group by a.Make, a.Model
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

/*************************************************************************************************************/
/*Creating the current financial year monthly summary per auction */
/*************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_month_summary_data_by_auction_call;
delimiter /

create procedure Fiscal_month_summary_data_by_auction_call()
	begin
			
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
                year(b.Invoice_Date) as Invoice_Year,
                month(b.Invoice_Date) as Invoice_Month,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
                
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Monthly fiscal Summary VAT and expenditure overall****

		select  Auction_id,
				Entity_Name,
				Invoice_Year,
				Invoice_Month,
				sum(Auction_VAT) as VAT,
				sum(Total) as Expenditure
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
                when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)

		group by Auction_id,Entity_Name, Invoice_Year, Invoice_Month
		order by Expenditure desc;
        
        drop temporary table if exists fin_year;
	end /
delimiter ;

/*************************************************************************************************************/
/*Creating the current financial year monthly summary (overall not per auction)*/
/*************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_month_summary_data_call;
delimiter /

create procedure Fiscal_month_summary_data_call()
	begin
			
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
                year(b.Invoice_Date) as Invoice_Year,
                month(b.Invoice_Date) as Invoice_Month,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
                
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Monthly fiscal Summary VAT and expenditure overall****

		select  Invoice_Year,
				Invoice_Month,
				sum(Auction_VAT) as VAT,
				sum(Total) as Expenditure
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
                when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)

		group by Invoice_Year, Invoice_Month
		order by Expenditure desc;
        
		drop temporary table if exists fin_year;
	end /
delimiter ;


/*******************************************************************************************************/
/******************************* Obtain Fiscal Op Services by Make  ************************************/
/*******************************************************************************************************/
use icp;
drop procedure if exists Fiscal_Op_service_by_Make_call;
delimiter /

create procedure Fiscal_Op_service_by_Make_call()
	begin
		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		-- ****************************************************************************************************************
		-- ************************* Obtain Fiscal frequencies of Op_services by Make  ************************************
		-- ****************************************************************************************************************
        
		select Make,
				count(distinct Reg_numb) as Make_frequency,
				count(Serv_type) as Service_frequency,
				sum(Price) as Service_cost
		from Op_service_all
		where financial_year = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year_inv)
		group by Make
		order by Service_frequency desc;
        
		drop temporary table if exists Op_service_mechanic;
		drop temporary table if exists Op_service_Electrical;
		drop temporary table if exists Op_service_MOT;
        drop temporary table if exists Op_service_Carwash;
        drop temporary table if exists Op_service_all;
        
	end /
delimiter ;

/*******************************************************************************************************/
/******************************* Obtain Fiscal Op Services by Make  ************************************/
/*******************************************************************************************************/
use icp;
drop procedure if exists Fiscal_Op_service_by_Model_call;
delimiter /

create procedure Fiscal_Op_service_by_Model_call()
	begin
		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		-- ****************************************************************************************************************
		-- ************************* Obtain Fiscal frequencies of services by Make & Model  *******************************
		-- ****************************************************************************************************************
        
		select Make,
				Model,
				count(distinct Reg_numb) as Model_frequency,
				count(Serv_type) as Service_frequency,
				sum(Price) as Service_cost
		from Op_service_all
		where financial_year = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year_inv)
		group by Make, Model
		order by Service_frequency desc;
        
        drop temporary table if exists Op_service_mechanic;
        drop temporary table if exists Op_service_Electrical;
        drop temporary table if exists Op_service_MOT;
        drop temporary table if exists Op_service_Carwash;
        drop temporary table if exists Op_service_all;
	end /
delimiter ;


/***********************************************************************************************/
/******************************* Obtain Fiscal Op Services  ************************************/
/***********************************************************************************************/
use icp;
drop procedure if exists Fiscal_Op_service_call;
delimiter /

create procedure Fiscal_Op_service_call()
	begin
		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		-- **** Selecting Fiscal services ****
		select * from Op_service_all
		where financial_year = (select case 
						when month(curdate()) in (1,2,3) then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
						when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
						when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
						end as fin_year_inv);
		
		drop temporary table if exists Op_service_mechanic;
        drop temporary table if exists Op_service_Electrical;
        drop temporary table if exists Op_service_MOT;
        drop temporary table if exists Op_service_Carwash;
        drop temporary table if exists Op_service_all;
        
	end /
delimiter ;


/***********************************************************************************/
/************************** Extracting Fiscal Op VAT data **************************/
/***********************************************************************************/

use icp;
drop procedure if exists Fiscal_Op_VAT_stats_call1;
delimiter /

create procedure Fiscal_Op_VAT_stats_call1()
	begin
		drop temporary table if exists Fiscal_Op_VAT;
		create temporary table Fiscal_Op_VAT as 
		-- Extracting Mech_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Mech_Grg_id = d.Mech_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Mech_Grg_id is not null

		union

		-- Extracting Elect_mech_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Elect_mech_id = d.Elect_mech_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Elect_mech_id is not null

		union

		-- Extracting MOT_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.MOT_Grg_id = d.MOT_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.MOT_Grg_id is not null

		union

		-- Extracting Carwash_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Carwash_id = d.Carwash_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Carwash_id is not null

		union

		-- Join Op_VAT to Op_misc_Receipt
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				b.Venue,
				b.Item as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Receipt_date as Transaction_Date,
				b.Receipt_time as Transaction_Time,
				case
					when  concat(year(b.Receipt_date),"/04/06") < b.Receipt_date and b.Receipt_date < concat(year(b.Receipt_date) + 1,"/04/06") then  year(b.Receipt_date)
					when b.Receipt_date < concat(year(b.Receipt_date),"/04/06") and b.Receipt_date > concat(year(b.Receipt_date) -1,"/04/06") then year(b.Receipt_date) -1
					else year(b.Receipt_date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_misc_Receipt as b
			 on a.Op_misc_Receipt_id = b.Op_misc_Receipt_id
			 where a.Op_misc_Receipt_id is not null

		union

		-- Join Op_VAT to Auction_invoice
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				c.Entity_Name as Venue,
				concat(b.Make, " ",b.Model) as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Invoice_Date as Transaction_Date,
				"12:00:00" as Transaction_Time,
				case
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)
					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Auction_invoice as b
			 on a.Auct_Invoice_id = b.Auct_Invoice_id left join
			 icp.Entity as c
			 on b.Auction_id = c.Auction_id
			 where a.Auct_Invoice_id is not null and b.Auction_VAT is not null;
			 
		select Venue,
				Product_or_service,
                Net,
                VAT,
                Gross_Price,
                Transaction_Date,
                Transaction_Time,
                financial_year,
                Date_added
        from Fiscal_Op_VAT
		where financial_year = (select case 
								when month(curdate()) in (1,2,3) then year(curdate()) -1
								when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
								when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
								when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
								end as fin_year)
		order by Transaction_Date;
		drop temporary table if exists Fiscal_Op_VAT;

	end /
delimiter ;


/***********************************************************************************/
/************************** Extracting Fiscal Op VAT data **************************/
/***********************************************************************************/

use icp;
drop procedure if exists Fiscal_Op_VAT_stats_call;
delimiter /

create procedure Fiscal_Op_VAT_stats_call()
	begin
		drop temporary table if exists Fiscal_Op_VAT;
		create temporary table Fiscal_Op_VAT as 
		-- Extracting Mech_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Mech_Grg_id = d.Mech_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Mech_Grg_id is not null

		union

		-- Extracting Elect_mech_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Elect_mech_id = d.Elect_mech_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Elect_mech_id is not null

		union

		-- Extracting MOT_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.MOT_Grg_id = d.MOT_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.MOT_Grg_id is not null

		union

		-- Extracting Carwash_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Carwash_id = d.Carwash_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Carwash_id is not null

		union

		-- Join Op_VAT to Op_misc_Receipt
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				b.Venue,
				b.Item as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Receipt_date as Transaction_Date,
				b.Receipt_time as Transaction_Time,
				case
					when  concat(year(b.Receipt_date),"/04/06") < b.Receipt_date and b.Receipt_date < concat(year(b.Receipt_date) + 1,"/04/06") then  year(b.Receipt_date)
					when b.Receipt_date < concat(year(b.Receipt_date),"/04/06") and b.Receipt_date > concat(year(b.Receipt_date) -1,"/04/06") then year(b.Receipt_date) -1
					else year(b.Receipt_date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_misc_Receipt as b
			 on a.Op_misc_Receipt_id = b.Op_misc_Receipt_id
			 where a.Op_misc_Receipt_id is not null

		union

		-- Join Op_VAT to Auction_invoice
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				c.Entity_Name as Venue,
				concat(b.Make, " ",b.Model) as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Invoice_Date as Transaction_Date,
				"12:00:00" as Transaction_Time,
				case
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)
					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Auction_invoice as b
			 on a.Auct_Invoice_id = b.Auct_Invoice_id left join
			 icp.Entity as c
			 on b.Auction_id = c.Auction_id
			 where a.Auct_Invoice_id is not null and b.Auction_VAT is not null;
			 
		select * from Fiscal_Op_VAT
		where financial_year = (select case 
								when month(curdate()) in (1,2,3) then year(curdate()) -1
								when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
								when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
								when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
								end as fin_year)
		order by Transaction_Date;
		drop temporary table if exists Fiscal_Op_VAT;

	end /
delimiter ;


/*******************************************************************************************************************/
/************************** Extracting Fiscal Op VAT data for the previous financial year **************************/
/*******************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Op_VAT_stats_Previous_year_call1;
delimiter /

create procedure Fiscal_Op_VAT_stats_Previous_year_call1()
	begin
		drop temporary table if exists Fiscal_Op_VAT;
		create temporary table Fiscal_Op_VAT as 
		-- Extracting Mech_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Mech_Grg_id = d.Mech_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Mech_Grg_id is not null

		union

		-- Extracting Elect_mech_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Elect_mech_id = d.Elect_mech_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Elect_mech_id is not null

		union

		-- Extracting MOT_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.MOT_Grg_id = d.MOT_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.MOT_Grg_id is not null

		union

		-- Extracting Carwash_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Carwash_id = d.Carwash_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Carwash_id is not null

		union

		-- Join Op_VAT to Op_misc_Receipt
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				b.Venue,
				b.Item as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Receipt_date as Transaction_Date,
				b.Receipt_time as Transaction_Time,
				case
					when  concat(year(b.Receipt_date),"/04/06") < b.Receipt_date and b.Receipt_date < concat(year(b.Receipt_date) + 1,"/04/06") then  year(b.Receipt_date)
					when b.Receipt_date < concat(year(b.Receipt_date),"/04/06") and b.Receipt_date > concat(year(b.Receipt_date) -1,"/04/06") then year(b.Receipt_date) -1
					else year(b.Receipt_date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_misc_Receipt as b
			 on a.Op_misc_Receipt_id = b.Op_misc_Receipt_id
			 where a.Op_misc_Receipt_id is not null

		union

		-- Join Op_VAT to Auction_invoice
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				c.Entity_Name as Venue,
				concat(b.Make, " ",b.Model) as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Invoice_Date as Transaction_Date,
				"12:00:00" as Transaction_Time,
				case
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)
					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Auction_invoice as b
			 on a.Auct_Invoice_id = b.Auct_Invoice_id left join
			 icp.Entity as c
			 on b.Auction_id = c.Auction_id
			 where a.Auct_Invoice_id is not null and b.Auction_VAT is not null;
			 
		select  Venue,
                Product_or_service,
                Gross_Price,
                VAT_rate,
                VAT,
                Net,
                Transaction_Date,
                Transaction_Time,
                financial_year,
                Date_added
        from Fiscal_Op_VAT
		where financial_year = (select case 
								when month(Transaction_Date) in (1,2,3) and year(Transaction_Date)= (year(curdate())-1) then year(curdate()) -2
								when month(Transaction_Date) = 4 and day(Transaction_Date) < 6 and year(Transaction_Date)= (year(curdate())-1) then year(curdate()) -2
                                
								when month(Transaction_Date) = 4 and day(Transaction_Date) > 5 and year(Transaction_Date)= (year(curdate())-2) then year(curdate()) -2
								when month(Transaction_Date) in (5,6,7,8,9,10,11,12) and year(Transaction_Date)= (year(curdate())-2) then year(curdate()) -2
								end as fin_year)
		order by Transaction_Date;
		drop temporary table if exists Fiscal_Op_VAT;
        
	end /
delimiter ;

/*******************************************************************************************************************/
/************************** Extracting Fiscal Op VAT data for the previous financial year **************************/
/*******************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Op_VAT_stats_Previous_year_call;
delimiter /

create procedure Fiscal_Op_VAT_stats_Previous_year_call()
	begin
		drop temporary table if exists Fiscal_Op_VAT;
		create temporary table Fiscal_Op_VAT as 
		-- Extracting Mech_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Mech_Grg_id = d.Mech_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Mech_Grg_id is not null

		union

		-- Extracting Elect_mech_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Elect_mech_id = d.Elect_mech_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Elect_mech_id is not null

		union

		-- Extracting MOT_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.MOT_Grg_id = d.MOT_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.MOT_Grg_id is not null

		union

		-- Extracting Carwash_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Carwash_id = d.Carwash_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Carwash_id is not null

		union

		-- Join Op_VAT to Op_misc_Receipt
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				b.Venue,
				b.Item as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Receipt_date as Transaction_Date,
				b.Receipt_time as Transaction_Time,
				case
					when  concat(year(b.Receipt_date),"/04/06") < b.Receipt_date and b.Receipt_date < concat(year(b.Receipt_date) + 1,"/04/06") then  year(b.Receipt_date)
					when b.Receipt_date < concat(year(b.Receipt_date),"/04/06") and b.Receipt_date > concat(year(b.Receipt_date) -1,"/04/06") then year(b.Receipt_date) -1
					else year(b.Receipt_date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_misc_Receipt as b
			 on a.Op_misc_Receipt_id = b.Op_misc_Receipt_id
			 where a.Op_misc_Receipt_id is not null

		union

		-- Join Op_VAT to Auction_invoice
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				c.Entity_Name as Venue,
				concat(b.Make, " ",b.Model) as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Invoice_Date as Transaction_Date,
				"12:00:00" as Transaction_Time,
				case
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)
					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Auction_invoice as b
			 on a.Auct_Invoice_id = b.Auct_Invoice_id left join
			 icp.Entity as c
			 on b.Auction_id = c.Auction_id
			 where a.Auct_Invoice_id is not null and b.Auction_VAT is not null;
			 
		select Venue,
				Product_or_service,
                Net,
                VAT,
                Gross_Price,
                Transaction_Date,
                Transaction_Time,
                financial_year,
                Date_added
        from Fiscal_Op_VAT
		where financial_year = (select case 
								when month(Transaction_Date) in (1,2,3) and year(Transaction_Date)= (year(curdate())-1) then year(curdate()) -2
								when month(Transaction_Date) = 4 and day(Transaction_Date) < 6 and year(Transaction_Date)= (year(curdate())-1) then year(curdate()) -2
                                
								when month(Transaction_Date) = 4 and day(Transaction_Date) > 5 and year(Transaction_Date)= (year(curdate())-2) then year(curdate()) -2
								when month(Transaction_Date) in (5,6,7,8,9,10,11,12) and year(Transaction_Date)= (year(curdate())-2) then year(curdate()) -2
								end as fin_year)
		order by Transaction_Date;
		drop temporary table if exists Fiscal_Op_VAT;

	end /
delimiter ;


/*************************************************************************************/
/************************** Extracting Fiscal Op VAT Totals **************************/
/*************************************************************************************/

use icp;
drop procedure if exists Fiscal_Op_VAT_stats_total_call;
delimiter /

create procedure Fiscal_Op_VAT_stats_total_call()
	begin
		drop temporary table if exists Fiscal_Op_VAT;
		create temporary table Fiscal_Op_VAT as 
		-- Extracting Mech_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Mech_Grg_id = d.Mech_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Mech_Grg_id is not null

		union

		-- Extracting Elect_mech_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Elect_mech_id = d.Elect_mech_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Elect_mech_id is not null

		union

		-- Extracting MOT_Grg_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.MOT_Grg_id = d.MOT_Grg_id
			 where c.Trans_Date is not null and a.Net > 0 and b.MOT_Grg_id is not null

		union

		-- Extracting Carwash_id to obtain Venue from icp.Entity
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				d.Entity_Name as Venue,
				b.Serv_type as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				c.Trans_Date as Transaction_Date,
				c.Trans_time as Transaction_Time,
				case
					when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
					when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
					else year(c.Trans_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_service as b
			 on a.Op_service_id = b.Op_service_id
			 left join icp.Op_service_Receipt as c
			 on a.Op_service_id = c.Op_service_id left join
			 icp.Entity as d
			 on b.Carwash_id = d.Carwash_id
			 where c.Trans_Date is not null and a.Net > 0 and b.Carwash_id is not null

		union

		-- Join Op_VAT to Op_misc_Receipt
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				b.Venue,
				b.Item as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Receipt_date as Transaction_Date,
				b.Receipt_time as Transaction_Time,
				case
					when  concat(year(b.Receipt_date),"/04/06") < b.Receipt_date and b.Receipt_date < concat(year(b.Receipt_date) + 1,"/04/06") then  year(b.Receipt_date)
					when b.Receipt_date < concat(year(b.Receipt_date),"/04/06") and b.Receipt_date > concat(year(b.Receipt_date) -1,"/04/06") then year(b.Receipt_date) -1
					else year(b.Receipt_date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Op_misc_Receipt as b
			 on a.Op_misc_Receipt_id = b.Op_misc_Receipt_id
			 where a.Op_misc_Receipt_id is not null

		union

		-- Join Op_VAT to Auction_invoice
		select a.Op_VAT_id,
				a.Auct_Invoice_id,
				a.Op_service_id,
				a.Op_misc_Receipt_id,
				c.Entity_Name as Venue,
				concat(b.Make, " ",b.Model) as Product_or_service,
				a.Gross_Price,
				a.VAT_rate,
				a.VAT,
				a.Net,
				b.Invoice_Date as Transaction_Date,
				"12:00:00" as Transaction_Time,
				case
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)
					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
				end as financial_year,
				a.Date_added

		from icp.Op_VAT as a left join
			 icp.Auction_invoice as b
			 on a.Auct_Invoice_id = b.Auct_Invoice_id left join
			 icp.Entity as c
			 on b.Auction_id = c.Auction_id
			 where a.Auct_Invoice_id is not null and b.Auction_VAT is not null;
			 
		select sum(Net) as Total_Net,
        sum(VAT) as Total_VAT,
        sum(Gross_Price) as Total_Gross
				
        from Fiscal_Op_VAT
		where financial_year = (select case 
								when month(curdate()) in (1,2,3) then year(curdate()) -1
								when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
								when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
								when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
								end as fin_year);

		drop temporary table if exists Fiscal_Op_VAT;

	end /
delimiter ;

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

/******************************************************************************************************/
/************************** Extracting Fiscal Sale data by staff and Make **************************/
/******************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Sale_freq_amount_by_Make;
delimiter /

create procedure Fiscal_Sale_freq_amount_by_Make()
	begin

		drop temporary table if exists Fiscal_sale_staff;
		create temporary table Fiscal_sale_staff as
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

		select Staff_id,
				Staff,
                Make,
                count(Reg_Numb) as Fiscal_sale_frequency,
                format(sum(Sale_Amount),2) as Fiscal_sale_amount
        from Fiscal_sale_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year)
		group by Staff_id,Staff,Make
        order by Fiscal_sale_amount desc;

		drop temporary table if exists Fiscal_sale_staff;

	end /
delimiter ;

/******************************************************************************************************/
/************************** Extracting Fiscal sale data by staff and Model **************************/
/******************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Sale_freq_amount_by_Model;
delimiter /

create procedure Fiscal_Sale_freq_amount_by_Model()
	begin

		drop temporary table if exists Fiscal_sale_staff;
		create temporary table Fiscal_sale_staff as
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

		select Staff_id,
				Staff,
                Make,
                Model,
                count(Reg_Numb) as Fiscal_sale_frequency,
                format(sum(Sale_Amount),2) as Fiscal_sale_amount
        from Fiscal_sale_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year)
		group by Staff_id,Staff,Make,Model
        order by Fiscal_sale_amount desc;

		drop temporary table if exists Fiscal_sale_staff;

	end /
delimiter ;


/******************************************************************************************/
/************************** Extracting Fiscal Sale data by staff **************************/
/******************************************************************************************/

use icp;
drop procedure if exists Fiscal_Sale_freq_amount_by_Staff;
delimiter /

create procedure Fiscal_Sale_freq_amount_by_Staff()
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

		select Staff_id,
				Staff,
                count(Reg_Numb) as Fiscal_Sale_frequency,
                sum(Sale_Amount) as Fiscal_Sale_amount
        from Fiscal_Sale_staff
		where financial_year=(select case 
										when month(curdate()) in (1,2,3) then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
										when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
										when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
										end as fin_year)
		group by Staff_id,Staff
        order by Fiscal_Sale_amount desc;

		drop temporary table if exists Fiscal_Sale_staff;

	end /
delimiter ;


/************************************************************************************************************/
/********************************* Extracting Sale Revenue and Profit by Make *******************************/
/************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Sale_Revenue_by_Make_call;
delimiter /

create procedure Fiscal_Sale_Revenue_by_Make_call()
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
				sum(distinct ifnull(d.Sale_Amount,0)) as Sale_Revenue
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
		order by Sale_Revenue desc;

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


/*************************************************************************************************************/
/********************************* Extracting Sale Revenue and Profit by Model *******************************/
/*************************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Sale_Revenue_by_Model_call;
delimiter /

create procedure Fiscal_Sale_Revenue_by_Model_call()
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
        a.Model,
				sum(distinct ifnull(d.Sale_Amount,0)) as Sale_Revenue
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
		group by a.Make, a.Model
		order by Sale_Revenue desc;

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


/*************************************************************************************************/
/******************************** Extracting Fiscal Vehicle viewing ******************************/
/*************************************************************************************************/

use icp;
drop procedure if exists Fiscal_Vehicle_viewing_call;
delimiter /

create procedure Fiscal_Vehicle_viewing_call()
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

		 -- *Extracting Fiscal Vehicle viewing*
		select * 
		from Fiscal_Vehicle_viewing
		 where financial_year  = (select case 
					when month(curdate()) in (1,2,3) then year(curdate()) -1
					when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
					when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
					when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
					end as fin_year);
                    
		drop temporary table if exists Fiscal_Vehicle_viewing;
	end /
delimiter ;

/*Creating the current financial year all data (raw)*/

use icp;
drop procedure if exists Fiscal_year_raw_data_call;
delimiter /

create procedure Fiscal_year_raw_data_call()
	begin
			
		drop temporary table if exists fin_year;
		create temporary table fin_year as 
		select a.Auction_id,
				a.Entity_Name,
				b.Invoice_nbr,
				b.Invoice_Date,
				b.Reg_nbr,
				b.Make,
				b.Model,
				b.Date_first_Reg,
				b.MOT_Expiry_date,
				b.Mileage,
				b.Cash_Payment,
				b.Price,
				b.Buyers_Fee,
				b.Assurance_Fee,
				b.Other_Fee,
				b.Storage_Fee,
				b.Cash_Handling_fee,
				b.Auction_VAT,
				b.Total,
				case 
					when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)

					when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
					else year(b.Invoice_Date)
					end as financial_year

		from icp.Entity a
		left join icp.Auction_invoice b
		on a.Auction_id = b.Auction_id
		where b.Auction_id is not null;

		-- **** Retrieving all data for current financial year ****

		select *
		from fin_year
		where financial_year = 
		(select case 
				when month(curdate()) in (1,2,3) then year(curdate()) -1
				when month(curdate()) = 4 and day(curdate()) < 6 then year(curdate()) -1
                when month(curdate()) = 4 and day(curdate()) > 5 then year(curdate())
				when month(curdate()) in (5,6,7,8,9,10,11,12) then year(curdate())
				end as fin_year)
		order by Auction_id, Entity_Name;
        
        drop temporary table if exists fin_year;
	end /
delimiter ;


use icp;
drop procedure if exists Garages_Contact_details_call;

delimiter /

create procedure Garages_Contact_details_call()
	begin 
		-- Mechanic garage
		select 	"Mechanic" as Garage_type,
				b.Entity_Name,
				b.VAT_Registration_Number,
				c.Fname,
				c.Mname,
				c.Lname,
				d.Address1,
				d.Address2,
				d.Address3,
				d.Address4,
				d.Address5,
				d.Address6,
				d.email,
				d.Tel

		from icp.Mechanic as a left join
			 icp.Entity as b
			 on a.Mech_Grg_id = b.Mech_Grg_id
			 
			 left join icp.Names as c
			 on b.Mech_Grg_id = c.Mech_Grg_id
			 
			 left join icp.Contact_details as d
			 on c.Mech_Grg_id = d.Mech_Grg_id

		where b.Entity_Name is not null

		union

		-- Electrical garage
		select "Electrical" as Garage_type,
				b.Entity_Name,
				b.VAT_Registration_Number,
				c.Fname,
				c.Mname,
				c.Lname,
				d.Address1,
				d.Address2,
				d.Address3,
				d.Address4,
				d.Address5,
				d.Address6,
				d.email,
				d.Tel

		from icp.Electrical as a left join
			 icp.Entity as b
			 on a.Elect_mech_id = b.Elect_mech_id
			 
			 left join icp.Names as c
			 on b.Elect_mech_id = c.Elect_mech_id
			 
			 left join icp.Contact_details as d
			 on c.Elect_mech_id = d.Elect_mech_id

		where b.Entity_Name is not null

		union

		-- MOT garage
		select "MOT" as Garage_type,
				b.Entity_Name,
				b.VAT_Registration_Number,
				c.Fname,
				c.Mname,
				c.Lname,
				d.Address1,
				d.Address2,
				d.Address3,
				d.Address4,
				d.Address5,
				d.Address6,
				d.email,
				d.Tel
				
		from icp.MOT_Garage as a left join
			 icp.Entity as b
			 on a.MOT_Grg_id = b.MOT_Grg_id
			 
			 left join icp.Names as c
			 on b.MOT_Grg_id = c.MOT_Grg_id
			 
			 left join icp.Contact_details as d
			 on c.MOT_Grg_id = d.MOT_Grg_id

		where b.Entity_Name is not null

		union

		-- Carwash garage
		select "Carwash" as Garage_type,
				b.Entity_Name,
				b.VAT_Registration_Number,
				c.Fname,
				c.Mname,
				c.Lname,
				d.Address1,
				d.Address2,
				d.Address3,
				d.Address4,
				d.Address5,
				d.Address6,
				d.email,
				d.Tel
				
		from icp.Carwash as a left join
			 icp.Entity as b
			 on a.Carwash_id = b.Carwash_id
			 
			 left join icp.Names as c
			 on b.Carwash_id = c.Carwash_id
			 
			 left join icp.Contact_details as d
			 on c.Carwash_id = d.Carwash_id
			 
		where b.Entity_Name is not null;

end /
delimiter ;


/********************************************************************************************************************************/
/*********************** Extracting garages service history frequencies and sums by Entity name and Make ************************/
/********************************************************************************************************************************/

use icp;
drop procedure if exists Garages_freq_and_sum_by_Entity_Name_and_Make_call;

delimiter /

create procedure Garages_freq_and_sum_by_Entity_Name_and_Make_call()
	begin 

		drop temporary table if exists Garages_service_history_freq_by_Entity_name;
		create temporary table Garages_service_history_freq_by_Entity_name as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

                
				select Garage_type,
						Entity_Name,
                        Make,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Garages_service_history_freq_by_Entity_name
				group by Garage_type,Entity_Name,Make
				order by Total_service_cost desc;

				drop temporary table if exists Garages_service_history_freq_by_Entity_name;
	end /
delimiter ;


/*********************************************************************************************************************************/
/*********************** Extracting garages service history frequencies and sums by Entity name and Model ************************/
/*********************************************************************************************************************************/

use icp;
drop procedure if exists Garages_freq_and_sum_by_Entity_Name_and_Model_call;

delimiter /

create procedure Garages_freq_and_sum_by_Entity_Name_and_Model_call()
	begin 

		drop temporary table if exists Garages_service_history_freq_by_Entity_name;
		create temporary table Garages_service_history_freq_by_Entity_name as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

                
				select Garage_type,
						Entity_Name,
                        Make,
                        Model,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Garages_service_history_freq_by_Entity_name
				group by Garage_type,Entity_Name,Make,Model
				order by Total_service_cost desc;

				drop temporary table if exists Garages_service_history_freq_by_Entity_name;
	end /
delimiter ;


/************************************************************************************/
/*********************** Extracting garages service history  ************************/
/************************************************************************************/

use icp;
drop procedure if exists Garages_Service_history_call;

delimiter /

create procedure Garages_Service_history_call()
	begin 
		-- Mechanic garage
		select 	"Mechanic" as Garage_type,
				b.Entity_Name,
				e.V5C_id,
				f.Make,
				f.Model,
				f.Reg_numb,
				e.Serv_date,
				e.Serv_type,
				e.Description,
				e.Serv_return_date,
				e.Service_quality_check_done,
				e.Service_quality_description,
				e.Serv_Invoice_nbr,
				e.Serv_Invoice_Date,
				e.Serv_Invoice_Description,
				e.Price
				
		from icp.Mechanic as a left join
			 icp.Entity as b
			 on a.Mech_Grg_id = b.Mech_Grg_id
			 
			 left join icp.Op_service as e
			 on a.Mech_Grg_id = e.Mech_Grg_id

			 left join icp.V5C as f
			 on e.V5C_id = f.V5C_id

		where b.Entity_Name is not null

		union

		-- Electrical garage
		select "Electrical" as Garage_type,
				b.Entity_Name,
				e.V5C_id,
				f.Make,
				f.Model,
				f.Reg_numb,
				e.Serv_date,
				e.Serv_type,
				e.Description,
				e.Serv_return_date,
				e.Service_quality_check_done,
				e.Service_quality_description,
				e.Serv_Invoice_nbr,
				e.Serv_Invoice_Date,
				e.Serv_Invoice_Description,
				e.Price
				
		from icp.Electrical as a left join
			 icp.Entity as b
			 on a.Elect_mech_id = b.Elect_mech_id
			 
			 left join icp.Op_service as e
			 on a.Elect_mech_id = e.Elect_mech_id
			 
			 left join icp.V5C as f
			 on e.V5C_id = f.V5C_id
		where b.Entity_Name is not null

		union

		-- MOT garage
		select "MOT" as Garage_type,
				b.Entity_Name,
				e.V5C_id,
				f.Make,
				f.Model,
				f.Reg_numb,
				e.Serv_date,
				e.Serv_type,
				e.Description,
				e.Serv_return_date,
				e.Service_quality_check_done,
				e.Service_quality_description,
				e.Serv_Invoice_nbr,
				e.Serv_Invoice_Date,
				e.Serv_Invoice_Description,
				e.Price
				
		from icp.MOT_Garage as a left join
			 icp.Entity as b
			 on a.MOT_Grg_id = b.MOT_Grg_id
			
			 left join icp.Op_service as e
			 on a.MOT_Grg_id = e.MOT_Grg_id
			 
			 left join icp.V5C as f
			 on e.V5C_id = f.V5C_id
			 
		where b.Entity_Name is not null

		union

		-- Carwash garage
		select "Carwash" as Garage_type,
				b.Entity_Name,
				e.V5C_id,
				f.Make,
				f.Model,
				f.Reg_numb,
				e.Serv_date,
				e.Serv_type,
				e.Description,
				e.Serv_return_date,
				e.Service_quality_check_done,
				e.Service_quality_description,
				e.Serv_Invoice_nbr,
				e.Serv_Invoice_Date,
				e.Serv_Invoice_Description,
				e.Price
				
		from icp.Carwash as a left join
			 icp.Entity as b
			 on a.Carwash_id = b.Carwash_id
			 
			 left join icp.Op_service as e
			 on a.Carwash_id = e.Carwash_id
			 
			 left join icp.V5C as f
			 on e.V5C_id = f.V5C_id
			 
		where b.Entity_Name is not null;
end /
delimiter ;

/***********************************************************************************************************************/
/*********************** Extracting garages service history frequencies and sums by Entity name ************************/
/***********************************************************************************************************************/

use icp;
drop procedure if exists Garages_Service_history_freq_and_sum_by_Entity_Name_call;

delimiter /

create procedure Garages_Service_history_freq_and_sum_by_Entity_Name_call()
	begin 

		drop temporary table if exists Garages_service_history_freq_by_Entity_name;
		create temporary table Garages_service_history_freq_by_Entity_name as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

                
				select Garage_type,
						Entity_Name,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Garages_service_history_freq_by_Entity_name
				group by Garage_type,Entity_Name
				order by Total_service_cost desc;

				drop temporary table if exists Garages_service_history_freq_by_Entity_name;
	end /
delimiter ;


/********************************************************************************************************/
/*********************** Extracting garages service history frequencies and sum  ************************/
/********************************************************************************************************/

use icp;
drop procedure if exists Garages_Service_history_freq_and_sum_call;

delimiter /

create procedure Garages_Service_history_freq_and_sum_call()
	begin 

		drop temporary table if exists Garages_service_history_freq;
		create temporary table Garages_service_history_freq as 
				-- Mechanic garage
				select 	"Mechanic" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Mechanic as a left join
					 icp.Entity as b
					 on a.Mech_Grg_id = b.Mech_Grg_id
					 
					 left join icp.Op_service as e
					 on a.Mech_Grg_id = e.Mech_Grg_id

					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id

				where b.Entity_Name is not null

				union

				-- Electrical garage
				select "Electrical" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Electrical as a left join
					 icp.Entity as b
					 on a.Elect_mech_id = b.Elect_mech_id
					 
					 left join icp.Op_service as e
					 on a.Elect_mech_id = e.Elect_mech_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
				where b.Entity_Name is not null

				union

				-- MOT garage
				select "MOT" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.MOT_Garage as a left join
					 icp.Entity as b
					 on a.MOT_Grg_id = b.MOT_Grg_id
					
					 left join icp.Op_service as e
					 on a.MOT_Grg_id = e.MOT_Grg_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null

				union

				-- Carwash garage
				select "Carwash" as Garage_type,
						b.Entity_Name,
						e.V5C_id,
						f.Make,
						f.Model,
						f.Reg_numb,
						e.Serv_date,
						e.Serv_type,
						e.Description,
						e.Serv_return_date,
						e.Service_quality_check_done,
						e.Service_quality_description,
						e.Serv_Invoice_nbr,
						e.Serv_Invoice_Date,
						e.Serv_Invoice_Description,
						e.Price
						
				from icp.Carwash as a left join
					 icp.Entity as b
					 on a.Carwash_id = b.Carwash_id
					 
					 left join icp.Op_service as e
					 on a.Carwash_id = e.Carwash_id
					 
					 left join icp.V5C as f
					 on e.V5C_id = f.V5C_id
					 
				where b.Entity_Name is not null;

				select Garage_type,
						count(V5C_id) as Service_frequency,
						sum(ifnull(Price,0)) as Total_service_cost
				from Garages_service_history_freq
				group by Garage_type
				order by Service_frequency desc;

				drop temporary table if exists Garages_service_history_freq;
	end /
delimiter ;

/********************************************************************************************************/
					/*3: Invoice update procedure*/
					/* Update the table when the invoice for the vehicles has been sent
                       Update the Serv_Invoice_Description to the service supplied on the invoice */
/********************************************************************************************************/

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


/********************************************************************************************************/
					/*Mileage History procedure*/
/********************************************************************************************************/

drop procedure if exists icp_Mileage_History_call;
delimiter /
create procedure icp_Mileage_History_call()
	begin
		insert into icp.Mileage_History(V5C_id,Vehicle_Reg_MOT_Date,Source,Mileage,Date)
		Values(@V5C_id,@Vehicle_Reg_MOT_Date,@Source,@Mileage,@Date);
	end /
delimiter ;

/********************************************************************************************************/
					/*icp MOT History procedure*/
/********************************************************************************************************/
use icp;
drop procedure if exists icp_MOT_History_call;
delimiter /
create procedure  icp_MOT_History_call ()
Begin
		Insert into icp.MOT_History(V5C_ID,Vehicle_Reg_MOT_Date,Test_Org,Test_Addr,
				Test_Date,Expiry_date,Advisory1,Advisory2,Advisory3,Advisory4,Advisory5,
				MOT_tst_Cert_Nbr,Price)
		values(@V5C_ID,@Vehicle_Reg_MOT_Date,@Test_Org,@Test_Addr,
				@Test_Date, @Expiry_date,@Advisory1,@Advisory2,
				@Advisory3,@Advisory4,@Advisory5,@MOT_tst_Cert_Nbr,@Price);
end /
delimiter ;

/********************************************************************************************************/
					/*MOT Refusal procedure*/
/********************************************************************************************************/

use icp;
drop procedure if exists icp_MOT_Refusal_call;
delimiter /
create procedure icp_MOT_Refusal_call()
	begin    
		insert into icp.MOT_Refusal(V5C_id,Vehicle_Reg_MOT_Date,Test_comp,Test_Addr,
			Test_Date,Ref_Reason1,Ref_Reason2,Ref_Reason3,Ref_Reason4,Ref_Reason5)
		VALUES(@V5C_ID,@Vehicle_Reg_MOT_Date,@Test_comp,@Test_Addr,@Test_Date,
			@Ref_Reason1,@Ref_Reason2,@Ref_Reason3,@Ref_Reason4,@Ref_Reason5);
	end /
delimiter ;

/********************************************************************************************************/
				/*Creating the Op_bank_transfer procedure*/
/********************************************************************************************************/

use icp;
drop procedure if exists Op_bank_transfer_call;
delimiter /

create procedure Op_bank_transfer_call()
	begin
		insert into  icp.Op_bank_transfer(Op_service_id,Split_payment,Transfer_amount,Transfer_date)
		values(@Op_service_id,@Split_payment,@Transfer_amount,@Transfer_date);
	end /
delimiter ;

/********************************************************************************************************/
				/*Creating procedure for icp.Op_call_Log*/
/********************************************************************************************************/

use icp;

drop procedure if exists Op_call_Log_call;
delimiter /
create procedure Op_call_Log_call()
	begin
		insert into icp.Op_call_Log(Name,Customer_sex,Tel,City_or_village,Vehicle_of_interest,V5C_id,Date_of_call,Time_of_Call,Deposit_flag)
		values(@Name,@Customer_sex,@Tel,@City_or_village,@Vehicle_of_interest,@V5C_id,@Date_of_call,@Time_of_Call,@Deposit_flag);
    end /
delimiter ;

/********************************************************************************************************/
				/* Creating the Op_misc_Receipt procedure */
/********************************************************************************************************/
use icp;

drop procedure if exists Op_misc_receipt_Call;
delimiter /
create procedure Op_misc_receipt_Call()
	begin
		insert into icp.Op_misc_Receipt(Venue,Vat_registration,Item,Price,Quantity,Total,Auth_Code,Receipt_nbr,Receipt_date,Receipt_time)
		Values(@Venue,@Vat_registration,@Item,@Price,@Quantity,@Total,@Auth_Code,@Receipt_nbr,@Receipt_date,@Receipt_time);
	end /
delimiter ;


/***********************************************************************************************/
/************************* Obtain frequencies of services by Make ******************************/
/***********************************************************************************************/
use icp;
drop procedure if exists Op_service_by_Make_call;
delimiter /

create procedure Op_service_by_Make_call()
	begin

		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		select Make,
				count(distinct Reg_numb) as Make_frequency,
				count(Serv_type) as Service_frequency,
				sum(Price) as Service_cost
		from Op_service_all
		group by Make
		order by Service_frequency desc;

	end /
delimiter ;


/***********************************************************************************************/
/************************* Obtain frequencies of services by Model *****************************/
/***********************************************************************************************/
use icp;
drop procedure if exists Op_service_by_Model_call;
delimiter /

create procedure Op_service_by_Model_call()
	begin
		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		-- *** Obtain frequencies of services by Make & Model ***
		select Make,
				Model,
				count(distinct Reg_numb) as Model_frequency,
				count(Serv_type) as Service_frequency,
				sum(Price) as Service_cost
		from Op_service_all
		group by Make, Model
		order by Service_frequency desc;

	end /
delimiter ;


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

/***********************************************************************************************/
		/*Creating the procedure for Operation Service Receipt*/
/***********************************************************************************************/
use icp;
drop procedure if exists Op_service_receipt_call;
delimiter /
create procedure Op_service_receipt_call()
	begin
		insert into icp.Op_service_Receipt(Op_service_id,Split_payment,Trans_Date,Trans_time,Auth_code,Receipt_nbr,Amount)
		values(@Op_service_id,@Split_payment,@Trans_Date,@Trans_time,@Auth_code,@Receipt_nbr,@Amount);
	end /
delimiter ;

/*************************************************************************************/
/************************* Obtain services cost by Make ******************************/
/*************************************************************************************/
use icp;
drop procedure if exists Op_service_service_cost_by_Make_call;
delimiter /

create procedure Op_service_service_cost_by_Make_call()
	begin
		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		select Make,
				count(distinct Reg_numb) as Make_frequency,
				count(Serv_type) as Service_frequency,
				sum(Price) as Service_cost
		from Op_service_all
		group by Make
		order by Service_cost desc;
	end /
delimiter ;


/**************************************************************************************************************/
/***************************** Service all: mechanic, electrical, MOT, Carwash ********************************/
/**************************************************************************************************************/
use icp;
drop procedure if exists Op_service_Stats_call;
delimiter /

create procedure Op_service_Stats_call()
	begin

		-- ***** Extracting mechanic service *****
		drop temporary table if exists Op_service_mechanic;
		create temporary table Op_service_mechanic as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
					end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Mech_Grg_id = c.Mech_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Electrical mechanic service****/
		drop temporary table if exists Op_service_Electrical;
		create temporary table Op_service_Electrical as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Elect_mech_id = c.Elect_mech_id
		where c.Entity_Name is not null;

		-- **** Extracting MOT service****/
		drop temporary table if exists Op_service_MOT;
		create temporary table Op_service_MOT as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.MOT_Grg_id = c.MOT_Grg_id
		where c.Entity_Name is not null;

		-- **** Extracting Carwash service ****/
		drop temporary table if exists Op_service_Carwash;
		create temporary table Op_service_Carwash as
		select	b.Op_service_id,
				a.Make, 
				a.Model, 
				a.Reg_numb,
				c.Entity_Name,
				b.Serv_date,
				b.Serv_Invoice_nbr,
				b.Serv_Invoice_Date,
				case 
					when  concat(year(b.Serv_Invoice_Date),"/04/06") < b.Serv_Invoice_Date and b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date) + 1,"/04/06") then  year(b.Serv_Invoice_Date)

					when b.Serv_Invoice_Date < concat(year(b.Serv_Invoice_Date),"/04/06") and b.Serv_Invoice_Date > concat(year(b.Serv_Invoice_Date) -1,"/04/06") then year(b.Serv_Invoice_Date) -1
					else year(b.Serv_Invoice_Date)
				end as financial_year,
				
				b.Serv_type,
				b.Description,
				b.Price,
				b.Serv_return_date,
				b.Service_quality_check_done,
				b.Service_quality_description,
				b.Date_added
		from icp.V5C as a left join
		icp.Op_service as b
		on a.V5C_id = b.V5C_id
		left join
		icp.Entity as c
		on b.Carwash_id = c.Carwash_id
		where c.Entity_Name is not null;

		-- **** merge stacking op_service using union ****/
		drop temporary table if exists Op_service_all;
		create temporary table Op_service_all as
		select *
		from Op_service_mechanic
		union
		select *
		from Op_service_Electrical
		union
		select *
		from Op_service_MOT
		union
		select *
		from Op_service_Carwash;

		select * from Op_service_all;

	end /
delimiter ;


/****************************************************************************/
/************************** Extracting Op VAT data **************************/
/****************************************************************************/

use icp;
drop procedure if exists Op_VAT_stats_call;
delimiter /

create procedure Op_VAT_stats_call()
	begin

-- creating a master Op_VAT table with the product or service, Date and time included
-- Extracting Mech_Grg_id to obtain Venue from icp.Entity
select a.Op_VAT_id,
		a.Auct_Invoice_id,
        a.Op_service_id,
        a.Op_misc_Receipt_id,
        d.Entity_Name as Venue,
        b.Serv_type as Product_or_service,
        a.Gross_Price,
        a.VAT_rate,
        a.VAT,
        a.Net,
        c.Trans_Date as Transaction_Date,
        c.Trans_time as Transaction_Time,
		case
			when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
			when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
			else year(c.Trans_Date)
		end as financial_year,
        a.Date_added

from icp.Op_VAT as a left join
	 icp.Op_service as b
     on a.Op_service_id = b.Op_service_id
     left join icp.Op_service_Receipt as c
     on a.Op_service_id = c.Op_service_id left join
     icp.Entity as d
     on b.Mech_Grg_id = d.Mech_Grg_id
     where c.Trans_Date is not null and a.Net > 0 and b.Mech_Grg_id is not null

union

-- Extracting Elect_mech_id to obtain Venue from icp.Entity
select a.Op_VAT_id,
		a.Auct_Invoice_id,
        a.Op_service_id,
        a.Op_misc_Receipt_id,
        d.Entity_Name as Venue,
        b.Serv_type as Product_or_service,
        a.Gross_Price,
        a.VAT_rate,
        a.VAT,
        a.Net,
        c.Trans_Date as Transaction_Date,
        c.Trans_time as Transaction_Time,
		case
			when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
			when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
			else year(c.Trans_Date)
		end as financial_year,
        a.Date_added

from icp.Op_VAT as a left join
	 icp.Op_service as b
     on a.Op_service_id = b.Op_service_id
     left join icp.Op_service_Receipt as c
     on a.Op_service_id = c.Op_service_id left join
     icp.Entity as d
     on b.Elect_mech_id = d.Elect_mech_id
     where c.Trans_Date is not null and a.Net > 0 and b.Elect_mech_id is not null

union

-- Extracting MOT_Grg_id to obtain Venue from icp.Entity
select a.Op_VAT_id,
		a.Auct_Invoice_id,
        a.Op_service_id,
        a.Op_misc_Receipt_id,
        d.Entity_Name as Venue,
        b.Serv_type as Product_or_service,
        a.Gross_Price,
        a.VAT_rate,
        a.VAT,
        a.Net,
        c.Trans_Date as Transaction_Date,
        c.Trans_time as Transaction_Time,
		case
			when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
			when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
			else year(c.Trans_Date)
		end as financial_year,
        a.Date_added

from icp.Op_VAT as a left join
	 icp.Op_service as b
     on a.Op_service_id = b.Op_service_id
     left join icp.Op_service_Receipt as c
     on a.Op_service_id = c.Op_service_id left join
     icp.Entity as d
     on b.MOT_Grg_id = d.MOT_Grg_id
     where c.Trans_Date is not null and a.Net > 0 and b.MOT_Grg_id is not null

union

-- Extracting Carwash_id to obtain Venue from icp.Entity
select a.Op_VAT_id,
		a.Auct_Invoice_id,
        a.Op_service_id,
        a.Op_misc_Receipt_id,
        d.Entity_Name as Venue,
        b.Serv_type as Product_or_service,
        a.Gross_Price,
        a.VAT_rate,
        a.VAT,
        a.Net,
        c.Trans_Date as Transaction_Date,
        c.Trans_time as Transaction_Time,
		case
			when  concat(year(c.Trans_Date),"/04/06") < c.Trans_Date and c.Trans_Date < concat(year(c.Trans_Date) + 1,"/04/06") then  year(c.Trans_Date)
			when c.Trans_Date < concat(year(c.Trans_Date),"/04/06") and c.Trans_Date > concat(year(c.Trans_Date) -1,"/04/06") then year(c.Trans_Date) -1
			else year(c.Trans_Date)
		end as financial_year,
        a.Date_added

from icp.Op_VAT as a left join
	 icp.Op_service as b
     on a.Op_service_id = b.Op_service_id
     left join icp.Op_service_Receipt as c
     on a.Op_service_id = c.Op_service_id left join
     icp.Entity as d
     on b.Carwash_id = d.Carwash_id
     where c.Trans_Date is not null and a.Net > 0 and b.Carwash_id is not null

union

-- Join Op_VAT to Op_misc_Receipt
select a.Op_VAT_id,
		a.Auct_Invoice_id,
        a.Op_service_id,
        a.Op_misc_Receipt_id,
        b.Venue,
        b.Item as Product_or_service,
        a.Gross_Price,
        a.VAT_rate,
        a.VAT,
        a.Net,
        b.Receipt_date as Transaction_Date,
        b.Receipt_time as Transaction_Time,
		case
			when  concat(year(b.Receipt_date),"/04/06") < b.Receipt_date and b.Receipt_date < concat(year(b.Receipt_date) + 1,"/04/06") then  year(b.Receipt_date)
			when b.Receipt_date < concat(year(b.Receipt_date),"/04/06") and b.Receipt_date > concat(year(b.Receipt_date) -1,"/04/06") then year(b.Receipt_date) -1
			else year(b.Receipt_date)
		end as financial_year,
        a.Date_added

from icp.Op_VAT as a left join
	 icp.Op_misc_Receipt as b
     on a.Op_misc_Receipt_id = b.Op_misc_Receipt_id
     where a.Op_misc_Receipt_id is not null

union

-- Join Op_VAT to Auction_invoice
select a.Op_VAT_id,
		a.Auct_Invoice_id,
        a.Op_service_id,
        a.Op_misc_Receipt_id,
        c.Entity_Name as Venue,
        concat(b.Make, " ",b.Model) as Product_or_service,
        a.Gross_Price,
        a.VAT_rate,
        a.VAT,
        a.Net,
        b.Invoice_Date as Transaction_Date,
        "12:00:00" as Transaction_Time,
		case
			when  concat(year(b.Invoice_Date),"/04/06") < b.Invoice_Date and b.Invoice_Date < concat(year(b.Invoice_Date) + 1,"/04/06") then  year(b.Invoice_Date)
			when b.Invoice_Date < concat(year(b.Invoice_Date),"/04/06") and b.Invoice_Date > concat(year(b.Invoice_Date) -1,"/04/06") then year(b.Invoice_Date) -1
			else year(b.Invoice_Date)
		end as financial_year,
        a.Date_added

from icp.Op_VAT as a left join
	 icp.Auction_invoice as b
     on a.Auct_Invoice_id = b.Auct_Invoice_id left join
     icp.Entity as c
     on b.Auction_id = c.Auction_id
     where a.Auct_Invoice_id is not null and b.Auction_VAT is not null;
	end /
delimiter ;


/****************************************************************************************/
/*Creating procedure for icp.Op_vehicle_viewing*/
/****************************************************************************************/

drop procedure if exists Op_vehicle_viewing_call;
delimiter /
create procedure Op_vehicle_viewing_call()
	begin
		insert into icp.Op_vehicle_viewing(Vehicle_of_interest,V5C_id,Nbr_Vehicles_viewed,Customer_Age_Bracket,Customer_sex,
									City_or_village,Viewing_date,Viewing_time,Deposit_Flag,Sale_Flag)
		values(@Vehicle_of_interest,@V5C_id,@Nbr_Vehicles_viewed,@Customer_Age_Bracket,@Customer_sex,
									@City_or_village,@Viewing_date,@Viewing_time,@Deposit_Flag,@Sale_Flag);
    end /
delimiter ;

/****************************************************************************************/
/*******************************icp Service history call ********************************/
/****************************************************************************************/

use icp;
drop procedure if exists icp_service_history_call;
delimiter /
create procedure icp_service_history_call()
	begin
		insert into icp.Service_History(V5C_id,Vehicle_Reg_serv_Date,Serv_comp,
		Serv_Addr,Serv_Date,Serv_Parts_desc,Quantity,Unit_price,Sum_per_Parts,
		Total_Labour,Total_Parts,MOT_Fee,VAT,Grand_Total)
		values(@V5C_id,@Vehicle_Reg_serv_Date,@Serv_comp,@Serv_Addr,@Serv_Date,
		@Serv_Parts_desc, @Quantity, @Unit_price, @Sum_per_Parts, @Total_Labour,
		@Total_Parts,@MOT_Fee,@VAT,@Grand_Total);
    end /
delimiter ;

/****************************************************************************************/
/********************************** icp Staff insert ************************************/
/****************************************************************************************/
use icp;

/*Creating procedure for Staff insert*/
drop procedure if exists Staff_Insert_call;
delimiter /
create procedure Staff_Insert_call()
begin
	insert into icp.Staff(Passwd,Iv)
    values(@Passwd ,@random_bytes);
end /
delimiter ;

/****************************************************************************************/
				/*icp V5C procedure*/
/****************************************************************************************/
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


/****************************************************************************************/
				/*icp V5C update procedure*/
/****************************************************************************************/

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


