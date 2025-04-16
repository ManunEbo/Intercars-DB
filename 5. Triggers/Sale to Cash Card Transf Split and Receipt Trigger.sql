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
            