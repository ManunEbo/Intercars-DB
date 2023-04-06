-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: localhost    Database: icp
-- ------------------------------------------------------
-- Server version	8.0.26-0ubuntu0.20.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Auction`
--

DROP TABLE IF EXISTS `Auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Auction` (
  `Auction_id` int NOT NULL AUTO_INCREMENT,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Auction_id`),
  UNIQUE KEY `Auction_id` (`Auction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auction`
--

LOCK TABLES `Auction` WRITE;
/*!40000 ALTER TABLE `Auction` DISABLE KEYS */;
INSERT INTO `Auction` VALUES (1,'2021-08-21 15:03:09');
/*!40000 ALTER TABLE `Auction` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Auction_trigger` AFTER INSERT ON `Auction` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Auction_id,Entity_Name,VAT_Registration_Number)
				values(new.Auction_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Auction_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Auction_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Auction_invoice`
--

DROP TABLE IF EXISTS `Auction_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Auction_invoice` (
  `Auct_Invoice_id` bigint NOT NULL AUTO_INCREMENT,
  `V5C_id` bigint NOT NULL,
  `Auction_id` int NOT NULL,
  `Vendor_id` int NOT NULL,
  `Invoice_nbr` varchar(30) NOT NULL,
  `Invoice_Date` date NOT NULL,
  `Reg_nbr` varchar(30) NOT NULL,
  `Make` varchar(30) NOT NULL,
  `Model` varchar(30) NOT NULL,
  `Date_first_Reg` date NOT NULL,
  `MOT` tinyint(1) DEFAULT NULL,
  `MOT_Expiry_date` date DEFAULT NULL,
  `Mileage` bigint NOT NULL,
  `Cash_Payment` tinyint(1) NOT NULL,
  `Price` decimal(7,2) NOT NULL,
  `Buyers_Fee` decimal(7,2) NOT NULL,
  `Assurance_Fee` decimal(7,2) DEFAULT NULL,
  `Other_Fee` decimal(7,2) DEFAULT NULL,
  `Storage_Fee` decimal(7,2) DEFAULT NULL,
  `Cash_Handling_fee` decimal(7,2) DEFAULT NULL,
  `Auction_VAT` decimal(7,2) NOT NULL,
  `Total` decimal(7,2) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `Auct_Invoice_id` (`Auct_Invoice_id`),
  UNIQUE KEY `V5C_id` (`V5C_id`),
  UNIQUE KEY `Invoice_nbr` (`Invoice_nbr`),
  UNIQUE KEY `Reg_nbr` (`Reg_nbr`),
  KEY `Auction_id` (`Auction_id`),
  KEY `Vendor_id` (`Vendor_id`),
  CONSTRAINT `Auction_invoice_ibfk_1` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `Auction_invoice_ibfk_2` FOREIGN KEY (`Auction_id`) REFERENCES `Auction` (`Auction_id`) ON DELETE CASCADE,
  CONSTRAINT `Auction_invoice_ibfk_3` FOREIGN KEY (`Vendor_id`) REFERENCES `Vendor` (`Vendor_id`) ON DELETE CASCADE,
  CONSTRAINT `Auction_invoice_ibfk_4` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE,
  CONSTRAINT `Auction_invoice_ibfk_5` FOREIGN KEY (`Auction_id`) REFERENCES `Auction` (`Auction_id`) ON UPDATE CASCADE,
  CONSTRAINT `Auction_invoice_ibfk_6` FOREIGN KEY (`Vendor_id`) REFERENCES `Vendor` (`Vendor_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auction_invoice`
--

LOCK TABLES `Auction_invoice` WRITE;
/*!40000 ALTER TABLE `Auction_invoice` DISABLE KEYS */;
INSERT INTO `Auction_invoice` VALUES (1,1,1,1,'MM/737764','2021-04-11','ZC14 1XW','BMW','3 Series','2017-12-16',1,'2021-08-01',15000,0,4075.00,100.00,10.00,15.00,75.00,1.00,855.00,5130.00,'2021-08-21 15:34:24'),(2,2,1,1,'MM/731764','2021-07-28','AN1 Tish','Renault','Clio','2011-07-30',1,'2021-11-27',187000,0,1175.00,100.00,10.00,15.00,75.00,0.00,550.00,3300.00,'2021-08-24 21:55:29');
/*!40000 ALTER TABLE `Auction_invoice` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Op_Vat_Auction_invoice_insert` AFTER INSERT ON `Auction_invoice` FOR EACH ROW begin
				insert into icp.Op_VAT(Auct_Invoice_id,Gross_Price,VAT_rate,VAT,Net)
				values(new.Auct_Invoice_id,new.Total,@VAT_rate, new.Auction_VAT, new.Total - new.Auction_VAT);
			end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Carwash`
--

DROP TABLE IF EXISTS `Carwash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Carwash` (
  `Carwash_id` int NOT NULL AUTO_INCREMENT,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Carwash_id`),
  UNIQUE KEY `Carwash_id` (`Carwash_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Carwash`
--

LOCK TABLES `Carwash` WRITE;
/*!40000 ALTER TABLE `Carwash` DISABLE KEYS */;
INSERT INTO `Carwash` VALUES (1,'2021-08-21 14:54:34');
/*!40000 ALTER TABLE `Carwash` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Carwash_trigger` AFTER INSERT ON `Carwash` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Carwash_id,Entity_Name,VAT_Registration_Number)
				values(new.Carwash_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Carwash_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Carwash_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(Carwash_id,Fname,Mname,Lname)
				values(new.Carwash_id,@Fname,@Mname,@Lname);

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Cash_Card_Payment`
--

DROP TABLE IF EXISTS `Cash_Card_Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cash_Card_Payment` (
  `Cash_Card_Pay_id` bigint NOT NULL AUTO_INCREMENT,
  `Sale_id` bigint DEFAULT NULL,
  `Deposit_id` bigint DEFAULT NULL,
  `Payment_type` varchar(4) NOT NULL,
  `Date_Added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Cash_Card_Pay_id`),
  UNIQUE KEY `Cash_Pay_id` (`Cash_Card_Pay_id`),
  KEY `Sale_id` (`Sale_id`),
  KEY `Deposit_id` (`Deposit_id`),
  CONSTRAINT `Cash_Card_Payment_ibfk_1` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON DELETE CASCADE,
  CONSTRAINT `Cash_Card_Payment_ibfk_2` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON DELETE CASCADE,
  CONSTRAINT `Cash_Card_Payment_ibfk_3` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON UPDATE CASCADE,
  CONSTRAINT `Cash_Card_Payment_ibfk_4` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cash_Card_Payment`
--

LOCK TABLES `Cash_Card_Payment` WRITE;
/*!40000 ALTER TABLE `Cash_Card_Payment` DISABLE KEYS */;
INSERT INTO `Cash_Card_Payment` VALUES (2,4,NULL,'Card','2021-08-26 20:15:34'),(3,NULL,2,'Card','2021-08-26 21:04:21'),(5,6,NULL,'Card','2021-08-26 21:07:34'),(7,NULL,4,'Cash','2021-08-27 08:54:08'),(10,8,NULL,'Card','2021-08-27 10:08:11'),(11,8,NULL,'Cash','2021-08-27 10:08:11');
/*!40000 ALTER TABLE `Cash_Card_Payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Contact_details`
--

DROP TABLE IF EXISTS `Contact_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Contact_details` (
  `Contact_id` bigint NOT NULL AUTO_INCREMENT,
  `Staff_id` int DEFAULT NULL,
  `Customer_id` bigint DEFAULT NULL,
  `Auction_id` int DEFAULT NULL,
  `Vendor_id` int DEFAULT NULL,
  `Fund_id` bigint DEFAULT NULL,
  `Mech_Grg_id` int DEFAULT NULL,
  `Elect_Mech_id` int DEFAULT NULL,
  `MOT_Grg_id` int DEFAULT NULL,
  `Carwash_id` int DEFAULT NULL,
  `Address1` varchar(50) NOT NULL,
  `Address2` varchar(50) NOT NULL,
  `Address3` varchar(50) NOT NULL,
  `Address4` varchar(50) NOT NULL,
  `Address5` varchar(50) NOT NULL,
  `Address6` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `Tel` varchar(16) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Contact_id`),
  UNIQUE KEY `Contact_id` (`Contact_id`),
  UNIQUE KEY `Staff_id` (`Staff_id`),
  UNIQUE KEY `Customer_id` (`Customer_id`),
  UNIQUE KEY `Auction_id` (`Auction_id`),
  UNIQUE KEY `Vendor_id` (`Vendor_id`),
  UNIQUE KEY `Fund_id` (`Fund_id`),
  UNIQUE KEY `Mech_Grg_id` (`Mech_Grg_id`),
  UNIQUE KEY `Elect_Mech_id` (`Elect_Mech_id`),
  UNIQUE KEY `MOT_Grg_id` (`MOT_Grg_id`),
  UNIQUE KEY `Carwash_id` (`Carwash_id`),
  CONSTRAINT `Contact_details_ibfk_1` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_10` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_11` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_12` FOREIGN KEY (`Auction_id`) REFERENCES `Auction` (`Auction_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_13` FOREIGN KEY (`Vendor_id`) REFERENCES `Vendor` (`Vendor_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_14` FOREIGN KEY (`Fund_id`) REFERENCES `Fund` (`Fund_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_15` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_16` FOREIGN KEY (`Elect_Mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_17` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_18` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON UPDATE CASCADE,
  CONSTRAINT `Contact_details_ibfk_2` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_3` FOREIGN KEY (`Auction_id`) REFERENCES `Auction` (`Auction_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_4` FOREIGN KEY (`Vendor_id`) REFERENCES `Vendor` (`Vendor_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_5` FOREIGN KEY (`Fund_id`) REFERENCES `Fund` (`Fund_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_6` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_7` FOREIGN KEY (`Elect_Mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_8` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Contact_details_ibfk_9` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Contact_details`
--

LOCK TABLES `Contact_details` WRITE;
/*!40000 ALTER TABLE `Contact_details` DISABLE KEYS */;
INSERT INTO `Contact_details` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'35','Willow Street','Leicester','Leicestershire','England','LE1 2HR','Nara123@hotmail.com','7710686060','2021-08-21 11:01:13'),(2,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3','Correy Road','Shorditch','Shropshire','England','SH15 7BP','Chakwenza@Ngodo.com','75765449338','2021-08-21 12:36:56'),(3,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,'2','Wheeler dealer Drive','Leicester','Leicestershire','England','LE3 5AS','Supermario@brothers.com','1163458761','2021-08-21 14:23:01'),(4,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'22','Wheeler dealer Drive','Leicester','Leicestershire','England','LE3 2AS','Supermario@brothers.com','1163458781','2021-08-21 14:31:07'),(5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,NULL,'13','Wheeler dealer Drive','Leicester','Leicestershire','England','LE3 2AS','Simon.husrt@SimonhurstMotors.com','1163458781','2021-08-21 14:47:33'),(6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'31','Wheeler dealer Drive','Leicester','Leicestershire','England','LE5 5AS','SuperCarWash@waters.com','11634584521','2021-08-21 14:54:34'),(7,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,'The fields','East Midland road','Derby','Derbyshire','England','DE17 5JJ','Enquiry@Aston.com','13458877613','2021-08-21 15:03:09'),(8,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'The Sheep House','Midland Avenue','Derby','Derbyshire','England','DE17 1JA','Enquiry@Barclays.com','13458879113','2021-08-21 15:11:04'),(9,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,'The Wolf House','Spinner Avenue','Chester','Chestershire','England','CE17 1WS','Enquiry@Shark.org','23567758638','2021-08-21 15:22:54'),(10,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'30','Bruce Close','Nottingham','Nottinghamshire','England','NG2 2HR','elvymanunebo@yahoo.co.uk','7591142154','2021-08-26 21:04:21'),(12,NULL,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'30','Bruce Close','Nottingham','Nottinghamshire','England','NG2 2HR','elvymanunebo@yahoo.co.uk','7591142154','2021-08-26 21:07:34'),(14,NULL,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'45','Kerry road','Litchfield','Leicestershire','England','LE17 9FH','Hakimi@Ngi.co.uk','7591149234','2021-08-27 08:54:08');
/*!40000 ALTER TABLE `Contact_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `Customer_id` bigint NOT NULL AUTO_INCREMENT,
  `Date_Added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Customer_id`),
  UNIQUE KEY `Customer_id` (`Customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (1,'2021-08-21 12:36:56'),(3,'2021-08-21 12:44:42'),(5,'2021-08-26 20:15:34'),(6,'2021-08-26 21:04:21'),(8,'2021-08-26 21:07:34'),(10,'2021-08-27 08:54:08'),(12,'2021-08-27 10:08:11');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Customer_Insert` AFTER INSERT ON `Customer` FOR EACH ROW Begin 
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

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `DOB`
--

DROP TABLE IF EXISTS `DOB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DOB` (
  `DOB_id` bigint NOT NULL AUTO_INCREMENT,
  `Staff_id` int DEFAULT NULL,
  `Customer_id` bigint DEFAULT NULL,
  `DOB` date DEFAULT '1930-12-31',
  `Age_Group` varchar(10) DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DOB_id`),
  UNIQUE KEY `DOB_id` (`DOB_id`),
  KEY `Staff_id` (`Staff_id`),
  KEY `Customer_id` (`Customer_id`),
  CONSTRAINT `DOB_ibfk_1` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
  CONSTRAINT `DOB_ibfk_2` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON DELETE CASCADE,
  CONSTRAINT `DOB_ibfk_3` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON UPDATE CASCADE,
  CONSTRAINT `DOB_ibfk_4` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DOB`
--

LOCK TABLES `DOB` WRITE;
/*!40000 ALTER TABLE `DOB` DISABLE KEYS */;
INSERT INTO `DOB` VALUES (1,1,NULL,'1992-09-08',NULL,'2021-08-21 11:01:13'),(2,NULL,1,'1974-09-29','40 to 49','2021-08-21 12:36:56'),(3,NULL,6,'1984-02-05','30 to 39','2021-08-26 21:04:21'),(5,NULL,8,'1984-02-05','30 to 39','2021-08-26 21:07:34'),(7,NULL,10,'1981-09-28','30 to 39','2021-08-27 08:54:08');
/*!40000 ALTER TABLE `DOB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Deposit`
--

DROP TABLE IF EXISTS `Deposit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Deposit` (
  `Deposit_id` bigint NOT NULL AUTO_INCREMENT,
  `Staff_id` int NOT NULL,
  `Customer_id` bigint NOT NULL,
  `V5C_id` bigint NOT NULL,
  `Sale_id` bigint DEFAULT NULL,
  `Deposit_Date` date NOT NULL,
  `Deposit_Amount` decimal(7,2) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Deposit_id`),
  UNIQUE KEY `Deposit_id` (`Deposit_id`),
  UNIQUE KEY `Customer_id` (`Customer_id`),
  KEY `V5C_id` (`V5C_id`),
  KEY `Sale_id` (`Sale_id`),
  KEY `Staff_id` (`Staff_id`),
  CONSTRAINT `Deposit_ibfk_1` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON DELETE CASCADE,
  CONSTRAINT `Deposit_ibfk_2` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `Deposit_ibfk_3` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON DELETE CASCADE,
  CONSTRAINT `Deposit_ibfk_4` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
  CONSTRAINT `Deposit_ibfk_5` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON UPDATE CASCADE,
  CONSTRAINT `Deposit_ibfk_6` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE,
  CONSTRAINT `Deposit_ibfk_7` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON UPDATE CASCADE,
  CONSTRAINT `Deposit_ibfk_8` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Deposit`
--

LOCK TABLES `Deposit` WRITE;
/*!40000 ALTER TABLE `Deposit` DISABLE KEYS */;
INSERT INTO `Deposit` VALUES (1,1,1,1,2,'2021-06-13',100.00,'2021-08-21 12:36:56'),(2,1,6,11,6,'2021-08-03',100.00,'2021-08-26 21:04:21'),(4,1,10,9,8,'2021-03-03',250.00,'2021-08-27 08:54:08');
/*!40000 ALTER TABLE `Deposit` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Deposit_to_Cash_Card_Trans_Receipt_insert` AFTER INSERT ON `Deposit` FOR EACH ROW begin 
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
		end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Electrical`
--

DROP TABLE IF EXISTS `Electrical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Electrical` (
  `Elect_mech_id` int NOT NULL AUTO_INCREMENT,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Elect_mech_id`),
  UNIQUE KEY `Elect_mech_id` (`Elect_mech_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Electrical`
--

LOCK TABLES `Electrical` WRITE;
/*!40000 ALTER TABLE `Electrical` DISABLE KEYS */;
INSERT INTO `Electrical` VALUES (1,'2021-08-21 14:23:01');
/*!40000 ALTER TABLE `Electrical` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Electrical_trigger` AFTER INSERT ON `Electrical` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Elect_mech_id,Entity_Name,VAT_Registration_Number)
				values(new.Elect_mech_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Elect_mech_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Elect_mech_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(Elect_mech_id,Fname,Mname,Lname)
				values(new.Elect_mech_id,@Fname,@Mname,@Lname);

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Entity`
--

DROP TABLE IF EXISTS `Entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Entity` (
  `Entity_id` int NOT NULL AUTO_INCREMENT,
  `Auction_id` int DEFAULT NULL,
  `Carwash_id` int DEFAULT NULL,
  `Fund_id` bigint DEFAULT NULL,
  `Mech_Grg_id` int DEFAULT NULL,
  `MOT_Grg_id` int DEFAULT NULL,
  `Elect_mech_id` int DEFAULT NULL,
  `Vendor_id` int DEFAULT NULL,
  `Entity_Name` varchar(50) NOT NULL,
  `VAT_Registration_Number` bigint DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Entity_id`),
  UNIQUE KEY `Entity_id` (`Entity_id`),
  UNIQUE KEY `Entity_Name` (`Entity_Name`),
  KEY `Auction_id` (`Auction_id`),
  KEY `Carwash_id` (`Carwash_id`),
  KEY `Fund_id` (`Fund_id`),
  KEY `Mech_Grg_id` (`Mech_Grg_id`),
  KEY `MOT_Grg_id` (`MOT_Grg_id`),
  KEY `Elect_mech_id` (`Elect_mech_id`),
  KEY `Vendor_id` (`Vendor_id`),
  CONSTRAINT `Entity_ibfk_1` FOREIGN KEY (`Auction_id`) REFERENCES `Auction` (`Auction_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_10` FOREIGN KEY (`Fund_id`) REFERENCES `Fund` (`Fund_id`) ON UPDATE CASCADE,
  CONSTRAINT `Entity_ibfk_11` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Entity_ibfk_12` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Entity_ibfk_13` FOREIGN KEY (`Elect_mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON UPDATE CASCADE,
  CONSTRAINT `Entity_ibfk_14` FOREIGN KEY (`Vendor_id`) REFERENCES `Vendor` (`Vendor_id`) ON UPDATE CASCADE,
  CONSTRAINT `Entity_ibfk_2` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_3` FOREIGN KEY (`Fund_id`) REFERENCES `Fund` (`Fund_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_4` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_5` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_6` FOREIGN KEY (`Elect_mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_7` FOREIGN KEY (`Vendor_id`) REFERENCES `Vendor` (`Vendor_id`) ON DELETE CASCADE,
  CONSTRAINT `Entity_ibfk_8` FOREIGN KEY (`Auction_id`) REFERENCES `Auction` (`Auction_id`) ON UPDATE CASCADE,
  CONSTRAINT `Entity_ibfk_9` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Entity`
--

LOCK TABLES `Entity` WRITE;
/*!40000 ALTER TABLE `Entity` DISABLE KEYS */;
INSERT INTO `Entity` VALUES (1,NULL,NULL,NULL,NULL,NULL,1,NULL,'Super Mario Motors',84783976574,'2021-08-21 14:23:01'),(2,NULL,NULL,NULL,1,NULL,NULL,NULL,'Simon says Motors',82783976574,'2021-08-21 14:31:07'),(3,NULL,NULL,NULL,NULL,3,NULL,NULL,'Simon Austin Hurst Motors',8278394,'2021-08-21 14:47:33'),(4,NULL,1,NULL,NULL,NULL,NULL,NULL,'The Carwash Place',783976574111,'2021-08-21 14:54:34'),(5,1,NULL,NULL,NULL,NULL,NULL,NULL,'Aston Barclays',64736367,'2021-08-21 15:03:09'),(6,NULL,NULL,NULL,NULL,NULL,NULL,1,'Barclays',895402451,'2021-08-21 15:11:04'),(7,NULL,NULL,2,NULL,NULL,NULL,NULL,'Shark.org',354658583,'2021-08-21 15:22:54');
/*!40000 ALTER TABLE `Entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Fund`
--

DROP TABLE IF EXISTS `Fund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Fund` (
  `Fund_id` bigint NOT NULL AUTO_INCREMENT,
  `Daily_Chrg` decimal(3,2) NOT NULL DEFAULT '0.27',
  `Loading_fee` decimal(5,2) NOT NULL DEFAULT '42.50',
  `Facility_fee` decimal(5,2) NOT NULL DEFAULT '50.00',
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Fund_id`),
  UNIQUE KEY `Fund_id` (`Fund_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fund`
--

LOCK TABLES `Fund` WRITE;
/*!40000 ALTER TABLE `Fund` DISABLE KEYS */;
INSERT INTO `Fund` VALUES (1,0.50,50.00,100.00,'2021-08-21 15:21:19'),(2,0.50,50.00,100.00,'2021-08-21 15:22:54');
/*!40000 ALTER TABLE `Fund` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Fund_trigger` AFTER INSERT ON `Fund` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Fund_id,Entity_Name,VAT_Registration_Number)
				values(new.Fund_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Fund_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Fund_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `MOT_Garage`
--

DROP TABLE IF EXISTS `MOT_Garage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MOT_Garage` (
  `MOT_Grg_id` int NOT NULL AUTO_INCREMENT,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`MOT_Grg_id`),
  UNIQUE KEY `MOT_Grg_id` (`MOT_Grg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MOT_Garage`
--

LOCK TABLES `MOT_Garage` WRITE;
/*!40000 ALTER TABLE `MOT_Garage` DISABLE KEYS */;
INSERT INTO `MOT_Garage` VALUES (1,'2021-08-21 14:41:00'),(2,'2021-08-21 14:44:09'),(3,'2021-08-21 14:47:33');
/*!40000 ALTER TABLE `MOT_Garage` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MOT_Garage_trigger` AFTER INSERT ON `MOT_Garage` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(MOT_Grg_id,Entity_Name,VAT_Registration_Number)
				values(new.MOT_Grg_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(MOT_Grg_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.MOT_Grg_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(MOT_Grg_id,Fname,Mname,Lname)
				values(new.MOT_Grg_id,@Fname,@Mname,@Lname);

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `MOT_History`
--

DROP TABLE IF EXISTS `MOT_History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MOT_History` (
  `MOT_Hist_id` bigint NOT NULL AUTO_INCREMENT,
  `V5C_ID` bigint NOT NULL,
  `Vehicle_Reg_MOT_Date` varchar(30) NOT NULL,
  `Test_Org` varchar(50) NOT NULL,
  `Test_Addr` varchar(150) NOT NULL,
  `Test_Date` date NOT NULL,
  `Expiry_date` date NOT NULL,
  `Advisory1` varchar(100) DEFAULT NULL,
  `Advisory2` varchar(100) DEFAULT NULL,
  `Advisory3` varchar(100) DEFAULT NULL,
  `Advisory4` varchar(100) DEFAULT NULL,
  `Advisory5` varchar(100) DEFAULT NULL,
  `MOT_tst_Cert_Nbr` bigint DEFAULT NULL,
  `Price` decimal(7,2) DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`MOT_Hist_id`),
  UNIQUE KEY `MOT_Hist_id` (`MOT_Hist_id`),
  KEY `V5C_ID` (`V5C_ID`),
  FULLTEXT KEY `Vehicle_Reg_MOT_Date` (`Vehicle_Reg_MOT_Date`,`Test_Org`),
  CONSTRAINT `MOT_History_ibfk_1` FOREIGN KEY (`V5C_ID`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `MOT_History_ibfk_2` FOREIGN KEY (`V5C_ID`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MOT_History`
--

LOCK TABLES `MOT_History` WRITE;
/*!40000 ALTER TABLE `MOT_History` DISABLE KEYS */;
INSERT INTO `MOT_History` VALUES (1,1,'ZC14 1XW','Super Mario Motors','2 Tims Drive Leicester LE2 2BZ','2020-02-02','2021-02-02','Tires warn out','Campbel warn out','Oils need changing','','',48937545675,32.00,'2021-08-21 13:49:24'),(2,8,'GD10 XAO','Testings MOT','1 Valance drive Kings bury Jakarta','2021-09-27','2021-09-30','','','','','',998823645,32.00,'2021-09-27 10:23:12'),(3,13,'El Rico Suave','El Chico Motors','1 El Chico Boulevard Miami m123 73','2021-09-01','2021-09-30','Front tyre slightly worn','','','','',11256648,32.00,'2021-09-27 10:45:09');
/*!40000 ALTER TABLE `MOT_History` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MOT_Refusal`
--

DROP TABLE IF EXISTS `MOT_Refusal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MOT_Refusal` (
  `MOT_Refusal_id` bigint NOT NULL AUTO_INCREMENT,
  `V5C_id` bigint NOT NULL,
  `Vehicle_Reg_MOT_Date` varchar(30) NOT NULL,
  `Test_comp` varchar(50) NOT NULL,
  `Test_Addr` varchar(150) NOT NULL,
  `Test_Date` date NOT NULL,
  `Ref_Reason1` varchar(100) NOT NULL,
  `Ref_Reason2` varchar(100) DEFAULT NULL,
  `Ref_Reason3` varchar(100) DEFAULT NULL,
  `Ref_Reason4` varchar(100) DEFAULT NULL,
  `Ref_Reason5` varchar(100) DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`MOT_Refusal_id`),
  UNIQUE KEY `MOT_Refusal_id` (`MOT_Refusal_id`),
  KEY `V5C_id` (`V5C_id`),
  FULLTEXT KEY `Vehicle_Reg_MOT_Date` (`Vehicle_Reg_MOT_Date`,`Test_comp`),
  CONSTRAINT `MOT_Refusal_ibfk_1` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `MOT_Refusal_ibfk_2` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MOT_Refusal`
--

LOCK TABLES `MOT_Refusal` WRITE;
/*!40000 ALTER TABLE `MOT_Refusal` DISABLE KEYS */;
INSERT INTO `MOT_Refusal` VALUES (1,1,'ZC14 1XW','Super Mario Motors','2 Tims Drive Leicester LE2 2BZ','2019-02-22','What\'s wrong Mario?','How\'s life?','','','','2021-08-21 13:59:37'),(2,4,'VK57 JXV','Grange Motors','1 Grange avenue Lockley heath England LO1 1JT','2021-09-27','Tyres warn out','Clutch stiff','Exhaust is busted','front lightbulb is out','Break lights are out	','2021-09-27 12:10:05'),(3,3,'S954 LJU','Tondos Mutuka','1 Tondos bala bala Bakoikoi Kikwit 8893','2021-09-01','Mutuka me bula ka mbalabala','','','','','2021-09-27 12:20:56'),(4,3,'S954LJU','Queen B Motors','Kizulu nzo Kapanga Lupepa','2021-09-30','Tufi na benu','Nani ku butaka benu?','','','','2021-09-27 20:27:27'),(5,3,'S954LJU','Queen B Motors','Kizulu nzo Kapanga Lupepa','2021-10-01','Tufi na benu mbala zole','Nani ku butaka benu?','','','','2021-09-27 20:28:11');
/*!40000 ALTER TABLE `MOT_Refusal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Mechanic`
--

DROP TABLE IF EXISTS `Mechanic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Mechanic` (
  `Mech_Grg_id` int NOT NULL AUTO_INCREMENT,
  `Date_Added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Mech_Grg_id`),
  UNIQUE KEY `Mech_Grg_id` (`Mech_Grg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mechanic`
--

LOCK TABLES `Mechanic` WRITE;
/*!40000 ALTER TABLE `Mechanic` DISABLE KEYS */;
INSERT INTO `Mechanic` VALUES (1,'2021-08-21 14:31:07');
/*!40000 ALTER TABLE `Mechanic` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Mechanic_trigger` AFTER INSERT ON `Mechanic` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Mech_Grg_id,Entity_Name,VAT_Registration_Number)
				values(new.Mech_Grg_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Mech_Grg_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Mech_Grg_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
            
						-- Insert into icp.Names
			Insert into icp.Names(Mech_Grg_id,Fname,Mname,Lname)
				values(new.Mech_Grg_id,@Fname,@Mname,@Lname);

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Mileage_History`
--

DROP TABLE IF EXISTS `Mileage_History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Mileage_History` (
  `Mileage_Hist_id` bigint NOT NULL AUTO_INCREMENT,
  `V5C_id` bigint NOT NULL,
  `Vehicle_Reg_MOT_Date` varchar(30) NOT NULL,
  `Source` varchar(8) NOT NULL,
  `Mileage` bigint NOT NULL,
  `Date` date NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Mileage_Hist_id`),
  UNIQUE KEY `Mileage_Hist_id` (`Mileage_Hist_id`),
  KEY `V5C_id` (`V5C_id`),
  FULLTEXT KEY `Vehicle_Reg_MOT_Date` (`Vehicle_Reg_MOT_Date`),
  CONSTRAINT `Mileage_History_ibfk_1` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `Mileage_History_ibfk_2` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mileage_History`
--

LOCK TABLES `Mileage_History` WRITE;
/*!40000 ALTER TABLE `Mileage_History` DISABLE KEYS */;
INSERT INTO `Mileage_History` VALUES (1,1,'ZC14 1XW','Gov.UK',136001,'2010-09-30','2021-08-21 14:12:54'),(2,10,'RE60 LPY','GOV.uk',90857,'2021-02-05','2021-09-27 22:16:51');
/*!40000 ALTER TABLE `Mileage_History` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Names`
--

DROP TABLE IF EXISTS `Names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Names` (
  `Name_id` bigint NOT NULL AUTO_INCREMENT,
  `Staff_id` int DEFAULT NULL,
  `Customer_id` bigint DEFAULT NULL,
  `Mech_Grg_id` int DEFAULT NULL,
  `Elect_mech_id` int DEFAULT NULL,
  `MOT_Grg_id` int DEFAULT NULL,
  `Carwash_id` int DEFAULT NULL,
  `Fname` varchar(30) NOT NULL,
  `Mname` varchar(30) DEFAULT NULL,
  `Lname` varchar(50) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Name_id`),
  UNIQUE KEY `Name_id` (`Name_id`),
  UNIQUE KEY `Staff_id` (`Staff_id`),
  UNIQUE KEY `Customer_id` (`Customer_id`),
  UNIQUE KEY `Mech_Grg_id` (`Mech_Grg_id`),
  UNIQUE KEY `Elect_mech_id` (`Elect_mech_id`),
  UNIQUE KEY `MOT_Grg_id` (`MOT_Grg_id`),
  UNIQUE KEY `Carwash_id` (`Carwash_id`),
  CONSTRAINT `Names_ibfk_1` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
  CONSTRAINT `Names_ibfk_10` FOREIGN KEY (`Elect_mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON UPDATE CASCADE,
  CONSTRAINT `Names_ibfk_11` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Names_ibfk_12` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON UPDATE CASCADE,
  CONSTRAINT `Names_ibfk_2` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON DELETE CASCADE,
  CONSTRAINT `Names_ibfk_3` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Names_ibfk_4` FOREIGN KEY (`Elect_mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON DELETE CASCADE,
  CONSTRAINT `Names_ibfk_5` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Names_ibfk_6` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON DELETE CASCADE,
  CONSTRAINT `Names_ibfk_7` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON UPDATE CASCADE,
  CONSTRAINT `Names_ibfk_8` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON UPDATE CASCADE,
  CONSTRAINT `Names_ibfk_9` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Names`
--

LOCK TABLES `Names` WRITE;
/*!40000 ALTER TABLE `Names` DISABLE KEYS */;
INSERT INTO `Names` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,'Nara','Senton','Manun\'Ebo','2021-08-21 11:01:13'),(2,NULL,1,NULL,NULL,NULL,NULL,'Chakwenza','Ngodo','Baskabunda','2021-08-21 12:36:56'),(3,NULL,NULL,NULL,1,NULL,NULL,'Mario','Kravki','Bozlanivi','2021-08-21 14:23:01'),(4,NULL,NULL,1,NULL,NULL,NULL,'Simon','Tim','Hurst','2021-08-21 14:31:07'),(5,NULL,NULL,NULL,NULL,3,NULL,'Simon','Austin','Hurst','2021-08-21 14:47:33'),(6,NULL,NULL,NULL,NULL,NULL,1,'Lasdo','Petre','Gudon','2021-08-21 14:54:34'),(7,NULL,6,NULL,NULL,NULL,NULL,'Elvy','Kamunyoko','Manun\'Ebo','2021-08-26 21:04:21'),(9,NULL,8,NULL,NULL,NULL,NULL,'Elvy','Kamunyoko','Manun\'Ebo','2021-08-26 21:07:34'),(11,NULL,10,NULL,NULL,NULL,NULL,'Hakimi','Lampa','Ngi','2021-08-27 08:54:08');
/*!40000 ALTER TABLE `Names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Op_VAT`
--

DROP TABLE IF EXISTS `Op_VAT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_VAT` (
  `Op_VAT_id` bigint NOT NULL AUTO_INCREMENT,
  `Auct_Invoice_id` bigint DEFAULT NULL,
  `Op_service_id` bigint DEFAULT NULL,
  `Op_misc_Receipt_id` bigint DEFAULT NULL,
  `Gross_Price` decimal(7,2) NOT NULL,
  `VAT_rate` decimal(4,3) DEFAULT NULL,
  `VAT` decimal(7,2) NOT NULL,
  `Net` decimal(7,2) DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Op_VAT_id`),
  UNIQUE KEY `Op_VAT_id` (`Op_VAT_id`),
  KEY `Auct_Invoice_id` (`Auct_Invoice_id`),
  KEY `Op_service_id` (`Op_service_id`),
  KEY `Op_misc_Receipt_id` (`Op_misc_Receipt_id`),
  CONSTRAINT `Op_VAT_ibfk_1` FOREIGN KEY (`Auct_Invoice_id`) REFERENCES `Auction_invoice` (`Auct_Invoice_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_VAT_ibfk_2` FOREIGN KEY (`Op_service_id`) REFERENCES `Op_service` (`Op_service_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_VAT_ibfk_3` FOREIGN KEY (`Op_misc_Receipt_id`) REFERENCES `Op_misc_Receipt` (`Op_misc_Receipt_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_VAT_ibfk_4` FOREIGN KEY (`Auct_Invoice_id`) REFERENCES `Auction_invoice` (`Auct_Invoice_id`) ON UPDATE CASCADE,
  CONSTRAINT `Op_VAT_ibfk_5` FOREIGN KEY (`Op_service_id`) REFERENCES `Op_service` (`Op_service_id`) ON UPDATE CASCADE,
  CONSTRAINT `Op_VAT_ibfk_6` FOREIGN KEY (`Op_misc_Receipt_id`) REFERENCES `Op_misc_Receipt` (`Op_misc_Receipt_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_VAT`
--

LOCK TABLES `Op_VAT` WRITE;
/*!40000 ALTER TABLE `Op_VAT` DISABLE KEYS */;
INSERT INTO `Op_VAT` VALUES (1,NULL,5,NULL,10.00,0.200,2.00,8.00,'2021-08-24 12:03:56'),(2,NULL,5,NULL,10.00,0.200,2.00,8.00,'2021-08-24 13:44:19'),(3,NULL,NULL,5,30.00,0.200,5.00,25.00,'2021-08-24 20:29:52'),(4,2,NULL,NULL,3300.00,0.200,550.00,2750.00,'2021-08-24 21:55:29');
/*!40000 ALTER TABLE `Op_VAT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Op_bank_transfer`
--

DROP TABLE IF EXISTS `Op_bank_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_bank_transfer` (
  `Bank_transfer_id` bigint NOT NULL AUTO_INCREMENT,
  `Op_service_id` bigint DEFAULT NULL,
  `Split_payment` tinyint(1) NOT NULL,
  `Transfer_amount` decimal(7,2) NOT NULL,
  `Transfer_date` date NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Bank_transfer_id`),
  UNIQUE KEY `Payment_id` (`Bank_transfer_id`),
  UNIQUE KEY `Bank_transfer_id` (`Bank_transfer_id`),
  KEY `Op_service_id` (`Op_service_id`),
  CONSTRAINT `Op_bank_transfer_ibfk_1` FOREIGN KEY (`Op_service_id`) REFERENCES `Op_service` (`Op_service_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_bank_transfer_ibfk_4` FOREIGN KEY (`Op_service_id`) REFERENCES `Op_service` (`Op_service_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_bank_transfer`
--

LOCK TABLES `Op_bank_transfer` WRITE;
/*!40000 ALTER TABLE `Op_bank_transfer` DISABLE KEYS */;
INSERT INTO `Op_bank_transfer` VALUES (1,1,0,10.00,'2021-05-16','2021-08-23 12:52:45'),(2,NULL,0,135.00,'2021-06-19','2021-08-23 13:07:52'),(3,3,0,135.00,'2021-06-19','2021-08-23 13:09:50'),(4,4,0,30.00,'2021-03-20','2021-08-23 13:56:45'),(5,5,0,10.00,'2021-08-21','2021-08-24 13:44:19');
/*!40000 ALTER TABLE `Op_bank_transfer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Op_Vat_bank_transfer_insert` AFTER INSERT ON `Op_bank_transfer` FOR EACH ROW begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_service_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_service_id,new.Transfer_amount,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Op_call_Log`
--

DROP TABLE IF EXISTS `Op_call_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_call_Log` (
  `Call_log_id` bigint NOT NULL AUTO_INCREMENT,
  `Name` varchar(70) NOT NULL,
  `Customer_sex` varchar(1) NOT NULL,
  `Tel` bigint NOT NULL,
  `City_or_village` varchar(50) NOT NULL,
  `Vehicle_of_interest` varchar(30) NOT NULL,
  `V5C_id` bigint NOT NULL,
  `Date_of_call` date NOT NULL,
  `Time_of_Call` time NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Call_log_id`),
  UNIQUE KEY `Call_log_id` (`Call_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_call_Log`
--

LOCK TABLES `Op_call_Log` WRITE;
/*!40000 ALTER TABLE `Op_call_Log` DISABLE KEYS */;
INSERT INTO `Op_call_Log` VALUES (1,'Humzani Korr','F',7775639810,'Swadlingcote','SEAT IBIZA SPORT COUPE',7,'2021-08-21','11:30:00','2021-08-27 19:57:34'),(2,'Odi Mfima','F',24075873676,'Kikwit',' C4 GRAND PICASSO  AK11 HBJ',5,'2021-08-28','11:31:00','2021-09-27 23:04:25');
/*!40000 ALTER TABLE `Op_call_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Op_misc_Receipt`
--

DROP TABLE IF EXISTS `Op_misc_Receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_misc_Receipt` (
  `Op_misc_Receipt_id` bigint NOT NULL AUTO_INCREMENT,
  `Venue` varchar(50) NOT NULL,
  `Vat_registration` varchar(30) DEFAULT NULL,
  `Item` varchar(30) NOT NULL,
  `Price` decimal(7,2) NOT NULL,
  `Quantity` smallint NOT NULL,
  `Total` decimal(7,2) NOT NULL,
  `Auth_Code` int DEFAULT NULL,
  `Receipt_nbr` varchar(30) DEFAULT NULL,
  `Receipt_date` date NOT NULL,
  `Receipt_time` time NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Op_misc_Receipt_id`),
  UNIQUE KEY `Op_misc_Receipt_id` (`Op_misc_Receipt_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_misc_Receipt`
--

LOCK TABLES `Op_misc_Receipt` WRITE;
/*!40000 ALTER TABLE `Op_misc_Receipt` DISABLE KEYS */;
INSERT INTO `Op_misc_Receipt` VALUES (1,'Asda','GB 362012792','Diesel',1.30,5,6.50,NULL,NULL,'2021-08-14','11:09:00','2021-08-22 22:18:32'),(3,'Westly Coats','012792','Car paint Black',5.00,6,50.00,164533,'58478373','2021-06-11','08:45:00','2021-08-22 22:34:56'),(4,'Westly Coats','012792','Car paint midnight green',5.00,4,50.00,164533,'58478373','2021-06-11','08:45:00','2021-08-22 22:36:42'),(5,'Asda Petrol Station','GB 240 6175 30','Diesel',1.30,15,30.00,5644,'6654789113','2021-07-12','11:15:00','2021-08-24 20:29:52'),(6,'Asda Petrol Station','GB 240 6175 30','windscreen washer',3.00,1,30.00,5644,'6654789113','2021-07-12','11:15:00','2021-08-24 20:32:13'),(7,'Asda Petrol Station','GB 240 6175 30','Sandwhich',2.50,1,30.00,5644,'6654789113','2021-07-12','11:15:00','2021-08-24 20:36:09');
/*!40000 ALTER TABLE `Op_misc_Receipt` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Op_Vat_misc_Receipt_insert` AFTER INSERT ON `Op_misc_Receipt` FOR EACH ROW begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_misc_Receipt_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_misc_Receipt_id,@Gross_Price,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Op_service`
--

DROP TABLE IF EXISTS `Op_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_service` (
  `Op_service_id` bigint NOT NULL AUTO_INCREMENT,
  `Mech_Grg_id` int DEFAULT NULL,
  `Elect_mech_id` int DEFAULT NULL,
  `MOT_Grg_id` int DEFAULT NULL,
  `Carwash_id` int DEFAULT NULL,
  `V5C_id` bigint NOT NULL,
  `Serv_date` date NOT NULL,
  `Serv_Invoice_nbr` varchar(30) DEFAULT NULL,
  `Serv_Invoice_Date` date DEFAULT NULL,
  `Serv_type` varchar(11) NOT NULL,
  `Description` varchar(100) NOT NULL,
  `Price` decimal(7,2) DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Serv_return_date` date DEFAULT NULL,
  `Service_quality_check_done` varchar(3) DEFAULT NULL,
  `Service_quality_description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Op_service_id`),
  UNIQUE KEY `Op_service_id` (`Op_service_id`),
  UNIQUE KEY `Serv_Invoice_nbr` (`Serv_Invoice_nbr`),
  KEY `Mech_Grg_id` (`Mech_Grg_id`),
  KEY `Elect_mech_id` (`Elect_mech_id`),
  KEY `MOT_Grg_id` (`MOT_Grg_id`),
  KEY `Carwash_id` (`Carwash_id`),
  KEY `V5C_id` (`V5C_id`),
  CONSTRAINT `Op_service_ibfk_1` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_service_ibfk_10` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE,
  CONSTRAINT `Op_service_ibfk_2` FOREIGN KEY (`Elect_mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_service_ibfk_3` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_service_ibfk_4` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_service_ibfk_5` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_service_ibfk_6` FOREIGN KEY (`Mech_Grg_id`) REFERENCES `Mechanic` (`Mech_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Op_service_ibfk_7` FOREIGN KEY (`Elect_mech_id`) REFERENCES `Electrical` (`Elect_mech_id`) ON UPDATE CASCADE,
  CONSTRAINT `Op_service_ibfk_8` FOREIGN KEY (`MOT_Grg_id`) REFERENCES `MOT_Garage` (`MOT_Grg_id`) ON UPDATE CASCADE,
  CONSTRAINT `Op_service_ibfk_9` FOREIGN KEY (`Carwash_id`) REFERENCES `Carwash` (`Carwash_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_service`
--

LOCK TABLES `Op_service` WRITE;
/*!40000 ALTER TABLE `Op_service` DISABLE KEYS */;
INSERT INTO `Op_service` VALUES (1,NULL,NULL,NULL,1,1,'2021-05-09','A647583','2021-05-14','Carwash','Washing the car',10.00,'2021-08-22 10:00:30','2021-05-10','Yes','Very good work, quick and efficient'),(2,1,NULL,NULL,NULL,1,'2021-06-16','I3789273','2021-06-23','Mechanic','Radiator fix',70.00,'2021-08-22 11:04:21','2021-06-19','Yes','Decent work done'),(3,NULL,1,NULL,NULL,1,'2021-06-11','SM1114586','2021-06-17','Electrical','Dashboard lighting fix',135.00,'2021-08-22 11:18:23','2021-06-12','Yes','Electrifyingly good work'),(4,NULL,NULL,3,NULL,1,'2021-03-16','AH75983732','2021-03-18','MOT service','MOT Service',30.00,'2021-08-22 11:29:07','2021-03-17','Yes','Quality!'),(5,NULL,NULL,NULL,1,2,'2021-08-16','A647584','2021-08-19','Carwash','Washing the car',10.00,'2021-08-24 11:51:48','2021-08-17','Yes','Very good work, quick and efficient');
/*!40000 ALTER TABLE `Op_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Op_service_Receipt`
--

DROP TABLE IF EXISTS `Op_service_Receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_service_Receipt` (
  `Op_service_Receipt_id` bigint NOT NULL AUTO_INCREMENT,
  `Op_service_id` bigint NOT NULL,
  `Split_payment` tinyint(1) NOT NULL,
  `Trans_Date` date NOT NULL,
  `Trans_time` time NOT NULL,
  `Auth_code` int DEFAULT NULL,
  `Receipt_nbr` bigint NOT NULL,
  `Amount` decimal(7,2) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Op_service_Receipt_id`),
  UNIQUE KEY `Op_service_Receipt_id` (`Op_service_Receipt_id`),
  UNIQUE KEY `Op_service_id` (`Op_service_id`),
  CONSTRAINT `Op_service_Receipt_ibfk_1` FOREIGN KEY (`Op_service_id`) REFERENCES `Op_service` (`Op_service_id`) ON DELETE CASCADE,
  CONSTRAINT `Op_service_Receipt_ibfk_2` FOREIGN KEY (`Op_service_id`) REFERENCES `Op_service` (`Op_service_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_service_Receipt`
--

LOCK TABLES `Op_service_Receipt` WRITE;
/*!40000 ALTER TABLE `Op_service_Receipt` DISABLE KEYS */;
INSERT INTO `Op_service_Receipt` VALUES (1,1,0,'2021-05-16','15:36:00',44316,45687839847,10.00,'2021-08-22 20:26:22'),(2,2,0,'2021-06-25','12:51:00',998765,1093775856,70.00,'2021-08-22 20:37:27'),(3,4,0,'2021-03-18','09:31:00',22345,9487576,30.00,'2021-08-22 20:42:02'),(4,3,0,'2021-06-18','10:50:00',11319,87573543,135.00,'2021-08-22 20:46:46'),(5,5,0,'2021-08-21','13:57:00',44896,4889537661,10.00,'2021-08-24 12:03:56');
/*!40000 ALTER TABLE `Op_service_Receipt` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Op_Vat_service_Receipt_insert` AFTER INSERT ON `Op_service_Receipt` FOR EACH ROW begin
				if @VAT_Flag = "Y" then
					begin
						insert into icp.Op_VAT(Op_service_id,Gross_Price,VAT_rate,VAT,Net)
						values(new.Op_service_id,new.Amount,@VAT_rate, @VAT, @Net);
					end;
				end if;
			end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Op_vehicle_viewing`
--

DROP TABLE IF EXISTS `Op_vehicle_viewing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Op_vehicle_viewing` (
  `Vehicle_viewing_id` bigint NOT NULL AUTO_INCREMENT,
  `Vehicle_of_interest` varchar(30) NOT NULL,
  `V5C_id` bigint NOT NULL,
  `Nbr_Vehicles_viewed` int NOT NULL,
  `Customer_Age_Bracket` varchar(15) NOT NULL,
  `Customer_sex` varchar(1) NOT NULL,
  `City_or_village` varchar(50) NOT NULL,
  `Viewing_date` date NOT NULL,
  `Viewing_time` time NOT NULL,
  `Deposit_Flag` tinyint(1) NOT NULL,
  `Sale_Flag` tinyint(1) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Vehicle_viewing_id`),
  UNIQUE KEY `Vehicle_viewing_id` (`Vehicle_viewing_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_vehicle_viewing`
--

LOCK TABLES `Op_vehicle_viewing` WRITE;
/*!40000 ALTER TABLE `Op_vehicle_viewing` DISABLE KEYS */;
INSERT INTO `Op_vehicle_viewing` VALUES (1,'SEAT IBIZA SPORT COUPE',7,3,'25-29','F','Swadlingcote','2021-08-23','10:45:00',1,0,'2021-08-27 20:24:20'),(2,' X3 M SPORT  VK57 JXV',4,4,'40 to 49','M','Lutterworth','2021-08-08','15:33:00',0,1,'2021-09-27 23:45:09');
/*!40000 ALTER TABLE `Op_vehicle_viewing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Receipt`
--

DROP TABLE IF EXISTS `Receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Receipt` (
  `Receipt_id` bigint NOT NULL AUTO_INCREMENT,
  `Sale_id` bigint DEFAULT NULL,
  `Deposit_id` bigint DEFAULT NULL,
  `Card_Nbr` bigint DEFAULT NULL,
  `Debit_Type` varchar(15) DEFAULT NULL,
  `Start_Date` date DEFAULT NULL,
  `Exp_Date` date DEFAULT NULL,
  `Trans_Date` date DEFAULT NULL,
  `Trans_time` time DEFAULT NULL,
  `Auth_code` int DEFAULT NULL,
  `Amount` decimal(7,2) NOT NULL,
  `Receipt_Nbr` bigint NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Receipt_id`),
  UNIQUE KEY `Receipt_id` (`Receipt_id`),
  UNIQUE KEY `Receipt_Nbr` (`Receipt_Nbr`),
  UNIQUE KEY `Receipt_Nbr_2` (`Receipt_Nbr`),
  KEY `Sale_id` (`Sale_id`),
  KEY `Deposit_id` (`Deposit_id`),
  CONSTRAINT `Receipt_ibfk_1` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON DELETE CASCADE,
  CONSTRAINT `Receipt_ibfk_2` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON DELETE CASCADE,
  CONSTRAINT `Receipt_ibfk_3` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON UPDATE CASCADE,
  CONSTRAINT `Receipt_ibfk_4` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Receipt`
--

LOCK TABLES `Receipt` WRITE;
/*!40000 ALTER TABLE `Receipt` DISABLE KEYS */;
INSERT INTO `Receipt` VALUES (1,4,NULL,1038758475,'Visa','2019-10-03','2022-10-01','2021-08-08','16:44:00',44653,4500.00,98476537,'2021-08-26 20:15:34'),(2,NULL,2,1038758475,'Visa','2019-10-03','2022-10-01','2021-08-03','16:44:00',44953,4500.00,984537,'2021-08-26 21:04:21'),(4,6,NULL,1038758475,'Visa','2019-10-03','2022-10-01','2021-08-08','16:44:00',44953,4500.00,9837,'2021-08-26 21:07:34'),(5,NULL,4,NULL,NULL,NULL,NULL,'2021-03-03','13:47:00',NULL,150.00,48576998,'2021-08-27 08:54:08'),(7,8,NULL,7464383937578,'VISA','2018-06-01','2022-05-30','2021-03-05','11:06:33',84738,3000.00,48576999,'2021-08-27 10:08:11'),(8,8,NULL,NULL,NULL,NULL,NULL,'2021-03-05','11:06:33',NULL,700.00,48577000,'2021-08-27 10:08:11');
/*!40000 ALTER TABLE `Receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sale`
--

DROP TABLE IF EXISTS `Sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sale` (
  `Sale_id` bigint NOT NULL AUTO_INCREMENT,
  `Staff_id` int NOT NULL,
  `Customer_id` bigint NOT NULL,
  `V5C_id` bigint NOT NULL,
  `Sale_Date` date NOT NULL,
  `Sale_Amount` decimal(7,2) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Sale_id`),
  UNIQUE KEY `Sale_id` (`Sale_id`),
  UNIQUE KEY `Customer_id` (`Customer_id`),
  UNIQUE KEY `V5C_id` (`V5C_id`),
  KEY `Staff_id` (`Staff_id`),
  CONSTRAINT `Sale_ibfk_1` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON DELETE CASCADE,
  CONSTRAINT `Sale_ibfk_2` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `Sale_ibfk_3` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
  CONSTRAINT `Sale_ibfk_4` FOREIGN KEY (`Customer_id`) REFERENCES `Customer` (`Customer_id`) ON UPDATE CASCADE,
  CONSTRAINT `Sale_ibfk_5` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE,
  CONSTRAINT `Sale_ibfk_6` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sale`
--

LOCK TABLES `Sale` WRITE;
/*!40000 ALTER TABLE `Sale` DISABLE KEYS */;
INSERT INTO `Sale` VALUES (2,1,3,1,'2021-06-19',4800.00,'2021-08-21 12:44:42'),(4,1,5,6,'2021-08-08',4500.00,'2021-08-26 20:15:34'),(6,1,8,11,'2021-08-08',4500.00,'2021-08-26 21:07:34'),(8,1,12,9,'2021-03-05',6700.00,'2021-08-27 10:08:11');
/*!40000 ALTER TABLE `Sale` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Sale_to_Cash_Card_Trans_Receipt_insert` AFTER INSERT ON `Sale` FOR EACH ROW begin 
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
		end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Service_History`
--

DROP TABLE IF EXISTS `Service_History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Service_History` (
  `Serv_Hist_id` bigint NOT NULL AUTO_INCREMENT,
  `V5C_id` bigint NOT NULL,
  `Vehicle_Reg_serv_Date` varchar(30) NOT NULL,
  `Serv_comp` varchar(50) NOT NULL,
  `Serv_Addr` varchar(150) NOT NULL,
  `Serv_Date` date NOT NULL,
  `Serv_Parts_desc` varchar(100) NOT NULL,
  `Quantity` smallint NOT NULL,
  `Unit_price` decimal(7,2) NOT NULL,
  `Sum_per_Parts` decimal(7,2) DEFAULT NULL,
  `Total_Labour` decimal(7,2) DEFAULT NULL,
  `Total_Parts` decimal(7,2) DEFAULT NULL,
  `MOT_Fee` decimal(7,2) DEFAULT NULL,
  `VAT` decimal(7,2) DEFAULT NULL,
  `Grand_Total` decimal(7,2) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Serv_Hist_id`),
  UNIQUE KEY `Serv_Hist_id` (`Serv_Hist_id`),
  KEY `V5C_id` (`V5C_id`),
  FULLTEXT KEY `Vehicle_Reg_serv_Date` (`Vehicle_Reg_serv_Date`,`Serv_comp`),
  CONSTRAINT `Service_History_ibfk_1` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON DELETE CASCADE,
  CONSTRAINT `Service_History_ibfk_2` FOREIGN KEY (`V5C_id`) REFERENCES `V5C` (`V5C_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Service_History`
--

LOCK TABLES `Service_History` WRITE;
/*!40000 ALTER TABLE `Service_History` DISABLE KEYS */;
INSERT INTO `Service_History` VALUES (1,1,'YD14 XUU','Coil Motors','3 Huckerbey Drive Roston Leicestershire LE15 7BX','2020-04-17','Cambelt warn out',1,150.00,150.00,40.00,180.00,32.00,30.00,252.00,'2021-08-21 11:27:48'),(2,7,'SH58BBZ','Kangol Motors','1 Kangaroo street Auzie','2023-06-30','Cambelt change',1,50.00,50.00,45.00,300.00,32.00,71.17,427.00,'2021-09-27 21:37:37');
/*!40000 ALTER TABLE `Service_History` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Split_Payment`
--

DROP TABLE IF EXISTS `Split_Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Split_Payment` (
  `Split_Pay_id` bigint NOT NULL AUTO_INCREMENT,
  `Sale_id` bigint DEFAULT NULL,
  `Deposit_id` bigint DEFAULT NULL,
  `Transfer_id` bigint DEFAULT NULL,
  `Cash_Card_Pay_id` bigint DEFAULT NULL,
  `Split_Amount` decimal(7,2) NOT NULL,
  `Total_Payment` decimal(7,2) NOT NULL,
  `Payment_Date` date NOT NULL,
  `Date_Added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Split_Pay_id`),
  UNIQUE KEY `Split_Pay_id` (`Split_Pay_id`),
  KEY `Sale_id` (`Sale_id`),
  KEY `Deposit_id` (`Deposit_id`),
  KEY `Transfer_id` (`Transfer_id`),
  CONSTRAINT `Split_Payment_ibfk_1` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON DELETE CASCADE,
  CONSTRAINT `Split_Payment_ibfk_2` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON DELETE CASCADE,
  CONSTRAINT `Split_Payment_ibfk_3` FOREIGN KEY (`Transfer_id`) REFERENCES `Transfer` (`Transfer_id`) ON DELETE CASCADE,
  CONSTRAINT `Split_Payment_ibfk_7` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON UPDATE CASCADE,
  CONSTRAINT `Split_Payment_ibfk_8` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON UPDATE CASCADE,
  CONSTRAINT `Split_Payment_ibfk_9` FOREIGN KEY (`Transfer_id`) REFERENCES `Transfer` (`Transfer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Split_Payment`
--

LOCK TABLES `Split_Payment` WRITE;
/*!40000 ALTER TABLE `Split_Payment` DISABLE KEYS */;
INSERT INTO `Split_Payment` VALUES (3,NULL,4,2,NULL,100.00,250.00,'2021-03-03','2021-08-27 08:54:08'),(4,NULL,4,NULL,7,150.00,250.00,'2021-03-03','2021-08-27 08:54:08'),(8,8,NULL,4,NULL,3000.00,6700.00,'2021-03-05','2021-08-27 10:08:11'),(9,8,NULL,NULL,10,3000.00,6700.00,'2021-03-05','2021-08-27 10:08:11'),(10,8,NULL,NULL,11,700.00,6700.00,'2021-03-05','2021-08-27 10:08:11');
/*!40000 ALTER TABLE `Split_Payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Staff`
--

DROP TABLE IF EXISTS `Staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Staff` (
  `Staff_id` int NOT NULL AUTO_INCREMENT,
  `Date_Added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Staff_id`),
  UNIQUE KEY `Staff_id` (`Staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Staff`
--

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES (1,'2021-08-21 11:01:13');
/*!40000 ALTER TABLE `Staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Staff_insert` AFTER INSERT ON `Staff` FOR EACH ROW Begin 
-- Insert into names
Insert into icp.Names(Staff_id,Fname,Mname,Lname)
values(new.Staff_id,@Fname,@Mname,@Lname);

-- insert into DOB
Insert into icp.DOB(Staff_id,DOB)
values(new.Staff_id,@DOB);

-- Insert into contact details
Insert into icp.Contact_details(Staff_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
values(new.Staff_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@tel);

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Transfer`
--

DROP TABLE IF EXISTS `Transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transfer` (
  `Transfer_id` bigint NOT NULL AUTO_INCREMENT,
  `Sale_id` bigint DEFAULT NULL,
  `Deposit_id` bigint DEFAULT NULL,
  `Transfer_Reference` varchar(30) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Transfer_id`),
  UNIQUE KEY `Transfer_id` (`Transfer_id`),
  UNIQUE KEY `Transfer_Reference` (`Transfer_Reference`),
  KEY `Sale_id` (`Sale_id`),
  KEY `Deposit_id` (`Deposit_id`),
  CONSTRAINT `Transfer_ibfk_1` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON DELETE CASCADE,
  CONSTRAINT `Transfer_ibfk_2` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON DELETE CASCADE,
  CONSTRAINT `Transfer_ibfk_3` FOREIGN KEY (`Sale_id`) REFERENCES `Sale` (`Sale_id`) ON UPDATE CASCADE,
  CONSTRAINT `Transfer_ibfk_4` FOREIGN KEY (`Deposit_id`) REFERENCES `Deposit` (`Deposit_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transfer`
--

LOCK TABLES `Transfer` WRITE;
/*!40000 ALTER TABLE `Transfer` DISABLE KEYS */;
INSERT INTO `Transfer` VALUES (2,NULL,4,'HONDA CR-V EX I-VTEC','2021-08-27 08:54:08'),(4,8,NULL,'HONDA CR-V EX I-VTEC Sale','2021-08-27 10:08:11');
/*!40000 ALTER TABLE `Transfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `V5C`
--

DROP TABLE IF EXISTS `V5C`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `V5C` (
  `V5C_id` bigint NOT NULL AUTO_INCREMENT,
  `Reg_numb` varchar(30) NOT NULL,
  `Prev_reg_num` varchar(30) DEFAULT NULL,
  `Doc_ref_Numb` bigint NOT NULL,
  `Date_first_Reg` date NOT NULL,
  `Date_first_Reg_UK` date DEFAULT NULL,
  `Make` varchar(30) NOT NULL,
  `Model` varchar(30) NOT NULL,
  `Body_Type` varchar(30) NOT NULL,
  `Tax_Class` varchar(30) NOT NULL,
  `Type_Fuel` varchar(15) NOT NULL,
  `Nbr_seats` smallint NOT NULL,
  `Vehicle_Cat` varchar(30) NOT NULL,
  `Colour` varchar(15) NOT NULL,
  `V5C_Lgbk_issue_date` date NOT NULL,
  `Cylinder_capty` varchar(15) NOT NULL,
  `Nbr_prev_owners` smallint DEFAULT NULL,
  `Prev_owner1_Name` varchar(100) DEFAULT NULL,
  `Prev_owner1_Addr` varchar(150) DEFAULT NULL,
  `Prev_owner1_Acq_date` date DEFAULT NULL,
  `Prev_owner2_Name` varchar(100) DEFAULT NULL,
  `Prev_owner2_Addr` varchar(150) DEFAULT NULL,
  `Prev_owner2_Acq_date` date DEFAULT NULL,
  `Prev_owner3_Name` varchar(100) DEFAULT NULL,
  `Prev_owner3_Addr` varchar(150) DEFAULT NULL,
  `Prev_owner3_Acq_date` date DEFAULT NULL,
  `Prev_owner4_Name` varchar(100) DEFAULT NULL,
  `Prev_owner4_Addr` varchar(150) DEFAULT NULL,
  `Prev_owner4_Acq_date` date DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`V5C_id`),
  UNIQUE KEY `V5C_id` (`V5C_id`),
  UNIQUE KEY `Reg_numb` (`Reg_numb`),
  UNIQUE KEY `Doc_ref_Numb` (`Doc_ref_Numb`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `V5C`
--

LOCK TABLES `V5C` WRITE;
/*!40000 ALTER TABLE `V5C` DISABLE KEYS */;
INSERT INTO `V5C` VALUES (1,'ZC14 1XW','',15891368541,'2014-09-16','2014-09-16','BMW','3 Series','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Blue','2020-06-04','1995 CC',5,'Ivo Ngodo Kom','1 Goodman Avenue Leicester LE4 1AG','2020-05-15','Jojo bojak','3 fudichi kinanga Mpele MP1 35LX','2019-01-09','Ntonkana Mpinkanza','184 zizi buvanada Bukavuvu Sama BU10 13BA','2015-03-27','Bebo Bubana','1 seaside court Portsmouth England PO1 13A','2014-09-19','2021-08-21 11:10:55'),(2,'AN1 Tish','',8475673,'2011-07-30','2011-07-30','Renault','Clio','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Gray','2021-03-13','2000 CC',5,'Mark Ngo','8 Forge Street Leicester LE6 3NN','2016-03-27','Sue Botta','1 Ingles road Belford BE 1 8ST','2015-05-09',NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-24 11:45:29'),(3,'S954LJU','',2004054783,'2016-03-30','2017-03-30','Renault','Clio','5 door Hatchback','Petrol','Heavy Oil',5,'M1','Green','2021-01-27','1995 CC',3,'Jija Fonta','19 Kraviun Avenue Doncaster England DD1 3YA','2019-02-14','Kolo Ubunza','1 Highfield road Reading RG4 7PT','2018-08-11','Akizo Uzu','33 Pangol crescent Nottingham NG4 1KE','2016-04-17',NULL,NULL,NULL,'2021-08-26 19:50:55'),(4,'VK57 JXV','',5784883,'2015-06-12','2015-06-12','BMW','X3 M SPORT','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2021-07-04','1995 CC',2,'Hellen Winstanly','19 Grange street Derby DE5 1CB','2019-05-15','John Arinze','3 kalanga kinanga Mpele MP1 35LX','2016-06-26',NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:51:46'),(5,'AK11 HBJ','',158919376,'2012-07-13','2012-07-13','CITROEN','C4 GRAND PICASSO','7 door Hatchback','Diesel car','Heavy Oil',7,'M1','Blue','2020-09-24','1995 CC',1,'Ivo Ngodo Kom','1 Goodman Avenue Leicester LE4 1AG','2020-05-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:52:11'),(6,'WK08 JYE','',874673368541,'2015-02-09','2015-02-09','JAGUAR','XF PREMIUM LUXUARY','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2018-01-04','3000 CC',2,'Jojo bojak','3 fudichi kinanga Mpele MP1 35LX','2019-01-09','Ntonkana Mpinkanza','184 zizi buvanada Bukavuvu Sama BU10 13BA','2015-02-09',NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:52:42'),(7,'SH58 BBZ','',674328541,'2019-12-12','2019-12-12','SEAT','IBIZA SPORT COUPE','3 door Hatchback','Petrol','Light Oil',5,'M1','Silver','2020-06-04','1995 CC',1,'Bebo Bubana','1 seaside court Portsmouth England PO1 13A','2019-12-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:53:05'),(8,'GDI0 XAO','',158913331,'2018-05-30','2018-05-30','PEUGEOT','308','3 Door Coupe','Diesel car','Heavy Oil',5,'M1','Blue','2020-06-04','1995 CC',1,'Karen Ayre','7 Sloane square Reading Bershire RG7 3PY','2018-06-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:53:32'),(9,'DS57 GCO','',15411341,'2016-08-03','2016-08-03','HONDA','CR-V EX I-VTEC','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Silver','2021-06-28','2500 CC',1,'Pyr Khune','39 Hamburger row St Helens England ST1 3TX','2016-08-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:54:09'),(10,'RE60 LPY','',158541,'2019-01-25','2019-01-25','MITSUBISHI','ASX','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2020-10-06','2000 CC',1,'Nerizio Pella','1 Njojo Bara BA 1AG','2019-04-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:54:35'),(11,'VK11 XTM','',41948372,'2017-07-30','2017-07-30','MERCEDES BENZ','C CLASS C220 CDI','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2021-03-10','3500 CC',1,'Nuambe Mbokele','1 Artler Gore Kime 7638HQ','2017-08-13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:55:07'),(13,'El Rico Suave','',847663771,'2021-09-23','2021-09-23','Tesla','Model S','5 door hatchback','Electric','Battery',5,'E1','Midnight Green','2021-09-29','3000cc',1,'El Rico Suave','El Rico Mansion, Suave Chico Estada','2021-09-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-09-23 16:26:14'),(14,'M3 TY8X','',47883311184,'2021-09-29','2021-09-29','Tesla','Model X','5 door hatchback','Electric','Battery',5,'E1','Dark Green','2021-09-30','3000',1,'Lunga','1 Falama Njeke Ngrinda','2021-09-29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-09-29 09:48:40');
/*!40000 ALTER TABLE `V5C` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vendor`
--

DROP TABLE IF EXISTS `Vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Vendor` (
  `Vendor_id` int NOT NULL AUTO_INCREMENT,
  `Vendor_reference` varchar(30) NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Vendor_id`),
  UNIQUE KEY `Vendor_id` (`Vendor_id`),
  UNIQUE KEY `Vendor_reference` (`Vendor_reference`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vendor`
--

LOCK TABLES `Vendor` WRITE;
/*!40000 ALTER TABLE `Vendor` DISABLE KEYS */;
INSERT INTO `Vendor` VALUES (1,'BA101','2021-08-21 15:11:04');
/*!40000 ALTER TABLE `Vendor` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Vendor_trigger` AFTER INSERT ON `Vendor` FOR EACH ROW begin 
						-- Insert into icp.Entity
			insert into icp.Entity(Vendor_id,Entity_Name,VAT_Registration_Number)
				values(new.Vendor_id,@Entity_Name,@VAT_Registration_Number);
        
						-- Insert into contact details
			insert into icp.Contact_details(Vendor_id,Address1,Address2,Address3,Address4,Address5,Address6,email,Tel)
				values(new.Vendor_id,@Addr1,@Addr2,@Addr3,@Addr4,@Addr5,@Addr6,@email,@Tel);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-01  9:27:39
