/*********************************************************************************************/
/*************************** Intercars prototype (icp) database ******************************/
/*********************************************************************************************/

/*Creating the database*/
drop database if exists icp;
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

/*Creating the Staff table*/
Create table
icp.Staff(
Staff_id INT Unique  not null  auto_increment primary key,
Passwd blob not null,
Iv blob not null,
Date_Added Timestamp Not null default current_timestamp
);

/*Creating the Customer table*/
Create table
icp.Customer(
Customer_id BIGINT Unique not null auto_increment primary key,
Date_Added Timestamp Not null default current_timestamp
);

/*Creating the DOB table*/
Create table icp.DOB(
DOB_id BIGINT Unique not null auto_increment primary key,
Staff_id INT ,
Customer_id BIGINT ,
DOB Date  default "1930/12/31",
Age_Group varchar(10),
Date_added Timestamp Not null default current_timestamp,
Foreign key(Staff_id) references icp.Staff(Staff_id),
Foreign key(Customer_id) references icp.Customer(Customer_id),
Foreign key(Staff_id) references icp.Staff(Staff_id),
Foreign key(Customer_id) references icp.Customer(Customer_id)
);

/*Creating the Vendor table*/
Create table
icp.Vendor(
Vendor_id INT Unique not null auto_increment primary key,
Vendor_reference Varchar(30) Unique not null,
Date_added Timestamp Not null default current_timestamp
);

/*Creating the Mechanic table*/
Create table
icp.Mechanic(
Mech_Grg_id INT Unique not null auto_increment primary key,
Date_Added Timestamp Not null default current_timestamp
);

/*Creating the Electrical Mechanic table*/
Create table
icp.Electrical(
Elect_mech_id INT Unique not null auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);

/*Creating the MOT Garage table*/
Create table
icp.MOT_Garage(
MOT_Grg_id INT Unique not null auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);

/*Creating the Carwash table*/
Create table
icp.Carwash(
Carwash_id INT Unique not null auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);

/*Creating the Auction table*/
Create table
icp.Auction(
Auction_id INT Unique not null  auto_increment primary key,
Date_added Timestamp Not null default current_timestamp
);

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

/*Creating the Entity table*/
create table 
icp.Entity(
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
Foreign key(Auction_id) references icp.Auction(Auction_id) ,
Foreign key(Carwash_id) references icp.Carwash(Carwash_id),
Foreign key(Fund_id) references icp.Fund(Fund_id),
Foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
Foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
Foreign key(Elect_mech_id) references icp.Electrical(Elect_mech_id),
Foreign key(Vendor_id) references icp.Vendor(Vendor_id),
Foreign key(Auction_id) references icp.Auction(Auction_id),
Foreign key(Carwash_id) references icp.Carwash(Carwash_id),
Foreign key(Fund_id) references icp.Fund(Fund_id),
Foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
Foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
Foreign key(Elect_mech_id) references icp.Electrical(Elect_mech_id),
Foreign key(Vendor_id) references icp.Vendor(Vendor_id)
);

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
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(V5C_ID) references icp.V5C(V5C_ID) 
);

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
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(V5C_ID) references icp.V5C(V5C_ID)
);

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
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(V5C_ID) references icp.V5C(V5C_ID)
);

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
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(V5C_ID) references icp.V5C(V5C_ID)
);

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
Tel Varchar(16) Not null,
Date_added Timestamp Not null default Current_timestamp,
foreign key(Staff_id) references icp.Staff(Staff_id),
foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(Auction_id) references icp.Auction(Auction_id),
foreign key(Vendor_id) references icp.Vendor(Vendor_id),
foreign key(Fund_id) references icp.Fund(Fund_id),
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id),
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
foreign key(Carwash_id) references icp.Carwash(Carwash_id),

foreign key(Staff_id) references icp.Staff(Staff_id),
foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(Auction_id) references icp.Auction(Auction_id),
foreign key(Vendor_id) references icp.Vendor(Vendor_id),
foreign key(Fund_id) references icp.Fund(Fund_id),
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id),
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
foreign key(Carwash_id) references icp.Carwash(Carwash_id)
);

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
foreign key(Staff_id) references icp.Staff(Staff_id),
foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id),
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
foreign key(Carwash_id) references icp.Carwash(Carwash_id),

foreign key(Staff_id) references icp.Staff(Staff_id),
foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id),
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
foreign key(Carwash_id) references icp.Carwash(Carwash_id)

);

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
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(Auction_id) references icp.Auction(Auction_id),
foreign key(Vendor_id) references icp.Vendor(Vendor_id),

foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(Auction_id) references icp.Auction(Auction_id),
foreign key(Vendor_id) references icp.Vendor(Vendor_id)
);

/*Creating the sale table */
Create table
icp.Sale(
Sale_id BIGINT Unique not null auto_increment primary key,
Staff_id int not null,
Customer_id BIGINT Unique Not null,
V5C_id BIGINT Unique Not null,
Sale_Date Date Not null,
Sale_Time Time,
Sale_Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(Staff_id) references icp.Staff(Staff_id),

foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(Staff_id) references icp.Staff(Staff_id)
);

/*Creating the Deposit table*/
Create table
icp.Deposit(
Deposit_id BIGINT Unique not null auto_increment primary key,
Staff_id int not null,
Customer_id BIGINT Unique Not null,
V5C_id BIGINT Not null,
Sale_id BIGINT ,
Deposit_Date Date Not null,
Deposit_Time Time,
Deposit_Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(Sale_id) references icp.Sale(Sale_id),
foreign key(Staff_id) references icp.Staff(Staff_id),

foreign key(Customer_id) references icp.Customer(Customer_id),
foreign key(V5C_ID) references icp.V5C(V5C_ID),
foreign key(Sale_id) references icp.Sale(Sale_id),
foreign key(Staff_id) references icp.Staff(Staff_id)
);

/*Creating the transfer table*/
Create table
icp.Transfer(
Transfer_id BIGINT Unique not null auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Transfer_Reference Varchar(30) Unique Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Sale_id) references icp.Sale(Sale_id),
foreign key(Deposit_id) references icp.Deposit(Deposit_id),

foreign key(Sale_id) references icp.Sale(Sale_id),
foreign key(Deposit_id) references icp.Deposit(Deposit_id)
);

/*Creating the Receipt (Vehicle finance) table*/
Create table
icp.Receipt(
Receipt_id BIGINT Unique not null auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Card_Nbr BIGINT,
Debit_Type Varchar(15),
Start_Date Date,
Exp_Date Date,
Trans_Date Date,
Trans_time Time,
Auth_code INT,
Amount Decimal(7,2) Not null,
Receipt_Nbr BIGINT Unique Not null,
Date_added Timestamp Not null default  current_timestamp,
foreign key(Sale_id) references icp.Sale(Sale_id),
foreign key(Deposit_id) references icp.Deposit(Deposit_id),

foreign key(Sale_id) references icp.Sale(Sale_id),
foreign key(Deposit_id) references icp.Deposit(Deposit_id)
);

/*Creating the Cash and Card Payment table*/
Create table
icp.Cash_Card_Payment(
Cash_Card_Pay_id BIGINT Unique Not null Auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Payment_type varchar(4) not null,
Date_Added Timestamp Not null default current_timestamp,
Foreign key(Sale_id) references icp.Sale(Sale_id),
Foreign key(Deposit_id) references icp.Deposit(Deposit_id),

Foreign key(Sale_id) references icp.Sale(Sale_id),
Foreign key(Deposit_id) references icp.Deposit(Deposit_id)
);

/* Creating the Split payment table*/
Create table
icp.Split_Payment(
Split_Pay_id BIGINT Unique not null Auto_increment primary key,
Sale_id BIGINT ,
Deposit_id BIGINT ,
Transfer_id BIGINT ,
Cash_Card_Pay_id BIGINT,
Split_Amount Decimal(7,2) Not null,
Total_Payment Decimal(7,2) Not null,
Payment_Date Date Not null,
Date_Added Timestamp Not null default current_timestamp,
Foreign key(Sale_id) references icp.Sale(Sale_id),
Foreign key(Deposit_id) references icp.Deposit(Deposit_id),
Foreign key(Transfer_id) references icp.Transfer(Transfer_id),
Foreign key(Cash_Card_Pay_id) references icp.Cash_Card_Payment(Cash_Card_Pay_id),

Foreign key(Sale_id) references icp.Sale(Sale_id),
Foreign key(Deposit_id) references icp.Deposit(Deposit_id),
Foreign key(Transfer_id) references icp.Transfer(Transfer_id),
Foreign key(Cash_Card_Pay_id) references icp.Cash_Card_Payment(Cash_Card_Pay_id)
);

/*Creating the operation Services table*/
Create table
icp.Op_service(
Op_service_id BIGINT Unique not null Auto_increment primary key,
Mech_Grg_id INT ,
Elect_mech_id INT ,
MOT_Grg_id INT ,
Carwash_id INT ,
V5C_id BIGINT Not null,
Serv_date Date Not null,
Serv_Invoice_nbr Varchar(30),
Serv_Invoice_Date Date,
Serv_Invoice_Description varchar(100),
Serv_type Varchar(15) Not null,
Description Varchar(100) Not null,
Price Decimal(7,2),
Serv_return_date Date,
Service_quality_check_done Varchar(3),
Service_quality_description Varchar(100),
Date_added Timestamp not null default current_timestamp,

foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id),
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
foreign key(Carwash_id) references icp.Carwash(Carwash_id),
foreign key(V5C_id) references icp.V5C(V5C_id),

foreign key(Mech_Grg_id) references icp.Mechanic(Mech_Grg_id),
foreign key(Elect_Mech_id) references icp.Electrical(Elect_Mech_id),
foreign key(MOT_Grg_id) references icp.MOT_Garage(MOT_Grg_id),
foreign key(Carwash_id) references icp.Carwash(Carwash_id),
foreign key(V5C_id) references icp.V5C(V5C_id)
);

/*Creating the Operations Service Receipt table*/
Create table
icp.Op_service_Receipt(
Op_service_Receipt_id BIGINT Unique not null Auto_increment primary key,
Op_service_id BIGINT Unique not null,
Split_payment Boolean Not null,
Trans_Date Date Not null,
Trans_time Time Not null,
Auth_code INT,
Receipt_nbr BIGINT Not null,
Amount Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
Foreign key(Op_service_id) references icp.Op_service(Op_service_id),
Foreign key(Op_service_id) references icp.Op_service(Op_service_id)
);

/*Creating the Operations Miscellaneous receipt table
  This is for other than vehicle service receipt
  in here are things like supermarkets, paint shop
  etc
*/
Create table
icp.Op_misc_Receipt(
Op_misc_Receipt_id BIGINT Unique not null Auto_increment primary key,
Venue Varchar(50) Not null,
Vat_registration varchar(30) ,
Item Varchar(30) Not null,
Price Decimal(7,2) Not null,
Quantity smallint Not null,
Total Decimal(7,2) Not null,
Auth_Code Int,
Receipt_nbr varchar(30) Not null,
Receipt_date Date Not null,
Receipt_time Time Not null,
Date_added Timestamp Not null default current_timestamp
);

/*Creating the Operations Payment table
  This table caters for bank transfers for Op services
  i.e. paying a garage by bank transfer*/
  
Create table
icp.Op_bank_transfer(
Bank_transfer_id BIGINT Unique not null Auto_increment primary key,
Op_service_id BIGINT ,
Split_payment Boolean Not null,
Transfer_amount Decimal(7,2) Not null,
Transfer_date Date Not null,
Date_added Timestamp Not null default current_timestamp,
Foreign key(Op_service_id) references icp.Op_service(Op_service_id),
Foreign key(Op_service_id) references icp.Op_service(Op_service_id)
);

/*Creating the Operations VAT table
  Note: The reason there is no Op_service_receipt_id here is because
  bank transfers will not provide the vat info;
  therefore this info must come from the invoice but can only be 
  inserted into the database at the point when the invoice is paid*/
Create table
icp.Op_VAT(
Op_VAT_id BIGINT Unique not null Auto_increment primary key,
Auct_Invoice_id BIGINT ,
Op_service_id BIGINT ,
Op_misc_Receipt_id BIGINT ,
Item Varchar(255) Not null,
Gross_Price Decimal(7,2) Not null,
VAT_rate Decimal(4,3) Not null,
VAT Decimal(7,2) Not null,
Net Decimal(7,2) Not null,
Date_added Timestamp Not null default current_timestamp,
foreign key(Auct_Invoice_id)  references icp.Auction_invoice(Auct_Invoice_id),
foreign key(Op_service_id) references icp.Op_service(Op_service_id),
Foreign key(Op_misc_Receipt_id) references icp.Op_misc_Receipt(Op_misc_Receipt_id),

foreign key(Auct_Invoice_id)  references icp.Auction_invoice(Auct_Invoice_id),
foreign key(Op_service_id) references icp.Op_service(Op_service_id),
Foreign key(Op_misc_Receipt_id) references icp.Op_misc_Receipt(Op_misc_Receipt_id)
);

/*Creating the Operations call log table*/
Create table
icp.Op_call_Log(
Call_log_id BIGINT Unique not null Auto_increment primary key,
Name Varchar(70) Not null,
Customer_sex Varchar(1) Not null,
Tel BIGINT Not null,
City_or_village Varchar(50) Not null,
Vehicle_of_interest Varchar(30) Not null,
V5C_id BIGINT Not null,
Date_of_call Date Not null,
Time_of_Call Time Not null,
Deposit_flag smallint not null,
Date_added Timestamp Not null default current_timestamp
);

/*Creating the Operations Vehicle_viewing table*/
create table 
icp.Op_vehicle_viewing(
Vehicle_viewing_id BIGINT Unique not null Auto_increment primary key,
Vehicle_of_interest Varchar(30) Not null,
V5C_id BIGINT Not null,
Nbr_Vehicles_viewed smallint not null,
Customer_Age_Bracket varchar(15) Not null,
Customer_sex Varchar(1) Not null,
City_or_village Varchar(50) Not null,
Viewing_date date Not null,
Viewing_time Time not null,
Deposit_Flag Boolean Not null,
Sale_Flag Boolean Not null,
Date_added Timestamp Not null default current_timestamp
);