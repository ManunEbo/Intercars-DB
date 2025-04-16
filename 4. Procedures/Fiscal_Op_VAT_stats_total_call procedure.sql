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