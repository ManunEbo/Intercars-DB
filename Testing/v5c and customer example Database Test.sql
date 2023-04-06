/*V5C*/
Set @Regnum= "YD14 XUU";
set @Prev_regnum="";
set @Document_Reference=7584736839;
set @First_reg="2014/09/16";
set @first_reg_uk="2014/09/16";
set @Make="BMW";
Set @Model="3 Series";
Set @Bodytype="5 door Hatchback";
set @TaxClass="Diesel car";
set @FuelType="Heavy Oil";
Set @number_Seats=5;
set @Vehicle_Category="M1";
Set @Colour="Blue";
Set @Logbook_Issued_date="2020/06/04";
set @Cylinder_capacity="1995 CC";
set @nbr_Prev_Owners=5;
set @Prev_owner1_Name="Ivo Kom";
Set @Prev_Owner1_Address="1 Goodman Avenue Leicester LE4 1AG";
Set @prev_Owner1_Acq_date="2020/05/15";

SELECT * FROM ICP.V5C;
/**********************************************************************/
/*Customer*/
Set @Reg_numb="YD14 XUU";
Set @Fname="Elvy";
Set @Mname="Kamunyoko";
Set @Lname="Manun'Ebo";
Set @DOB="1982/06/14";
Set @Address1= 30;
Set @Address2= "Bruce Close";
Set @Address3= "Nottingham" ;
Set @Address4= "Nottinghamshire" ;
Set @Address5= "England" ;
Set @Address6 ="NG2 2HR" ;
Set @email = "elvymanunebo@yahoo.co.uk";
Set @Tel= 07591142154;
Set @Deposit_Date="2020/07/13";
Set @Deposit_Amount=100;
set @Sale_date="2020/07/13";
Set @Sale_Amount=4500;
select @Reg_numb,@Fname,@Mname,@Lname,@DOB,@Address1,@Address2,@Address3,
@Address4,@Address5,@Address6,@email,@tel,@Deposit_Date,@Deposit_Amoun,
@Sale_date,@Sale_Amount,@v5c_id1;
					/*Step 1:*/
/*Extracting the V5C_id in preparation for insert into Deposit and Sale*/
select v5c_id into @v5c_id1 from icp.v5c where Reg_numb=@Reg_numb;
/*Inserting into customer, Names, Deposit and sale*/

set @DOB = "1990/11/09";
select @DOB;
insert into icp.customer(DOB)
values(@DOB);

insert into c.customer(DOB)
values(@DOB);

select * from icp.customer;
select * from c.customer;

desc icp.customer;
desc c.customer;


select * from c.customer;

/*Extracting the Customer_id in preparation for 
insert into Deposit, Sale, Names and Contact_details*/

select customer_id into @cust_id from c.customer
where Dob=@DOB;
select @cust_id,@v5c_id1;

/*Insert into names*/
Insert into icp.names(Customer_id,Fname,Mname,Lname)
values(@cust_id,@Fname,@Mname,@Lname);
select * from icp.names;

/*Insert into Deposit*/
insert into icp.deposit(Customer_id,V5C_id,Deposit_Date,Deposit_Amount)
values(@cust_id,@v5c_id1,@Deposit_Date,@Deposit_Amount);
select * from icp.deposit;

/*Insert into Sale*/
Insert into icp.Sale(Customer_id,V5C_id,Sale_date,Sale_Amount)
values(@cust_id,@V5C_id1,@Sale_Date,@Sale_Amount);

/*Insert into icp.Contact Details*/
Insert into icp.contact_details(customer_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
						values(@cust_id,@Address1,@Address2,@Address3,@Address4,@Address5,@Address6,@email,@Tel);

Select * from icp.contact_details;
select * from icp.sale;
select * from icp.deposit;
select * from icp.names;
select * from icp.customer;
select * from icp.v5c;

/*Delete from icp.customer
where customer_id=9;*/

select * from icp.v5c;