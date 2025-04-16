/*icp Electrical trigger*/
use icp;
drop trigger if exists Electrical_trigger;

Delimiter /

create trigger Electrical_trigger
after insert on icp.Electrical
for each row

begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Elect_mech_id,Entity_Name,VAT_Registration_Number)
				values(new.Elect_mech_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Elect_mech_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Elect_mech_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(Elect_mech_id,Fname,Mname,Lname)
				values(new.Elect_mech_id,@Fname,@Mname,@Lname);

end /
delimiter ;