/*icp Mechanic Trigger*/

use icp;
drop trigger if exists Mechanic_trigger;
Delimiter /

create trigger Mechanic_trigger
after insert on icp.Mechanic
for each row

begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Mech_Grg_id,Entity_Name,VAT_Registration_Number)
				values(new.Mech_Grg_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Mech_Grg_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Mech_Grg_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(Mech_Grg_id,Fname,Mname,Lname)
				values(new.Mech_Grg_id,@Fname,@Mname,@Lname);

end /
delimiter ;