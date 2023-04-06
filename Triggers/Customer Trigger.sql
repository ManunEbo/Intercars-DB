/*Creating trigger for after insert into Customer*/
use icp;

Delimiter /
create trigger Customer_Insert  after insert
on icp.Customer
for each row
Begin 
if (select Sale_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold))="" and 
(select Deposit_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold))<>"" then
begin
			Insert into icp.names(Customer_id,Fname,Mname,Lname)
					Values(new.Customer_id,(Select Fname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Mname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Lname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)));
                    
			Insert into icp.DOB(Customer_id, Dob)
					Values(new.Customer_id, (Select DOB from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));

			Insert into icp.Deposit(Customer_id,V5C_id,Deposit_Date,Deposit_Amount)
					Values(new.customer_id,(Select V5C_id from icp.V5C where Reg_numb=(select Reg_numb from icp.Hold 
                    where Hold_id=(select max(Hold_id) from icp.Hold))),
                    (Select Deposit_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Deposit_Amount from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)));
                    
     			Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
					values(new.customer_id,(Select Addr1 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr2 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr3 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr4 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr5 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr6 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Email from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Tel from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));
			end;

elseif (select Sale_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)) <>"" and 
(select Deposit_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold))="" then
Begin
			Insert into icp.names(Customer_id,Fname,Mname,Lname)
					Values(new.Customer_id,(Select Fname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Mname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Lname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)));
                    
			Insert into icp.DOB(Customer_id, Dob)
					Values(new.Customer_id, (Select DOB from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));
	
			Insert into icp.Sale(Customer_id, V5C_id, Sale_Date,Sale_Amount)
					Values(new.customer_id, (Select V5C_id from icp.V5C 
                    where Reg_numb=(select Reg_numb from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold))),
                    (Select Sale_Date from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Sale_Amount from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));
 
			Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
					values(new.customer_id,(Select Addr1 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr2 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr3 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr4 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr5 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr6 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Email from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Tel from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));
			end;
            
elseif (select Sale_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)) <>"" and 
(select Deposit_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)) <>"" then
Begin

			Insert into icp.names(Customer_id,Fname,Mname,Lname)
					Values(new.Customer_id,(Select Fname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Mname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Lname from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)));
                    
			Insert into icp.DOB(Customer_id, Dob)
					Values(new.Customer_id, (Select DOB from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));

			Insert into icp.Deposit(Customer_id,V5C_id,Deposit_Date,Deposit_Amount)
					Values(new.customer_id,(Select V5C_id from icp.V5C 
                    where Reg_numb=(select Reg_numb from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold))),
                    (Select Deposit_Date from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Deposit_Amount from icp.hold where Hold_id=(select max(Hold_id) from icp.Hold)));

			Insert into icp.Sale(Customer_id, V5C_id, Sale_Date,Sale_Amount)
					Values(new.customer_id, (Select V5C_id from icp.V5C 
                    where Reg_numb=(select Reg_numb from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold))),
                    (Select Sale_Date from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Sale_Amount from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));
                    
 			Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
					values(new.customer_id,(Select Addr1 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr2 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr3 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr4 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr5 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Addr6 from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Email from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)),
                    (Select Tel from icp.Hold where Hold_id=(select max(Hold_id) from icp.Hold)));
                    
			end;
End if;
End /
Delimiter ;

Show triggers;