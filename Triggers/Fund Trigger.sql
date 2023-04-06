/*icp Fund Trigger*/

use icp;

drop trigger if exists Fund_trigger;
Delimiter /

create trigger Fund_trigger
after insert on icp.Fund
for each row

begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Fund_id,Entity_Name,VAT_Registration_Number)
				values(new.Fund_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Fund_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Fund_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
end /
delimiter ;