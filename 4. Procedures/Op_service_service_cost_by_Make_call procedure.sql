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