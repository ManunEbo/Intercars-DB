/*icp Carwash Trigger*/

use icp;

drop trigger if exists Carwash_trigger;
Delimiter /

create trigger Carwash_trigger
after insert on icp.Carwash
for each row
		begin 

								-- Insert into icp.Entity
					insert into icp.Entity(Carwash_id,Entity_Name,VAT_Registration_Number)
						values(new.Carwash_id,@Entity_Name,@VAT_Registration_Number);
				
								-- Insert into contact details
					insert into icp.Contact_details(Carwash_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
						values(new.Carwash_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
					
								-- Insert into icp.Names
					Insert into icp.Names(Carwash_id,Fname,Mname,Lname)
						values(new.Carwash_id,@Fname,@Mname,@Lname);
		end /
delimiter ;