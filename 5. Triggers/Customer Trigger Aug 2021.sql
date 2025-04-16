use icp;

drop trigger if exists Customer_Insert;
Delimiter /
create trigger Customer_Insert  after insert
on icp.Customer
for each row
	Begin 
				-- Deposit only
                
	if @Sale_date = "" and @Deposit_Date <> "" then 
		begin

							-- Insert into contact details
				insert into icp.Contact_details(Customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Customer_id,@Address1,@Address2,@Address3,@Address4,@Address5,@Address6,@email,@Tel);

							-- Insert into icp.Names
				Insert into icp.Names(Customer_id,Fname,Mname,Lname)
				values(new.Customer_id,@Fname,@Mname,@Lname);

							-- insert into DOB
				insert into icp.DOB(Customer_id,DOB, Age_Group)
				values(new.Customer_id,@DOB,@Age_Group);

							-- insert into icp.Deposit
				insert into icp.Deposit(Staff_id,Customer_id,V5C_id,Deposit_Amount,Deposit_Date)
				values(@Staff_id,new.Customer_id, @V5C_ID,@Deposit_Amount,@Deposit_Date);

		end;
        
				-- Sale without deposit i.e. sale only
                
	elseif @Sale_date <> "" and @Deposit_Date =  "" then 
		begin
                
							-- Insert into contact details
				insert into icp.Contact_details(Customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Customer_id,@Address1,@Address2,@Address3,@Address4,@Address5,@Address6,@email,@Tel);

							-- Insert into icp.Names
				Insert into icp.Names(Customer_id,Fname,Mname,Lname)
				values(new.Customer_id,@Fname,@Mname,@Lname);

							-- insert into DOB
				insert into icp.DOB(Customer_id,DOB, Age_Group)
				values(new.Customer_id,@DOB,@Age_Group);

							-- insert into icp.Sale
				insert into icp.Sale(Staff_id,Customer_id, V5C_id,Sale_Amount,Sale_Date)
				values(@Staff_id,new.Customer_id, @V5C_ID,@Sale_Amount,@Sale_date);

		end;    
					-- Sale after deposit
                    
	elseif @Sale_date <> "" and @Deposit_Date <>  "" then
		begin 
--         Note: there is no insert into icp.Contact_details, icp.Names, icp.DOB
--         because in this case the customer already exists as they had previously placed a deposit
-- 		   However, the Deposit table is updated with the sale_id to match and map to the sale and the new customer_id with no details

						-- insert into icp.Sale
			insert into icp.Sale(Staff_id,Customer_id, V5C_id,Sale_Amount,Sale_Date)
			values(@Staff_id,new.Customer_id, @V5C_ID,@Sale_Amount,@Sale_date);          
			
            -- Removing safe mode to allow updating icp.Deposit without refering to an id variable
            SET SQL_SAFE_UPDATES = 0;
            
						-- Update icp.Deposit Sale_id
			update icp.Deposit set Sale_id =(select max(Sale_id) from icp.Sale)
            where Deposit_Date = @Deposit_Date and V5C_id = @V5C_ID;
		end;
        
	end if;

end /

delimiter ;


