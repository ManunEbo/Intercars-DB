/*ICP All Triggers*/

use icp;
-- desc icp.Op_VAT;

/*The icp.Op_VAT table is filled using trigger*/
-- Gross_Price
-- VAT_rate
-- VAT
-- Net

/*1: Trigger after insert on Op_service_Receipt*/

Drop Trigger if exists Op_Vat_service_Receipt_insert;
delimiter /
create trigger Op_Vat_service_Receipt_insert
	after insert on icp.Op_service_Receipt
		for each row
			begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_service_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_service_id,new.Amount,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end /
delimiter ;

/*2: Trigger after insert on Op_bank_transfer*/

Drop Trigger if exists Op_Vat_bank_transfer_insert;
delimiter /
create trigger Op_Vat_bank_transfer_insert
	after insert on icp.Op_bank_transfer
		for each row
			begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_service_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_service_id,new.Transfer_amount,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end /
delimiter ;

/*3: Trigger after insert on Op_misc_Receipt*/

Drop Trigger if exists Op_Vat_misc_Receipt_insert;
delimiter /
create trigger Op_Vat_misc_Receipt_insert
	after insert on icp.Op_misc_Receipt
		for each row
			begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_misc_Receipt_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_misc_Receipt_id,@Gross_Price,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end /
delimiter ;

/*4: Trigger after insert on Auction_invoice*/

Drop Trigger if exists Op_Vat_Auction_invoice_insert;
delimiter /
create trigger Op_Vat_Auction_invoice_insert
	after insert on icp.Auction_invoice
		for each row
			begin
				insert into icp.Op_VAT(Auct_Invoice_id,Gross_Price,VAT_rate,VAT,Net)
				values(new.Auct_Invoice_id,new.Total,@VAT_rate, new.Auction_VAT, new.Total - new.Auction_VAT);
			end /
delimiter ;

/***********************************************************************************************************************************************************************************************************/

/*icp Auction Trigger*/

use icp;

drop trigger if exists Auction_trigger;
Delimiter /

create trigger Auction_trigger
after insert on icp.Auction
for each row

begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Auction_id,Entity_Name,VAT_Registration_Number)
				values(new.Auction_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Auction_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Auction_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
end /
delimiter ;

/***********************************************************************************************************************************************************************************************************/
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

/***********************************************************************************************************************************************************************************************************/

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

/***********************************************************************************************************************************************************************************************************/
  -- No Split payment
/* Creating a trigger for after insert on Deposit
   for inserting into:
   icp.Cash_Card_Payment
   icp.Tranfer
   icp.Receipt
   icp.Split_Payment
   */

drop trigger if exists Deposit_to_Cash_Card_Trans_Receipt_insert;
delimiter /
create trigger Deposit_to_Cash_Card_Trans_Receipt_insert
	after insert on icp.Deposit
		for each row
			begin 
				if @Split_pay = "No" and @Payment_method = "Cash" then 
					begin
						insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
						values(new.Deposit_id,@Payment_method);
		
								-- Insert into icp.Receipt
						insert into icp.Receipt(Deposit_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
						values(new.Deposit_id,@Trans_Date,@Trans_time,@Amount,@Receipt_Nbr);
					end;
				elseif @Split_pay = "No" and @Payment_method = "Card" then 
					begin
						insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
						values(new.Deposit_id,@Payment_method);

								-- Insert into icp.Receipt
						insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
						values(new.Deposit_id,@Card_Nbr,@Debit_Type,@Start_Date,@Exp_Date,@Trans_Date,@Trans_time,@Auth_code,@Amount,@Receipt_Nbr);
					end;                    
							-- Transfer
                elseif @Split_pay = "No" and @Payment_method = "Transfer" then 
					begin
						insert into icp.Transfer(Deposit_id,Transfer_Reference)
						values(new.Deposit_id,@Transfer_Reference);

								-- Insert into icp.Receipt 
							-- Note: Transfers don't have receipts
					end;				

-- ************************************************************************************************************************************************************************************************************* 
                    
								-- Split payments : 3            
				elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1= "Transfer" and @Payment_method2 = "Transfer" and @Payment_method3= "Transfer" then
					begin
						insert into icp.Transfer(Deposit_id,Transfer_Reference)
						values(new.Deposit_id,@Transfer_Reference1),
							  (new.Deposit_id,@Transfer_Reference2),
                              (new.Deposit_id,@Transfer_Reference3);                              
							-- Insert into icp.Split_Payment
						insert into icp.Split_Payment(Deposit_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Deposit_id, (select max(Transfer_id) from icp.Transfer) -2,@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
							  (new.Deposit_id, (select max(Transfer_id) from icp.Transfer) -1,@Split_Amount2,new.Deposit_Amount,new.Deposit_Date),
							  (new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount3,new.Deposit_Amount,new.Deposit_Date);
					end;
				elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1= "Transfer" and @Payment_method2 = "Transfer" 
                and @Payment_method3 in("Card","Cash") then
					begin
						insert into icp.Transfer(Deposit_id,Transfer_Reference)
						values(new.Deposit_id,@Transfer_Reference1),
							  (new.Deposit_id,@Transfer_Reference2);
		
							-- Insert into icp.Cash_Card_Payment
						insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
						values(new.Deposit_id,@Payment_method3);
                        
								-- Insert into icp.Split_Payment
						insert into icp.Split_Payment(Deposit_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Deposit_id, (select max(Transfer_id) from icp.Transfer) -1,@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
							  (new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount2,new.Deposit_Amount,new.Deposit_Date);


						insert into icp.Split_Payment(Deposit_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Deposit_Amount,new.Deposit_Date);
                        
								-- inserting into icp.Receipt
						if @Payment_method3="Card" then 
							begin
								insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
								values(new.Deposit_id,@Card_Nbr3,@Debit_Type3,@Start_Date3,@Exp_Date3,@Trans_Date3,@Trans_time3,@Auth_code3,@Split_Amount3,@Receipt_Nbr3);
							end;
						elseif @Payment_method3="Cash" then 
							begin
								insert into icp.Receipt(Deposit_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
								values(new.Deposit_id,@Trans_Date3,@Trans_time3,@Split_Amount3,@Receipt_Nbr3);
							end;
						end if;
					end;
								-- One Transfer and two Cash or Card
					elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1= "Transfer" and @Payment_method2 in("Card","Cash") 
                    and @Payment_method3 in("Card","Cash") then
						begin
								-- Insert into icp.Transfer
							insert into icp.Transfer(Deposit_id,Transfer_Reference)
							values(new.Deposit_id,@Transfer_Reference1);
                            
								-- Insert into icp.Cash_Card_Payment
							insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
							values(new.Deposit_id,@Payment_method2),
								  (new.Deposit_id,@Payment_method3);
                                  
								-- Insert into icp.Split_Payment
							insert into icp.Split_Payment(Deposit_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Deposit_Amount,new.Deposit_Date);
        
							insert into icp.Split_Payment(Deposit_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount2,new.Deposit_Amount,new.Deposit_Date),
								  (new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Deposit_Amount,new.Deposit_Date);
                                  
							-- insert into icp.Receipt. Note: Transfers don't have receipts
                            if @Payment_method2="Card" and @Payment_method3="Card" then 
								begin
									insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
										values(new.Deposit_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2),
											  (new.Deposit_id,@Card_Nbr3,@Debit_Type3,@Start_Date3,@Exp_Date3,@Trans_Date3,@Trans_time3,@Auth_code3,@Split_Amount3,@Receipt_Nbr3);
								end;
							elseif @Payment_method2="Card" and @Payment_method3="Cash" then 
								begin
									insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
										values(new.Deposit_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);
											  
									insert into icp.Receipt(Deposit_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
										values(new.Deposit_id,@Trans_Date3,@Trans_time3,@Split_Amount3,@Receipt_Nbr3);
								end;
							end if;
						end;					
                    			-- Three Cash or Card
					elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1 in("Card","Cash") and @Payment_method2 in("Card","Cash") 
                    and @Payment_method3 in("Card","Cash") then
						begin
							if @Payment_method1 = "Card" and @Payment_method2 ="Card" and @Payment_method3 ="Card" then
								begin
											-- Insert into icp.Cash_Card_Payment
									insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
									values(new.Deposit_id,@Payment_method1),
										  (new.Deposit_id,@Payment_method2),
										  (new.Deposit_id,@Payment_method3);
                                          
											-- Insert into icp.Split_Payment
									insert into icp.Split_Payment(Deposit_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
									values(new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -2,@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
										  (new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount2,new.Deposit_Amount,new.Deposit_Date),
										  (new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Deposit_Amount,new.Deposit_Date);
                                  
											-- Insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1),
										  (new.Deposit_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2),
										  (new.Deposit_id,@Card_Nbr3,@Debit_Type3,@Start_Date3,@Exp_Date3,@Trans_Date3,@Trans_time3,@Auth_code3,@Split_Amount3,@Receipt_Nbr3);								
								end;
							
                            elseif  @Payment_method1 = "Card" and @Payment_method2 ="Card" and @Payment_method3 ="Cash" then
								begin
											-- Insert into icp.Cash_Card_Payment
									insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
									values(new.Deposit_id,@Payment_method1),
										  (new.Deposit_id,@Payment_method2),
										  (new.Deposit_id,@Payment_method3);
									
                                    		-- Insert into icp.Split_Payment
									insert into icp.Split_Payment(Deposit_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
									values(new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -2,@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
										  (new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount2,new.Deposit_Amount,new.Deposit_Date),
										  (new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Deposit_Amount,new.Deposit_Date);
									
                                    		-- Insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1),
										  (new.Deposit_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);									
											-- Cash insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
										values(new.Deposit_id,@Trans_Date3,@Trans_time3,@Split_Amount3,@Receipt_Nbr3);                                
                                end;                        
							end if;                            
                            
						end;

-- ************************************************************************************************************************************************************************************************************* 					
                    		-- Two way split pay Transfer
                    elseif @Split_pay = "Yes" and @Nbr_splits = 2 and @Payment_method1 ="Transfer" and @Payment_method2 ="Transfer" then
						begin
								-- Insert into icp.Transfer
							insert into icp.Transfer(Deposit_id,Transfer_Reference)
							values(new.Deposit_id,@Transfer_Reference1),
								  (new.Deposit_id,@Transfer_Reference2);
                            
                                		-- Insert into icp.Split_Payment
							insert into icp.Split_Payment(Deposit_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
								  (new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Deposit_Amount,new.Deposit_Date); 
                        end;
					
							-- Two way split pay Transfer
                    elseif @Split_pay = "Yes" and @Nbr_splits = 2 and @Payment_method1 ="Transfer" and @Payment_method2 in("Card","Cash") then
						begin
								-- Insert into icp.Transfer
							insert into icp.Transfer(Deposit_id,Transfer_Reference)
							values(new.Deposit_id,@Transfer_Reference1);
                            
                            	-- Insert into icp.Cash_Card_Payment
							insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
							values(new.Deposit_id,@Payment_method2);
                            
                                		-- Insert into icp.Split_Payment
							insert into icp.Split_Payment(Deposit_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Deposit_Amount,new.Deposit_Date);
                            
                            		-- Insert into icp.Split_Payment Cash Card
							insert into icp.Split_Payment(Deposit_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount2,new.Deposit_Amount,new.Deposit_Date);
                            
                            if @Payment_method2 = "Card" then
								begin
                                    -- Insert into icp.Receipt
                                    insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);                                
                                end;
							elseif @Payment_method2 = "Cash" then
								begin
													-- Cash insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Trans_Date2,@Trans_time2,@Split_Amount2,@Receipt_Nbr2);                                    
                                end;
							end if;
                        end;
                        		-- Two way split pay
                    elseif @Split_pay = "Yes" and @Nbr_splits = 2 and @Payment_method1 ="Card" and @Payment_method2 in("Card","Cash") then
						begin
                        
									-- Insert into icp.Cash_Card_Payment
									insert into icp.Cash_Card_Payment(Deposit_id,Payment_type)
									values(new.Deposit_id,@Payment_method1),
										  (new.Deposit_id,@Payment_method2);
									
                                    		-- Insert into icp.Split_Payment
									insert into icp.Split_Payment(Deposit_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
									values(new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
										  (new.Deposit_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount2,new.Deposit_Amount,new.Deposit_Date);
									                                
							if @Payment_method2 = "Card" then
								begin
											-- Insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1),
										  (new.Deposit_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);
                                end;
							elseif @Payment_method2 = "Cash" then
								begin
											-- Insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1);
                                    
											-- Cash insert into icp.Receipt
									insert into icp.Receipt(Deposit_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
									values(new.Deposit_id,@Trans_Date2,@Trans_time2,@Split_Amount2,@Receipt_Nbr2);
                                end;
							end if;
                        end;
			end if;
		end /
delimiter ;
            
/***********************************************************************************************************************************************************************************************************/
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

/***********************************************************************************************************************************************************************************************************/
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

/***********************************************************************************************************************************************************************************************************/
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

/***********************************************************************************************************************************************************************************************************/
/*icp MOT garage Trigger*/

use icp;

drop trigger if exists MOT_Garage_trigger;
Delimiter /

create trigger MOT_Garage_trigger
after insert on icp.MOT_Garage
for each row

begin 
						-- Insert into icp.Entity
			insert into icp.Entity(MOT_Grg_id,Entity_Name,VAT_Registration_Number)
				values(new.MOT_Grg_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(MOT_Grg_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.MOT_Grg_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(MOT_Grg_id,Fname,Mname,Lname)
				values(new.MOT_Grg_id,@Fname,@Mname,@Lname);

end /
delimiter ;

/***********************************************************************************************************************************************************************************************************/
/* Creating a trigger for after insert on icp.Sale
   for inserting into:
   icp.Cash_Card_Payment
   icp.Tranfer
   icp.Receipt
   icp.Split_Payment
   */

drop trigger if exists Sale_to_Cash_Card_Trans_Receipt_insert;
delimiter /
create trigger Sale_to_Cash_Card_Trans_Receipt_insert
	after insert on icp.Sale
		for each row
			begin 
				if @Split_pay = "No" and @Payment_method = "Cash" then 
					begin
						insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
						values(new.Sale_id,@Payment_method);
		
								-- Insert into icp.Receipt
						insert into icp.Receipt(Sale_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
						values(new.Sale_id,@Trans_Date,@Trans_time,@Amount,@Receipt_Nbr);
					end;
				elseif @Split_pay = "No" and @Payment_method = "Card" then 
					begin
						insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
						values(new.Sale_id,@Payment_method);

								-- Insert into icp.Receipt
						insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
						values(new.Sale_id,@Card_Nbr,@Debit_Type,@Start_Date,@Exp_Date,@Trans_Date,@Trans_time,@Auth_code,@Amount,@Receipt_Nbr);
					end;                    
							-- Transfer
                elseif @Split_pay = "No" and @Payment_method = "Transfer" then 
					begin
						insert into icp.Transfer(Sale_id,Transfer_Reference)
						values(new.Sale_id,@Transfer_Reference);
                        
                        		-- Insert into icp.Split_Payment
						insert into icp.Split_Payment(Sale_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount,new.Sale_Amount,new.Sale_Date);

								-- Insert into icp.Receipt 
							-- Note: Transfers don't have receipts
					end;				

-- ************************************************************************************************************************************************************************************************************* 
                    
								-- Split payments : 3            
				elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1= "Transfer" and @Payment_method2 = "Transfer" and @Payment_method3= "Transfer" then
					begin
						insert into icp.Transfer(Sale_id,Transfer_Reference)
						values(new.Sale_id,@Transfer_Reference1),
							  (new.Sale_id,@Transfer_Reference2),
                              (new.Sale_id,@Transfer_Reference3);                              
							-- Insert into icp.Split_Payment
						insert into icp.Split_Payment(Sale_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Sale_id, (select max(Transfer_id) from icp.Transfer) -2,@Split_Amount1,new.Sale_Amount,new.Sale_Date),
							  (new.Sale_id, (select max(Transfer_id) from icp.Transfer) -1,@Split_Amount2,new.Sale_Amount,new.Sale_Date),
							  (new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount3,new.Sale_Amount,new.Sale_Date);
					end;
				elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1= "Transfer" and @Payment_method2 = "Transfer" 
                and @Payment_method3 in("Card","Cash") then
					begin
						insert into icp.Transfer(Sale_id,Transfer_Reference)
						values(new.Sale_id,@Transfer_Reference1),
							  (new.Sale_id,@Transfer_Reference2);
		
							-- Insert into icp.Cash_Card_Payment
						insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
						values(new.Sale_id,@Payment_method3);
                        
								-- Insert into icp.Split_Payment
						insert into icp.Split_Payment(Sale_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Sale_id, (select max(Transfer_id) from icp.Transfer) -1,@Split_Amount1,new.Sale_Amount,new.Sale_Date),
							  (new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount2,new.Sale_Amount,new.Sale_Date);


						insert into icp.Split_Payment(Sale_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
						values(new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Sale_Amount,new.Sale_Date);
                        
								-- inserting into icp.Receipt
						if @Payment_method3="Card" then 
							begin
								insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
								values(new.Sale_id,@Card_Nbr3,@Debit_Type3,@Start_Date3,@Exp_Date3,@Trans_Date3,@Trans_time3,@Auth_code3,@Split_Amount3,@Receipt_Nbr3);
							end;
						elseif @Payment_method3="Cash" then 
							begin
								insert into icp.Receipt(Sale_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
								values(new.Sale_id,@Trans_Date3,@Trans_time3,@Split_Amount3,@Receipt_Nbr3);
							end;
						end if;
					end;
								-- One Transfer and two Cash or Card
					elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1= "Transfer" and @Payment_method2 in("Card","Cash") 
                    and @Payment_method3 in("Card","Cash") then
						begin
								-- Insert into icp.Transfer
							insert into icp.Transfer(Sale_id,Transfer_Reference)
							values(new.Sale_id,@Transfer_Reference1);
                            
								-- Insert into icp.Cash_Card_Payment
							insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
							values(new.Sale_id,@Payment_method2),
								  (new.Sale_id,@Payment_method3);
                                  
								-- Insert into icp.Split_Payment
							insert into icp.Split_Payment(Sale_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Sale_Amount,new.Sale_Date);
        
							insert into icp.Split_Payment(Sale_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount2,new.Sale_Amount,new.Sale_Date),
								  (new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Sale_Amount,new.Sale_Date);
                                  
							-- insert into icp.Receipt. Note: Transfers don't have receipts
                            if @Payment_method2="Card" and @Payment_method3="Card" then 
								begin
									insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
										values(new.Sale_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2),
											  (new.Sale_id,@Card_Nbr3,@Debit_Type3,@Start_Date3,@Exp_Date3,@Trans_Date3,@Trans_time3,@Auth_code3,@Split_Amount3,@Receipt_Nbr3);
								end;
							elseif @Payment_method2="Card" and @Payment_method3="Cash" then 
								begin
									insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
										values(new.Sale_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);
											  
									insert into icp.Receipt(Sale_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
										values(new.Sale_id,@Trans_Date3,@Trans_time3,@Split_Amount3,@Receipt_Nbr3);
								end;
							end if;
						end;					
                    			-- Three Cash or Card
					elseif @Split_pay = "Yes" and @Nbr_splits = 3 and @Payment_method1 in("Card","Cash") and @Payment_method2 in("Card","Cash") 
                    and @Payment_method3 in("Card","Cash") then
						begin
							if @Payment_method1 = "Card" and @Payment_method2 ="Card" and @Payment_method3 ="Card" then
								begin
											-- Insert into icp.Cash_Card_Payment
									insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
									values(new.Sale_id,@Payment_method1),
										  (new.Sale_id,@Payment_method2),
										  (new.Sale_id,@Payment_method3);
                                          
											-- Insert into icp.Split_Payment
									insert into icp.Split_Payment(Sale_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
									values(new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -2,@Split_Amount1,new.Sale_Amount,new.Sale_Date),
										  (new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount2,new.Sale_Amount,new.Sale_Date),
										  (new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Sale_Amount,new.Sale_Date);
                                  
											-- Insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Sale_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1),
										  (new.Sale_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2),
										  (new.Sale_id,@Card_Nbr3,@Debit_Type3,@Start_Date3,@Exp_Date3,@Trans_Date3,@Trans_time3,@Auth_code3,@Split_Amount3,@Receipt_Nbr3);								
								end;
							
                            elseif  @Payment_method1 = "Card" and @Payment_method2 ="Card" and @Payment_method3 ="Cash" then
								begin
											-- Insert into icp.Cash_Card_Payment
									insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
									values(new.Sale_id,@Payment_method1),
										  (new.Sale_id,@Payment_method2),
										  (new.Sale_id,@Payment_method3);
									
                                    		-- Insert into icp.Split_Payment
									insert into icp.Split_Payment(Sale_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
									values(new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -2,@Split_Amount1,new.Sale_Amount,new.Sale_Date),
										  (new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount2,new.Sale_Amount,new.Sale_Date),
										  (new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount3,new.Sale_Amount,new.Sale_Date);
									
                                    		-- Insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Sale_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1),
										  (new.Sale_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);									
											-- Cash insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
										values(new.Sale_id,@Trans_Date3,@Trans_time3,@Split_Amount3,@Receipt_Nbr3);                                
                                end;                        
							end if;                            
                            
						end;

-- ************************************************************************************************************************************************************************************************************* 					
                    		-- Two way split pay Transfer
                    elseif @Split_pay = "Yes" and @Nbr_splits = 2 and @Payment_method1 ="Transfer" and @Payment_method2 ="Transfer" then
						begin
								-- Insert into icp.Transfer
							insert into icp.Transfer(Sale_id,Transfer_Reference)
							values(new.Sale_id,@Transfer_Reference1),
								  (new.Sale_id,@Transfer_Reference2);
                            
                                		-- Insert into icp.Split_Payment
							insert into icp.Split_Payment(Sale_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Sale_Amount,new.Sale_Date),
								  (new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Sale_Amount,new.Sale_Date); 
                        end;
					
							-- Two way split pay Transfer
                    elseif @Split_pay = "Yes" and @Nbr_splits = 2 and @Payment_method1 ="Transfer" and @Payment_method2 in("Card","Cash") then
						begin
								-- Insert into icp.Transfer
							insert into icp.Transfer(Sale_id,Transfer_Reference)
							values(new.Sale_id,@Transfer_Reference1);
                            
                            	-- Insert into icp.Cash_Card_Payment
							insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
							values(new.Sale_id,@Payment_method2);
                            
                                		-- Insert into icp.Split_Payment
							insert into icp.Split_Payment(Sale_id,Transfer_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Sale_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount1,new.Sale_Amount,new.Sale_Date);
                            
                            		-- Insert into icp.Split_Payment Cash Card
							insert into icp.Split_Payment(Sale_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
							values(new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount2,new.Sale_Amount,new.Sale_Date);
                            
                            if @Payment_method2 = "Card" then
								begin
                                    -- Insert into icp.Receipt
                                    insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Sale_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);                                
                                end;
							elseif @Payment_method2 = "Cash" then
								begin
													-- Cash insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
									values(new.Sale_id,@Trans_Date2,@Trans_time2,@Split_Amount2,@Receipt_Nbr2);                                    
                                end;
							end if;
                        end;
                        		-- Two way split pay
                    elseif @Split_pay = "Yes" and @Nbr_splits = 2 and @Payment_method1 ="Card" and @Payment_method2 in("Card","Cash") then
						begin
                        
									-- Insert into icp.Cash_Card_Payment
									insert into icp.Cash_Card_Payment(Sale_id,Payment_type)
									values(new.Sale_id,@Payment_method1),
										  (new.Sale_id,@Payment_method2);
									
                                    		-- Insert into icp.Split_Payment
									insert into icp.Split_Payment(Sale_id,Cash_Card_Pay_id,Split_Amount,Total_Payment,Payment_Date)
									values(new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment) -1,@Split_Amount1,new.Sale_Amount,new.Sale_Date),
										  (new.Sale_id, (select max(Cash_Card_Pay_id) from icp.Cash_Card_Payment),@Split_Amount2,new.Sale_Amount,new.Sale_Date);
									                                
							if @Payment_method2 = "Card" then
								begin
											-- Insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Sale_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1),
										  (new.Sale_id,@Card_Nbr2,@Debit_Type2,@Start_Date2,@Exp_Date2,@Trans_Date2,@Trans_time2,@Auth_code2,@Split_Amount2,@Receipt_Nbr2);
                                end;
							elseif @Payment_method2 = "Cash" then
								begin
											-- Insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Card_Nbr,Debit_Type,Start_Date,Exp_Date,Trans_Date,Trans_time,Auth_code,Amount,Receipt_Nbr)
									values(new.Sale_id,@Card_Nbr1,@Debit_Type1,@Start_Date1,@Exp_Date1,@Trans_Date1,@Trans_time1,@Auth_code1,@Split_Amount1,@Receipt_Nbr1);
                                    
											-- Cash insert into icp.Receipt
									insert into icp.Receipt(Sale_id,Trans_Date,Trans_time,Amount,Receipt_Nbr)
									values(new.Sale_id,@Trans_Date2,@Trans_time2,@Split_Amount2,@Receipt_Nbr2);
                                end;
							end if;
                        end;
			end if;
		end /
delimiter ;

/***********************************************************************************************************************************************************************************************************/
use icp;

-- drop trigger if exists Staff_insert;
drop trigger if exists Staff_insert;
Delimiter /
create trigger Staff_insert  after insert
on icp.Staff
for each row
Begin 
-- Insert into names
Insert into icp.Names(Staff_id,Fname,Mname,Lname)
values(new.Staff_id,@Fname,@Mname,@Lname);

-- insert into DOB
Insert into icp.DOB(Staff_id,DOB)
values(new.Staff_id,@DOB);

-- Insert into contact details
Insert into icp.Contact_details(Staff_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
values(new.Staff_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@tel);

end /
delimiter ;

/***********************************************************************************************************************************************************************************************************/
/*icp Vendor Trigger*/

use icp;

drop trigger if exists Vendor_trigger;
Delimiter /

create trigger Vendor_trigger
after insert on icp.Vendor
for each row

begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Vendor_id,Entity_Name,VAT_Registration_Number)
				values(new.Vendor_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Vendor_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Vendor_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
end /
delimiter ;

/***********************************************************************************************************************************************************************************************************/

