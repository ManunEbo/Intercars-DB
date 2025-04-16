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