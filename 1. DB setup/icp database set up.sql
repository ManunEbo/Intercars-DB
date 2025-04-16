/*********************************************************************************************/
/*************************** Intercars prototype (icp) database ******************************/
/*********************************************************************************************/

/*Creating the database*/

Create database icp;
use icp;
/*Creating the V5C table*/

Create table
icp.V5C(
V5C_id BIGINT  Unique not null auto_increment Primary key,
Reg_numb Varchar(30)  Unique Not null,
Prev_reg_num Varchar(30) ,
Doc_ref_Numb BIGINT  Unique Not null,
Date_first_Reg Date  Not null,
Date_first_Reg_UK Date ,
Make Varchar(30)  Not null,
Model Varchar(30)  not null,
Body_Type varchar(30)  Not null,
Tax_Class Varchar(30)  Not null,
Type_Fuel Varchar(15)  Not null,
Nbr_seats smallint  Not null,
Vehicle_Cat Varchar(30)  Not null,
Colour varchar(15)  Not null,
V5C_Lgbk_issue_date Date  Not null,
Cylinder_capty Varchar(15)  Not null,
Nbr_prev_owners smallint ,
Prev_owner1_Name Varchar(100) ,
Prev_owner1_Addr Varchar(150) ,
Prev_owner1_Acq_date Date ,
Prev_owner2_Name Varchar(100) ,
Prev_owner2_Addr Varchar(150) ,
Prev_owner2_Acq_date Date ,
Prev_owner3_Name Varchar(100) ,
Prev_owner3_Addr Varchar(150) ,
Prev_owner3_Acq_date Date ,
Prev_owner4_Name Varchar(100) ,
Prev_owner4_Addr Varchar(150) ,
Prev_owner4_Acq_date Date ,
Date_added Timestamp  Not null default current_timestamp
);
desc icp.v5c;

/*Creating the Staff table*/
Create table
icp.Staff(
Staff_id INT Unique  not null  auto_increment primary key,
Date_added Timestamp Not null
);
Desc icp.Staff;

/*Creating the Customer table*/
Create table
icp.Customer(
Customer_id BIGINT Unique not null auto_increment primary key,
Date_Added Timestamp Not null default current_timestamp
);
Desc icp.Customer;

/*Creating the DOB table*/
Create table icp.DOB(
DOB_id BIGINT Unique not null auto_increment primary key,
Staff_id INT ,
Customer_id BIGINT ,
DOB Date Not null default "1930/12/31",
Date_added Timestamp Not null default current_timestamp,
Foreign key(Staff_id) references icp.Staff(Staff_id) on delete cascade  ,
Foreign key(Customer_id) references icp.Customer(Customer_id) on delete cascade,
Foreign key(Staff_id) references icp.Staff(Staff_id) on update cascade  ,
Foreign key(Customer_id) references icp.Customer(Customer_id) on update cascade
);
desc icp.DOB;

/*Creating the Hold table*/
Create table icp.Hold(
Hold_id BIGINT Unique not null Auto_increment primary key,
Fname Varchar(30) Not null,
Mname Varchar(30) ,
Lname Varchar(50) Not null,
DOB Date ,
Addr1 Varchar(50) Not null,
Addr2 Varchar(50) ,
Addr3 Varchar(50) ,
Addr4 Varchar(50) ,
Addr5 Varchar(50) ,
Addr6 Varchar(50) Not null,
Email Varchar(100) ,
Tel BIGINT Not null,
Reg_numb Varchar(30) Not null,
Deposit_Amount Decimal(7,2) ,
Deposit_Date Date ,
Sale_Amount Decimal(7,2) ,
Sale_Date Date ,
Date_Added Timestamp Not null default current_timestamp
);

/*Creating the Vendor table*/
Create table
icp.Vendor(
Vendor_id INT Unique not null auto_increment primary key,
Vendor_reference Varchar(30) Unique not null,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.Vendor;

/*Creating the Mechanic table*/
Create table
icp.Mechanic(
Mech_Grg_id INT Unique not null auto_increment primary key,
Date_Added Timestamp Not null default current_timestamp
);
desc icp.Mechanic;

/*Creating the Electrical Mechanic table*/
Create table
icp.Electrical(
Elect_mech_id INT Unique not null auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.Electrical;

/*Creating the MOT Garage table*/
Create table
icp.MOT_Garage(
MOT_Grg_id INT Unique not null auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);
desc icp.MOT_Garage;

/*Creating the Carwash table*/
Create table
icp.Carwash(
Carwash_id INT Unique not null auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.Carwash;

/*Creating the Auction table*/
Create table
icp.Auction(
Auction_id INT Unique not null  auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.Auction;

/*Creating the fund table*/
/*Note the change here; the is now built for BCA and is at individual vehicle level*/
Create table
icp.Fund(
Fund_id BIGINT Unique not null  auto_increment primary key,
Daily_Chrg decimal(3,2) not null default 0.27,
Loading_fee Decimal(5,2) not null default 42.50,
Facility_fee Decimal(5,2) not null default 50.00,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.Fund;

/*Creating the Entity table*/
create table icp.Entity(
Entity_id INT Unique not null Auto_increment primary key,
Auction_id INT ,
Carwash_id INT ,
Fund_id BIGINT ,
Mech_Grg_id INT ,
MOT_Grg_id INT ,
Elect_mech_id INT ,
Vendor_id INT ,
Entity_Name Varchar(50) Unique Not null,
VAT_Registration_Number BIGINT ,
Date_added Timestamp Not null default current_timestamp,
Foreign key(Auction_id) references icp.Auction(Auction_id) on delete cascade  ,
Foreign key(Carwash_id) references icp.CarWash(Carwash_id) on delete cascade  ,
Foreign key(Fund_id) references icp.Fund(Fund_id) on delete cascade  ,
Foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on delete cascade  ,
Foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on delete cascade  ,
Foreign key(Elect_mech_id) references icp.Electrical(Elect_mech_id) on delete cascade  ,
Foreign key(Vendor_id) references icp.Vendor(Vendor_id) on delete cascade,
Foreign key(Auction_id) references icp.Auction(Auction_id) on update cascade  ,
Foreign key(Carwash_id) references icp.CarWash(Carwash_id) on update cascade  ,
Foreign key(Fund_id) references icp.Fund(Fund_id) on update cascade  ,
Foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on update cascade  ,
Foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on update cascade  ,
Foreign key(Elect_mech_id) references icp.Electrical(Elect_mech_id) on update cascade  ,
Foreign key(Vendor_id) references icp.Vendor(Vendor_id) on update cascade
);
Desc icp.Entity;

/*Creating the MOT History table*/
Create table
icp.MOT_History(
MOT_Hist_id BIGINT Unique not null auto_increment primary key,
V5C_ID BIGINT Not null,
Vehicle_Reg_MOT_Date Varchar(30) Not null,
Test_Org Varchar(50) Not null,
Test_Addr Varchar(150) Not null,
Test_Date Date Not null,
Expiry_date Date Not null,
Advisory1 Varchar(100) ,
Advisory2 Varchar(100) ,
Advisory3 Varchar(100) ,
Advisory4 Varchar(100) ,
Advisory5 Varchar(100) ,
MOT_tst_Cert_Nbr BIGINT ,
Price Decimal(7,2) ,
Date_added Timestamp Not null default current_timestamp,
fulltext(Vehicle_Reg_MOT_Date,Test_Org)  ,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on Update cascade  

);
desc icp.MOT_History;

/*Creating the MOT_Refusal table*/
Create table
icp.MOT_Refusal(
MOT_Refusal_id BIGINT Unique not null auto_increment primary key,
V5C_id BIGINT Not null,
Vehicle_Reg_MOT_Date Varchar(30) Not null,
Test_comp Varchar(50) Not null,
Test_Addr Varchar(150) Not null,
Test_Date Date Not null,
Ref_Reason1 Varchar(100) Not null,
Ref_Reason2 Varchar(100) ,
Ref_Reason3 Varchar(100) ,
Ref_Reason4 Varchar(100) ,
Ref_Reason5 Varchar(100) ,
Date_added Timestamp Not null default current_timestamp,
fulltext(Vehicle_Reg_MOT_Date,Test_comp)  ,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on update cascade
);
desc icp.MOT_Refusal;

/*Creating the Service History(V5C) table*/
Create table
icp.Service_History(
Serv_Hist_id BIGINT Unique not null auto_increment primary key,
V5C_id BIGINT Not null,
Vehicle_Reg_serv_Date Varchar(30) Not null,
Serv_comp Varchar(50) Not null,
Serv_Addr Varchar(150) Not null,
Serv_Date Date Not null,
Serv_Parts_desc Varchar(100) Not null,
Quantity smallint Not null,
Unit_price Decimal(7,2) Not null,
Sum_per_Parts Decimal(7,2) ,
Total_Labour Decimal(7,2) ,
Total_Parts Decimal(7,2) ,
MOT_Fee Decimal(7,2) ,
VAT Decimal(7,2) ,
Grand_Total Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
fulltext(Vehicle_Reg_serv_Date,Serv_comp)  ,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on update cascade
);
desc icp.Service_History;

/*Creating the Mileage history table*/
Create table
icp.Mileage_History(
Mileage_Hist_id BIGINT Unique not null auto_increment primary key,
V5C_id BIGINT Not null,
Vehicle_Reg_MOT_Date Varchar(30) Not null,
Source Varchar(8) Not null,
Mileage BIGINT Not null,
Date Date Not null,
Date_added Timestamp Not null default current_timestamp,
Fulltext(Vehicle_Reg_MOT_Date)  ,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on update cascade
);
desc icp.Mileage_History;

/*Creating the Contact details table */
Create table
icp.Contact_details(
Contact_id BIGINT Unique not null  auto_increment primary key,
Staff_id INT Unique,
Customer_id BIGINT Unique,
Auction_id INT Unique,
Vendor_id INT Unique,
Fund_id BIGINT Unique,
Mech_Grg_id INT Unique,
Elect_Mech_id INT Unique,
MOT_Grg_id INT Unique,
Carwash_id INT Unique,
Address1 Varchar(50) Not null,
Address2 Varchar(50) Not null,
Address3 Varchar(50) Not null,
Address4 Varchar(50) Not null,
Address5 Varchar(50) Not null,
Address6 Varchar(50) Not null,
email Varchar(100) Not null,
Tel BIGINT Not null,
Date_added Timestamp Not null default Current_timestamp,
foreign key(Staff_id) references icp.Staff(Staff_id) on delete cascade,
foreign key(Customer_id) references icp.Customer(Customer_id) on delete cascade,
foreign key(Auction_id) references icp.Auction(Auction_id) on delete cascade,
foreign key(Vendor_id) references icp.Vendor(Vendor_id) on delete cascade,
foreign key(Fund_id) references icp.Fund(Fund_id) on delete cascade,
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on delete cascade,
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id) on delete cascade,
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on delete cascade,
foreign key(Carwash_id) references icp.Carwash(Carwash_id) on delete cascade,

foreign key(Staff_id) references icp.Staff(Staff_id) on update cascade,
foreign key(Customer_id) references icp.Customer(Customer_id) on update cascade,
foreign key(Auction_id) references icp.Auction(Auction_id) on update cascade,
foreign key(Vendor_id) references icp.Vendor(Vendor_id) on update cascade,
foreign key(Fund_id) references icp.Fund(Fund_id) on update cascade,
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on update cascade,
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id) on update cascade,
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on update cascade,
foreign key(Carwash_id) references icp.Carwash(Carwash_id) on update cascade

);
Desc icp.contact_details;

/*Creating the Names table*/

Create table
icp.Names(
Name_id BIGINT Unique not null auto_increment primary key,
Staff_id INT Unique,
Customer_id BIGINT Unique,
Mech_Grg_id INT Unique,
Elect_mech_id INT Unique,
MOT_Grg_id INT Unique,
Carwash_id INT Unique,
Fname Varchar(30) Not null,
Mname Varchar(30),
Lname Varchar(50) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Staff_id) references icp.Staff(Staff_id) on delete cascade,
foreign key(Customer_id) references icp.Customer(Customer_id) on delete cascade,
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on delete cascade,
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id) on delete cascade,
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on delete cascade,
foreign key(Carwash_id) references icp.Carwash(Carwash_id) on delete cascade,

foreign key(Staff_id) references icp.Staff(Staff_id) on update cascade,
foreign key(Customer_id) references icp.Customer(Customer_id) on update cascade,
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on update cascade,
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id) on update cascade,
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on update cascade,
foreign key(Carwash_id) references icp.Carwash(Carwash_id) on update cascade

);
Desc icp.Names;

/*Creating the Auction invoice (Vehicle finance table*/
Create table
icp.Auction_invoice(
Auct_Invoice_id BIGINT Unique not null auto_increment,
V5C_id BIGINT Unique Not null,
Auction_id INT Not null,
Vendor_id INT Not null,
Invoice_nbr Varchar(30) Unique Not null,
Invoice_Date Date Not null,
Reg_nbr Varchar(30) Unique Not null,
Make Varchar(30) Not null,
Model Varchar(30) Not null,
Date_first_Reg Date Not null,
MOT Boolean ,
MOT_Expiry_date Date ,
Mileage BIGINT Not null,
Cash_Payment Boolean Not null,
Price Decimal(7,2) Not null,
Buyers_Fee Decimal(7,2) Not null,
Assurance_Fee Decimal(7,2) ,
Other_Fee Decimal(7,2) ,
Storage_Fee Decimal(7,2) ,
Cash_Handling_fee Decimal(7,2) ,
Auction_VAT Decimal(7,2) Not null,
Total Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,
foreign key(Auction_id) references icp.Auction(Auction_id) on delete cascade,
foreign key(Vendor_id) references icp.Vendor(Vendor_id) on delete cascade,

foreign key(V5C_ID) references icp.V5C(V5C_ID) on update cascade,
foreign key(Auction_id) references icp.Auction(Auction_id) on update cascade,
foreign key(Vendor_id) references icp.Vendor(Vendor_id) on update cascade
);
desc icp.Auction_invoice;

/*Creating the sale table */
Create table
icp.Sale(
Sale_id BIGINT Unique not null auto_increment primary key,
Customer_id BIGINT Unique Not null,
V5C_id BIGINT Unique Not null,
Sale_Date Date Not null,
Sale_Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Customer_id) references icp.Customer(Customer_id) on delete cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,

foreign key(Customer_id) references icp.Customer(Customer_id) on update cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on update cascade
);
Desc icp.sale;

/*Creating the Deposit table*/
Create table
icp.Deposit(
Deposit_id BIGINT Unique not null auto_increment primary key,
Customer_id BIGINT Unique Not null,
V5C_id BIGINT Not null,
Sale_id BIGINT ,
Deposit_Date Date Not null,
Deposit_Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Customer_id) references icp.Customer(Customer_id) on delete cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on delete cascade,
foreign key(Sale_id) references icp.Sale(Sale_id) on delete cascade,

foreign key(Customer_id) references icp.Customer(Customer_id) on update cascade,
foreign key(V5C_ID) references icp.V5C(V5C_ID) on update cascade,
foreign key(Sale_id) references icp.Sale(Sale_id) on update cascade
);
desc icp.deposit;

/*Creating the transfer table*/
Create table
icp.Transfer(
Transfer_id BIGINT Unique not null auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Transfer_date Date Not null,
Transfer_Reference Varchar(30) Unique Not null,
Transfer_Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Sale_id) references icp.Sale(Sale_id) on delete cascade,
foreign key(Deposit_id) references icp.Deposit(Deposit_id) on delete cascade,

foreign key(Sale_id) references icp.Sale(Sale_id) on update cascade,
foreign key(Deposit_id) references icp.Deposit(Deposit_id) on update cascade
);
Desc icp.Transfer;

/*Creating the Receipt (Vehicle finance) table*/
Create table
icp.Receipt(
Receipt_id BIGINT Unique not null auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Card_Nbr BIGINT Not null,
Debit_Type Varchar(15) Not null,
Start_Date Date Not null,
Exp_Date Date Not null,
Trans_Date Date Not null,
Trans_time Time Not null,
Auth_code BIGINT Unique Not null,
Receipt_Nbr BIGINT Unique Not null,
Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default  current_timestamp,
foreign key(Sale_id) references icp.Sale(Sale_id) on delete cascade,
foreign key(Deposit_id) references icp.Deposit(Deposit_id) on delete cascade,

foreign key(Sale_id) references icp.Sale(Sale_id) on update cascade,
foreign key(Deposit_id) references icp.Deposit(Deposit_id) on update cascade
);
Desc icp.Receipt;

/* Creating the Split payment table*/
Create table
icp.Split_Payment(
Split_Pay_id BIGINT Unique not null Auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Transfer_id BIGINT ,
Payment1 Decimal(7,2) Not null,
Receipt_id1 BIGINT ,
Payment2 Decimal(7,2) Not null,
Receipt_id2 BIGINT ,
Payment3 Decimal(7,2),
Receipt_id3 BIGINT,
Total_Payment Decimal(7,2) Not null,
Payment_Date Date Not null,
Date_Added Timestamp Not null default current_timestamp,
Foreign key(Sale_id) references icp.Sale(Sale_id) on delete cascade,
Foreign key(Deposit_id) references icp.Deposit(Deposit_id) on delete cascade,
Foreign key(Transfer_id) references icp.Transfer(Transfer_id) on delete cascade,
Foreign key(Receipt_id1) references icp.Receipt(Receipt_id) on delete cascade,
Foreign key(Receipt_id2) references icp.Receipt(Receipt_id) on delete cascade,
Foreign key(Receipt_id3) references icp.Receipt(Receipt_id) on delete cascade,

Foreign key(Sale_id) references icp.Sale(Sale_id) on Update cascade,
Foreign key(Deposit_id) references icp.Deposit(Deposit_id) on Update cascade,
Foreign key(Transfer_id) references icp.Transfer(Transfer_id) on Update cascade,
Foreign key(Receipt_id1) references icp.Receipt(Receipt_id) on Update cascade,
Foreign key(Receipt_id2) references icp.Receipt(Receipt_id) on Update cascade,
Foreign key(Receipt_id3) references icp.Receipt(Receipt_id) on Update cascade
);
Desc icp.Split_Payment;

/*Creating the Cash Payment table*/
Create table
icp.Cash_Payment(
Cash_Pay_id BIGINT Unique not null Auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Cash_Amount Decimal(7,2) Not null,
Cash_Payment_date Date Not null,
Date_Added Timestamp Not null default current_timestamp,
Foreign key(Sale_id) references icp.Sale(Sale_id) on delete cascade,
Foreign key(Deposit_id) references icp.Deposit(Deposit_id) on delete cascade,

Foreign key(Sale_id) references icp.Sale(Sale_id) on update cascade,
Foreign key(Deposit_id) references icp.Deposit(Deposit_id) on update cascade
);
Desc icp.Cash_Payment;

/*Creating the operation Services table*/
Create table
icp.op_service(
Op_Service_id BIGINT Unique not null Auto_increment primary key,
Mech_Grg_id INT ,
Elect_mech_id INT ,
MOT_Grg_id INT ,
Carwash_id INT ,
V5C_id BIGINT,
Serv_date Date Not null,
Serv_Invoice_nbr Varchar(30) Unique not null,
Serv_Invoice_Date Date Not null,
Serv_type Varchar(11) Not null,
Description Varchar(100) Not null,
Price Decimal(7,2) Not null,
Paid Boolean Not null,
Paid_Date Date ,
Date_added Timestamp not null default current_timestamp,
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on delete cascade,
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id) on delete cascade,
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on delete cascade,
foreign key(Carwash_id) references icp.Carwash(Carwash_id) on delete cascade,
foreign key(V5C_id) references icp.V5C(V5C_id) on delete cascade,

foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id) on update cascade,
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id) on update cascade,
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id) on update cascade,
foreign key(Carwash_id) references icp.Carwash(Carwash_id) on update cascade,
foreign key(V5C_id) references icp.V5C(V5C_id) on update cascade
);
Desc icp.op_service;

/*Creating the Operations Service Receipt table*/
Create table
icp.Op_Service_Receipt(
Op_Service_Receipt_id BIGINT Unique not null Auto_increment primary key,
Op_Service_id BIGINT Unique not null,
Payment_type Varchar(5) Not null,
Split_payment Boolean Not null,
Trans_Date Date Not null,
Trans_time Time Not null,
Auth_code BIGINT Unique Not null,
Receipt_nbr BIGINT Not null,
Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
Foreign key(Op_Service_id) references icp.Op_service(Op_Service_id) on delete cascade,
Foreign key(Op_Service_id) references icp.Op_service(Op_Service_id) on update cascade
);
Desc icp.Op_Service_Receipt;

/*Creating the Operations Miscellaneous receipt table*/
Create table
icp.Op_misc_Receipt(
Op_misc_Receipt_id BIGINT Unique not null Auto_increment primary key,
Venue Varchar(50) Not null,
Vat_registration BIGINT ,
Purch_date Date Not null,
Item1 Varchar(30) Not null,
Item1_price Decimal(7,2) Not null,
Item1_Qty smallint Not null,
Item2 Varchar(30) ,
Item2_price Decimal(7,2) ,
Item2_Qty smallint ,
Item3 Varchar(30) ,
Item3_price Decimal(7,2) ,
Item3_Qty smallint ,
Item4 Varchar(30) ,
Item4_price Decimal(7,2) ,
Item4_Qty smallint ,
Item5 Varchar(30) ,
Item5_price Decimal(7,2) ,
Item5_Qty smallint ,
Item6 Varchar(30) ,
Item6_price Decimal(7,2) ,
Item6_Qty smallint ,
Item7 Varchar(30) ,
Item7_price Decimal(7,2) ,
Item7_Qty smallint ,
Item8 Varchar(30) ,
Item8_price Decimal(7,2) ,
Item8_Qty smallint ,
Item9 Varchar(30) ,
Item9_price Decimal(7,2) ,
Item9_Qty smallint ,
Item10 Varchar(30) ,
Item10_price Decimal(7,2) ,
Item10_Qty smallint ,
Cash_Payment Boolean Not null,
Auth_Code BIGINT Unique Not null,
Receipt_nbr BIGINT Unique Not null,
Total Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.op_misc_receipt;

/*Creating the Operations Payment table*/
Create table
icp.Op_Payment(
Payment_id BIGINT Unique not null Auto_increment primary key,
Op_Service_id BIGINT ,
Op_Service_Receipt_id BIGINT ,
Op_misc_Receipt_id BIGINT ,
Venue Varchar(50) Not null,
Item Varchar(255) Not null,
Price Decimal(7,2) Not null,
Payment_date Date Not null,
Date_added Timestamp Not null default current_timestamp,
Foreign key(Op_Service_id) references icp.Op_Service(Op_Service_id) on delete cascade,
Foreign key(Op_Service_Receipt_id) references icp.Op_Service_Receipt(Op_Service_Receipt_id) on delete cascade,
Foreign key(Op_misc_Receipt_id) references icp.Op_misc_Receipt(Op_misc_Receipt_id) on delete cascade,

Foreign key(Op_Service_id) references icp.Op_Service(Op_Service_id) on update cascade,
Foreign key(Op_Service_Receipt_id) references icp.Op_Service_Receipt(Op_Service_Receipt_id) on update cascade,
Foreign key(Op_misc_Receipt_id) references icp.Op_misc_Receipt(Op_misc_Receipt_id) on update cascade
);
Desc icp.Op_Payment;

/*Creating the Operations VAT table*/
Create table
icp.Op_VAT(
Op_VAT_id BIGINT Unique not null Auto_increment primary key,
Auct_Invoice_id BIGINT ,
Op_Service_id BIGINT ,
Op_misc_Receipt_id BIGINT ,
Item Varchar(255) Not null,
Gross_Price Decimal(7,2) Not null,
VAT_rate Decimal(4,3) Not null,
Net Decimal(7,2) Not null,
Vat_refund Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Auct_Invoice_id)  references icp.Auction_invoice(Auct_Invoice_id) on delete cascade,
foreign key(Op_Service_id) references icp.Op_Service(Op_Service_id) on delete cascade,
Foreign key(Op_misc_Receipt_id) references icp.Op_misc_Receipt(Op_misc_Receipt_id) on delete cascade,

foreign key(Auct_Invoice_id)  references icp.Auction_invoice(Auct_Invoice_id) on update cascade,
foreign key(Op_Service_id) references icp.Op_Service(Op_Service_id) on update cascade,
Foreign key(Op_misc_Receipt_id) references icp.Op_misc_Receipt(Op_misc_Receipt_id) on update cascade
);
Desc icp.Op_VAT;

/*Creating the Operations call log table*/
Create table
icp.Op_call_Log(
Call_log_id BIGINT Unique not null Auto_increment primary key,
Name Varchar(70) Not null,
Tel BIGINT Not null,
City_village Varchar(50) Not null,
Vehicle Varchar(30) Not null,
Vehicle_Registration Varchar(30) Not null,
Time_of_Call Time Not null,
Date_added Timestamp Not null default current_timestamp
);
Desc icp.Op_call_Log;
