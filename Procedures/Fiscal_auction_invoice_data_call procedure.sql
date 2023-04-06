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


