/*Triggers*/
Use icp;
/*Creating an after insert into icp.staff trigger*/
Delimiter /
create trigger staff_name_Contact after insert
on icp.Staff
for each row
begin
insert into icp.names(Staff_id, Fname,Mname,Lname)
values(new.staff_id,@Fname,@Mname,@Lname);

insert into icp.contact_details(Staff_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
values(new.staff_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@tel);
end /
delimiter ;

/*Creating trigger for after insert into Customer*/
use icp;

Delimiter /
Create trigger Customer_Insert after insert
on icp.customer
for each row
Begin
	If @Sale_Date="" and @Deposit_Date <> "" then
		Begin
			Insert into icp.names(Customer_id,Fname,Mname,Lname)
					Values(new.Customer_id,@V5C_id1,@Fname,@Mname,@Lname);

			Insert into icp.Deposit(Customer_id,V5C_id,Deposit_Date,Deposit_Amount)
					Values(new.customer_id,@v5c_id1,@Deposit_Date,@Deposit_Amount);

			Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
					values(new.customer_id,@Address1,@Address2,@Address3,@Address4,@Address5,@Address6,@email,@Tel);
		End;

	Elseif @Sale_Date <> "" and @Deposit_Date="" then
		
		Begin 			
			Insert into icp.names(Customer_id,Fname,Mname,Lname)
					Values(new.Customer_id,@V5C_id1,@Fname,@Mname,@Lname);

			Insert into icp.Sale(Customer_id, V5C_id, Sale_Date,Sale_Amount)
					Values(new.customer_id,@V5C_id1,@Sale_Date,@Sale_Amount);

			Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
					values(@cust_id,@Address1,@Address2,@Address3,@Address4,@Address5,@Address6,@email,@Tel);
		End;

	Elseif @Sale_Date <> "" and @Deposit_Date <> "" then
		
		Begin
			Insert into icp.names(Customer_id,Fname,Mname,Lname)
					Values(new.Customer_id,@V5C_id1,@Fname,@Mname,@Lname);
	
			Insert into icp.Sale(Customer_id, V5C_id, Sale_Date,Sale_Amount)
					Values(new.customer_id,@V5C_id1,@Sale_Date,@Sale_Amount);

   select Sale_id into @Sale_id1 from icp.Sale where V5C_id=@V5C_id1; 

			Insert into icp.Deposit(Customer_id,V5C_id,Sale_id,Deposit_Date,Deposit_Amount)
					Values(new.customer_id,@v5c_id1,@Sale_id1,@Deposit_Date,@Deposit_Amount);	
                    
			Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
					values(@cust_id,@Address1,@Address2,@Address3,@Address4,@Address5,@Address6,@email,@Tel);
		End;

	End if;
end /
Delimiter ;

Show triggers;
