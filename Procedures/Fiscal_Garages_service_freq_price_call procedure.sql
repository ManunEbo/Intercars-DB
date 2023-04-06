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