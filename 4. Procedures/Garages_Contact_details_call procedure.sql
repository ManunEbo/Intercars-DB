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

