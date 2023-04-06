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