-- MySQL dump 10.13  Distrib 8.0.27, for Linux (x86_64)
--
-- Host: localhost    Database: icp
-- ------------------------------------------------------
-- Server version	8.0.27-0ubuntu0.20.04.1

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auction`
--

LOCK TABLES `Auction` WRITE;
/*!40000 ALTER TABLE `Auction` DISABLE KEYS */;
INSERT INTO `Auction` VALUES (1,'2021-08-21 15:03:09'),(2,'2021-11-06 11:01:19'),(3,'2021-11-06 16:13:33'),(4,'2021-11-06 16:22:50'),(5,'2021-11-06 16:30:05');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auction_invoice`
--

LOCK TABLES `Auction_invoice` WRITE;
/*!40000 ALTER TABLE `Auction_invoice` DISABLE KEYS */;
INSERT INTO `Auction_invoice` VALUES (1,1,1,1,'MM/737764','2021-04-11','ZC14 1XW','BMW','3 Series','2017-12-16',1,'2021-08-01',15000,0,4075.00,100.00,10.00,15.00,75.00,1.00,855.00,5130.00,'2021-08-21 15:34:24'),(2,2,1,1,'MM/731764','2021-07-28','AN1 Tish','Renault','Clio','2011-07-30',1,'2021-11-27',187000,0,1175.00,100.00,10.00,15.00,75.00,0.00,550.00,3300.00,'2021-08-24 21:55:29'),(3,15,3,2,'316418484','2021-11-06','WK59HFE','Jaguar','XF Luxuary','2015-03-17',1,'2022-07-29',130783,0,2300.00,100.00,10.00,15.00,75.00,0.00,500.00,3000.00,'2021-11-07 10:13:35'),(4,18,2,2,'N0150683/	999	','2021-11-01','S645 STR','Tesla','Model S		','2018-05-10',1,'2022-03-25',89000,0,60000.00,100.00,10.00,15.00,75.00,0.00,10000.00,70200.00,'2021-12-06 11:46:04'),(6,17,5,2,'Man4446558','2021-07-01','RJ59 BNF','Volkswagen','Passat','2014-05-19',0,'2021-08-19',150000,0,7500.00,100.00,10.00,15.00,75.00,0.00,1283.33,7700.00,'2021-12-11 21:30:15'),(7,16,4,2,'BCA339877','2021-11-05','RV15 NAE','BMW','5 Series','2016-09-01',0,'2021-10-07',134000,0,8500.00,100.00,10.00,15.00,75.00,0.00,1450.00,8700.00,'2021-12-11 21:43:27'),(8,19,2,2,'456698','2021-09-16','PX14 WPW','MERCEDES BENZ','	CLA200 CDI AMG SPORT','2019-04-01',1,'2022-08-23',78641,0,6575.00,125.00,10.00,10.00,75.00,0.00,1133.33,6800.00,'2022-01-12 12:39:09');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Carwash`
--

LOCK TABLES `Carwash` WRITE;
/*!40000 ALTER TABLE `Carwash` DISABLE KEYS */;
INSERT INTO `Carwash` VALUES (1,'2021-08-21 14:54:34'),(2,'2021-11-07 12:37:28'),(3,'2022-01-13 10:47:25');
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cash_Card_Payment`
--

LOCK TABLES `Cash_Card_Payment` WRITE;
/*!40000 ALTER TABLE `Cash_Card_Payment` DISABLE KEYS */;
INSERT INTO `Cash_Card_Payment` VALUES (2,4,NULL,'Card','2021-08-26 20:15:34'),(3,NULL,2,'Card','2021-08-26 21:04:21'),(5,6,NULL,'Card','2021-08-26 21:07:34'),(7,NULL,4,'Cash','2021-08-27 08:54:08'),(10,8,NULL,'Card','2021-08-27 10:08:11'),(11,8,NULL,'Cash','2021-08-27 10:08:11'),(12,NULL,5,'Card','2021-10-11 20:55:17'),(13,NULL,7,'Cash','2021-10-14 20:57:27'),(14,NULL,8,'Card','2021-10-28 10:01:05'),(15,NULL,9,'Card','2021-10-28 20:53:40'),(16,NULL,9,'Cash','2021-10-28 20:53:40'),(17,11,NULL,'Card','2021-10-29 21:45:19'),(18,12,NULL,'Card','2021-10-30 15:45:14'),(19,13,NULL,'Card','2021-10-30 21:52:35'),(20,13,NULL,'Cash','2021-10-30 21:52:35'),(21,14,NULL,'Cash','2021-11-01 16:41:06'),(22,NULL,11,'Card','2021-11-01 20:26:35'),(23,16,NULL,'Card','2021-11-01 23:28:45'),(24,16,NULL,'Card','2021-11-01 23:28:45'),(25,17,NULL,'Card','2021-11-01 23:37:43'),(26,17,NULL,'Card','2021-11-01 23:37:43'),(27,NULL,12,'Cash','2021-11-02 01:10:54'),(28,18,NULL,'Card','2021-11-02 01:20:16'),(29,NULL,13,'Card','2021-12-23 22:29:10');
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
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Contact_details`
--

LOCK TABLES `Contact_details` WRITE;
/*!40000 ALTER TABLE `Contact_details` DISABLE KEYS */;
INSERT INTO `Contact_details` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'35','Willow Street','Leicester','Leicestershire','England','LE1 2HR','Nara123@hotmail.com','7710686060','2021-08-21 11:01:13'),(2,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3','Correy Road','Shorditch','Shropshire','England','SH15 7BP','Chakwenza@Ngodo.com','75765449338','2021-08-21 12:36:56'),(3,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,'2','Wheeler dealer Drive','Leicester','Leicestershire','England','LE3 5AS','Supermario@brothers.com','1163458761','2021-08-21 14:23:01'),(4,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'22','Wheeler dealer Drive','Leicester','Leicestershire','England','LE3 2AS','Supermario@brothers.com','1163458781','2021-08-21 14:31:07'),(5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,NULL,'13','Wheeler dealer Drive','Leicester','Leicestershire','England','LE3 2AS','Simon.husrt@SimonhurstMotors.com','1163458781','2021-08-21 14:47:33'),(6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'31','Wheeler dealer Drive','Leicester','Leicestershire','England','LE5 5AS','SuperCarWash@waters.com','11634584521','2021-08-21 14:54:34'),(7,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,'The fields','East Midland road','Derby','Derbyshire','England','DE17 5JJ','Enquiry@Aston.com','13458877613','2021-08-21 15:03:09'),(8,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'The Sheep House','Midland Avenue','Derby','Derbyshire','England','DE17 1JA','Enquiry@Barclays.com','13458879113','2021-08-21 15:11:04'),(9,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,'The Wolf House','Spinner Avenue','Chester','Chestershire','England','CE17 1WS','Enquiry@Shark.org','23567758638','2021-08-21 15:22:54'),(10,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'30','Bruce Close','Nottingham','Nottinghamshire','England','NG2 2HR','elvymanunebo@yahoo.co.uk','7591142154','2021-08-26 21:04:21'),(12,NULL,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'30','Bruce Close','Nottingham','Nottinghamshire','England','NG2 2HR','elvymanunebo@yahoo.co.uk','7591142154','2021-08-26 21:07:34'),(14,NULL,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'45','Kerry road','Litchfield','Leicestershire','England','LE17 9FH','Hakimi@Ngi.co.uk','7591149234','2021-08-27 08:54:08'),(23,NULL,45,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'30','Bruce close','Nottingham','Nottinghamshire','England','NG1 3AR','elvymanunebo@yahoo.co.uk','07591142154','2021-10-11 20:55:17'),(24,NULL,47,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1','Hasta la vista baby','Los Angeles','California','United shits','8001984','arnold@schwarzenegger.com','8005121984','2021-10-14 20:38:35'),(25,NULL,48,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2','Id, ego and super-ego','	P≈ô√≠bor','Czechia','Czech Republic','CZ772','sigmund@freud.com','00799564565','2021-10-14 20:57:27'),(26,NULL,49,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'87','Cornelia esta','Senel','Babinga','Pia','P1 1AP','sonko@ngende.com','00311455499','2021-10-28 10:01:05'),(28,NULL,53,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'71','Fort mayer avenue','Lincoln','Lincolnshire','England','LI12 5NE','casini@hill.com','0777222114','2021-10-28 20:53:40'),(30,NULL,55,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'30','Alun moss road','Loughborough','Leicestershire','England','LE11 8YP','jonathan@pear.com','07594443697','2021-10-29 21:06:08'),(31,NULL,56,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'9','Ngukonge kalonji','Bolongo','Kulumbuka','Mbuji Nduye','KU7 8YT','fifi@shelumbula.com','03334669878','2021-10-29 21:45:19'),(32,NULL,57,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'469','High street','London','London','England','SW11 1TT','jacob@banks.com','07836544131','2021-10-30 15:45:14'),(33,NULL,58,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'10','Borough road','Nuneaton','Warrickshire','England','CV10 0AF	','christopher@tullin.com','07885556313','2021-10-30 21:52:35'),(34,NULL,59,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2','London road','City of London','City of London','City of London','E2 2AE','tim@henman.com','022222222222','2021-11-01 16:41:06'),(35,NULL,60,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1','babini ngotelo','Nsandi kioki','Weiwoko ngoso','Kataka podora','KA43NF','NSKA@Ntokolo.Ka','03311555486','2021-11-01 19:58:16'),(36,NULL,61,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'47','Kensington drive','Quorn','Leicestershire','England','LE10 8GS','l.hitashi@wen.com','07778953641','2021-11-01 20:26:35'),(38,NULL,67,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'74','33rd street','New york','New york state','United shits','6567844','e.brock@daily-bugle.com','09897565464','2021-11-02 01:10:54'),(41,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'29','Slater street','Leicester','Leicestershire','England','LE3 5AS','blessing@yahoo.co.uk','01165594848','2021-11-04 00:26:18'),(45,9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'007','Bond street','Bahamas','Bahamas','Bahamas','B007AS','james.bond@007.com','007007007007','2021-11-04 11:16:11'),(46,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'43','Nottingham street','Nottingham','Nottinghamshire','England','NG1 1AA','n0150683@ntu.ac.uk','011533314','2021-11-06 11:01:19'),(47,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,'3','Nottingham high street','Nottingham','Nottinghamshire','England','NG1 3AP','aura@manunebo.com','01509335467','2021-11-06 11:37:02'),(48,NULL,NULL,NULL,NULL,3,NULL,NULL,NULL,NULL,'17','skoeldingen strasse','Copenhagen','Copenhagen','Denmark','106122','contact@maersk.com		','0045164822','2021-11-06 12:31:25'),(49,NULL,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'2','Teal Close	','Netherfield','Nottinghamshire','England','NG4 2PE	','enquiry@bca-Nottingham.com	',' 01159873311','2021-11-06 16:13:33'),(50,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'347','Tamworth Rd','Measham','Derbyshire	','England','DE12 7DY','enquiry@bca-measham.com	',' 01530270322','2021-11-06 16:22:50'),(51,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'77','Fullwood Industrial Estate, Common Rd,','Sutton-in-Ashfield','Nottinghamshire	','England','NG17 6AD','enquiry@manheim.com	','03331361014','2021-11-06 16:30:05'),(52,NULL,NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,'1','Jacked avenue','Matropolis 9','Matropolis state','Kiwatengo','648897','billy@shazam.zam','065498765','2021-11-07 12:21:24'),(53,NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,'1','Consumer way','Jack city','Jack savanah','Tekken','995235','prototype@jack.com','336598871','2021-11-07 12:28:31'),(54,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,'7','Jinji ndinji','Ndo','Bandinka','Ndo Bandinka','A755496','suengu@@ngalo.com','66695423145','2021-11-07 12:32:59'),(55,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,'361','Ngode bala bala','Kikwit','Bandundu','Zaire','ZA1364RE','ngaku@samekimba.kik','00243659874','2021-11-07 12:37:28'),(56,NULL,69,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1','High street','Loghborough','Leicestershire','England','LE15 1BZ','Samira.Ahmed@bbc.org','0777888461','2021-12-23 22:29:10'),(57,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,'17','High street','Enderby','Leicestershire','England','LE9 7PP','ndende@ndenge.com','07778956414','2022-01-13 10:47:25');
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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (1,'2021-08-21 12:36:56'),(3,'2021-08-21 12:44:42'),(5,'2021-08-26 20:15:34'),(6,'2021-08-26 21:04:21'),(8,'2021-08-26 21:07:34'),(10,'2021-08-27 08:54:08'),(12,'2021-08-27 10:08:11'),(43,'2021-10-11 20:23:32'),(45,'2021-10-11 20:55:17'),(46,'2021-10-14 20:33:57'),(47,'2021-10-14 20:38:35'),(48,'2021-10-14 20:57:27'),(49,'2021-10-28 10:01:05'),(51,'2021-10-28 20:35:25'),(52,'2021-10-28 20:41:36'),(53,'2021-10-28 20:53:40'),(55,'2021-10-29 21:06:08'),(56,'2021-10-29 21:45:19'),(57,'2021-10-30 15:45:14'),(58,'2021-10-30 21:52:35'),(59,'2021-11-01 16:41:06'),(60,'2021-11-01 19:58:16'),(61,'2021-11-01 20:26:35'),(63,'2021-11-01 22:14:51'),(64,'2021-11-01 23:28:45'),(65,'2021-11-01 23:37:43'),(67,'2021-11-02 01:10:54'),(68,'2021-11-02 01:20:16'),(69,'2021-12-23 22:29:10');
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DOB`
--

LOCK TABLES `DOB` WRITE;
/*!40000 ALTER TABLE `DOB` DISABLE KEYS */;
INSERT INTO `DOB` VALUES (1,1,NULL,'1992-09-08',NULL,'2021-08-21 11:01:13'),(2,NULL,1,'1974-09-29','40 to 49','2021-08-21 12:36:56'),(3,NULL,6,'1984-02-05','30 to 39','2021-08-26 21:04:21'),(5,NULL,8,'1984-02-05','30 to 39','2021-08-26 21:07:34'),(7,NULL,10,'1981-09-28','30 to 39','2021-08-27 08:54:08'),(12,NULL,45,'1984-02-05','35 to 39','2021-10-11 20:55:17'),(13,NULL,47,'1947-07-30','60+','2021-10-14 20:38:35'),(14,NULL,48,'1914-06-01','60+','2021-10-14 20:57:27'),(15,NULL,49,'1998-04-01','21 to 24','2021-10-28 10:01:05'),(17,NULL,53,'1995-05-24','25 to 29','2021-10-28 20:53:40'),(19,NULL,55,'1983-10-09','35 to 39','2021-10-29 21:06:08'),(20,NULL,56,'1980-05-05','40 to 49','2021-10-29 21:45:19'),(21,NULL,57,'1991-07-24','30 to 34','2021-10-30 15:45:14'),(22,NULL,58,'2021-10-30','35 to 39','2021-10-30 21:52:35'),(23,NULL,59,'1922-02-22','60+','2021-11-01 16:41:06'),(24,NULL,60,'1984-07-31','35 to 39','2021-11-01 19:58:16'),(25,NULL,61,'1990-04-30','30 to 34','2021-11-01 20:26:35'),(26,NULL,67,'1988-08-31','30 to 34','2021-11-02 01:10:54'),(29,5,NULL,'1990-07-03',NULL,'2021-11-04 00:26:18'),(33,9,NULL,'1941-06-04',NULL,'2021-11-04 11:16:11'),(34,NULL,69,'1968-06-15','50 to 59','2021-12-23 22:29:10');
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
  `Deposit_Time` time DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Deposit`
--

LOCK TABLES `Deposit` WRITE;
/*!40000 ALTER TABLE `Deposit` DISABLE KEYS */;
INSERT INTO `Deposit` VALUES (1,1,1,1,2,'2021-06-13',NULL,100.00,'2021-08-21 12:36:56'),(2,5,6,11,6,'2021-08-03',NULL,100.00,'2021-08-26 21:04:21'),(4,1,10,9,8,'2021-03-03',NULL,250.00,'2021-08-27 08:54:08'),(5,5,45,13,NULL,'2021-10-11',NULL,300.00,'2021-10-11 20:55:17'),(6,9,47,13,NULL,'2021-10-14',NULL,300.00,'2021-10-14 20:38:35'),(7,1,48,2,NULL,'2020-10-14',NULL,222.00,'2021-10-14 20:57:27'),(8,1,49,13,NULL,'2021-10-28',NULL,1000.00,'2021-10-28 10:01:05'),(9,5,53,2,NULL,'2021-10-28',NULL,700.00,'2021-10-28 20:53:40'),(10,9,60,7,17,'2021-04-05',NULL,95.00,'2021-11-01 19:58:16'),(11,1,61,4,15,'2021-11-01',NULL,135.00,'2021-11-01 20:26:35'),(12,1,67,14,18,'2021-11-02',NULL,150.00,'2021-11-02 01:10:54'),(13,9,69,18,NULL,'2021-12-23',NULL,300.00,'2021-12-23 22:29:10');
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
							values(new.Deposit_id, (select max(Transfer_id) from icp.Transfer) -1,@Split_Amount1,new.Deposit_Amount,new.Deposit_Date),
								  (new.Deposit_id, (select max(Transfer_id) from icp.Transfer),@Split_Amount2,new.Deposit_Amount,new.Deposit_Date); 
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Electrical`
--

LOCK TABLES `Electrical` WRITE;
/*!40000 ALTER TABLE `Electrical` DISABLE KEYS */;
INSERT INTO `Electrical` VALUES (1,'2021-08-21 14:23:01'),(2,'2021-11-07 12:21:24');
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Entity`
--

LOCK TABLES `Entity` WRITE;
/*!40000 ALTER TABLE `Entity` DISABLE KEYS */;
INSERT INTO `Entity` VALUES (1,NULL,NULL,NULL,NULL,NULL,1,NULL,'Super Mario Motors',84783976574,'2021-08-21 14:23:01'),(2,NULL,NULL,NULL,1,NULL,NULL,NULL,'Coils Motors',82783976574,'2021-08-21 14:31:07'),(3,NULL,NULL,NULL,NULL,3,NULL,NULL,'Hurst Motors',8278394,'2021-08-21 14:47:33'),(4,NULL,1,NULL,NULL,NULL,NULL,NULL,'The Carwash Place',783976574111,'2021-08-21 14:54:34'),(5,1,NULL,NULL,NULL,NULL,NULL,NULL,'Aston Barclays',64736367,'2021-08-21 15:03:09'),(6,NULL,NULL,NULL,NULL,NULL,NULL,1,'Barclays',895402451,'2021-08-21 15:11:04'),(7,NULL,NULL,2,NULL,NULL,NULL,NULL,'Shark.org',354658583,'2021-08-21 15:22:54'),(8,2,NULL,NULL,NULL,NULL,NULL,NULL,'N0150683',455698758,'2021-11-06 11:01:19'),(9,NULL,NULL,NULL,NULL,NULL,NULL,2,'Aurora',568847983,'2021-11-06 11:37:02'),(10,NULL,NULL,3,NULL,NULL,NULL,NULL,'maersk',666777222,'2021-11-06 12:31:25'),(11,3,NULL,NULL,NULL,NULL,NULL,NULL,'BCA Nottingham',89716656,'2021-11-06 16:13:33'),(12,4,NULL,NULL,NULL,NULL,NULL,NULL,'BCA Measham',89716657,'2021-11-06 16:22:50'),(13,5,NULL,NULL,NULL,NULL,NULL,NULL,'Manheim Mansfield',45668572,'2021-11-06 16:30:05'),(14,NULL,NULL,NULL,NULL,NULL,2,NULL,'Shazam!',1586498843,'2021-11-07 12:21:24'),(15,NULL,NULL,NULL,2,NULL,NULL,NULL,'Tekken Jack corporation',7995233464,'2021-11-07 12:28:31'),(16,NULL,NULL,NULL,NULL,4,NULL,NULL,'Suengu Ngalo Motors',45489668,'2021-11-07 12:32:59'),(17,NULL,2,NULL,NULL,NULL,NULL,NULL,'Yobisa Mituka',455566318,'2021-11-07 12:37:28'),(18,NULL,3,NULL,NULL,NULL,NULL,NULL,'Ndenge yobisa mituka',6696586,'2022-01-13 10:47:25');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fund`
--

LOCK TABLES `Fund` WRITE;
/*!40000 ALTER TABLE `Fund` DISABLE KEYS */;
INSERT INTO `Fund` VALUES (1,0.50,50.00,100.00,'2021-08-21 15:21:19'),(2,0.50,50.00,100.00,'2021-08-21 15:22:54'),(3,0.22,600.00,200.00,'2021-11-06 12:31:25');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MOT_Garage`
--

LOCK TABLES `MOT_Garage` WRITE;
/*!40000 ALTER TABLE `MOT_Garage` DISABLE KEYS */;
INSERT INTO `MOT_Garage` VALUES (1,'2021-08-21 14:41:00'),(2,'2021-08-21 14:44:09'),(3,'2021-08-21 14:47:33'),(4,'2021-11-07 12:32:59');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mechanic`
--

LOCK TABLES `Mechanic` WRITE;
/*!40000 ALTER TABLE `Mechanic` DISABLE KEYS */;
INSERT INTO `Mechanic` VALUES (1,'2021-08-21 14:31:07'),(2,'2021-11-07 12:28:31');
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Names`
--

LOCK TABLES `Names` WRITE;
/*!40000 ALTER TABLE `Names` DISABLE KEYS */;
INSERT INTO `Names` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,'Nara','Senton','Manun\'Ebo','2021-08-21 11:01:13'),(2,NULL,1,NULL,NULL,NULL,NULL,'Chakwenza','Ngodo','Baskabunda','2021-08-21 12:36:56'),(3,NULL,NULL,NULL,1,NULL,NULL,'Mario','Kravki','Bozlanivi','2021-08-21 14:23:01'),(4,NULL,NULL,1,NULL,NULL,NULL,'Simon','Tim','Hurst','2021-08-21 14:31:07'),(5,NULL,NULL,NULL,NULL,3,NULL,'Simon','Austin','Hurst','2021-08-21 14:47:33'),(6,NULL,NULL,NULL,NULL,NULL,1,'Lasdo','Petre','Gudon','2021-08-21 14:54:34'),(7,NULL,6,NULL,NULL,NULL,NULL,'Elvy','Kamunyoko','Manun\'Ebo','2021-08-26 21:04:21'),(9,NULL,8,NULL,NULL,NULL,NULL,'Elvy','Kamunyoko','Manun\'Ebo','2021-08-26 21:07:34'),(11,NULL,10,NULL,NULL,NULL,NULL,'Hakimi','Lampa','Ngi','2021-08-27 08:54:08'),(20,NULL,45,NULL,NULL,NULL,NULL,'Elvy','','Manun\'Ebo','2021-10-11 20:55:17'),(21,NULL,47,NULL,NULL,NULL,NULL,'Arnold','','Schwarzenegger','2021-10-14 20:38:35'),(22,NULL,48,NULL,NULL,NULL,NULL,'Sigmund','','Freud','2021-10-14 20:57:27'),(23,NULL,49,NULL,NULL,NULL,NULL,'Sonko','','Ngende','2021-10-28 10:01:05'),(25,NULL,53,NULL,NULL,NULL,NULL,'Casini','','Hill','2021-10-28 20:53:40'),(27,NULL,55,NULL,NULL,NULL,NULL,'Jonathan','','Pear','2021-10-29 21:06:08'),(28,NULL,56,NULL,NULL,NULL,NULL,'Fifi','','Shelumbula','2021-10-29 21:45:19'),(29,NULL,57,NULL,NULL,NULL,NULL,'Jacob','','Banks','2021-10-30 15:45:14'),(30,NULL,58,NULL,NULL,NULL,NULL,'Christopher','','Tullin	','2021-10-30 21:52:35'),(31,NULL,59,NULL,NULL,NULL,NULL,'Tim','','Henman','2021-11-01 16:41:06'),(32,NULL,60,NULL,NULL,NULL,NULL,'Gi','','Lintanshi','2021-11-01 19:58:16'),(33,NULL,61,NULL,NULL,NULL,NULL,'Lawrence','','Hitashi','2021-11-01 20:26:35'),(35,NULL,67,NULL,NULL,NULL,NULL,'Eddie','','Broc','2021-11-02 01:10:54'),(38,5,NULL,NULL,NULL,NULL,NULL,'Blessing','','Vundura','2021-11-04 00:26:18'),(42,9,NULL,NULL,NULL,NULL,NULL,'James','','Bond','2021-11-04 11:16:11'),(43,NULL,NULL,NULL,2,NULL,NULL,'Billy','','constantly','2021-11-07 12:21:24'),(44,NULL,NULL,2,NULL,NULL,NULL,'Prototype','','Jack','2021-11-07 12:28:31'),(45,NULL,NULL,NULL,NULL,4,NULL,'Suengu','','Ngalo','2021-11-07 12:32:59'),(46,NULL,NULL,NULL,NULL,NULL,2,'Ngaku','mvuta','Samekimba','2021-11-07 12:37:28'),(47,NULL,69,NULL,NULL,NULL,NULL,'Samiea','','Ahmed','2021-12-23 22:29:10'),(48,NULL,NULL,NULL,NULL,NULL,3,'Ndenge','Kalonji','Ditanda','2022-01-13 10:47:25');
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_VAT`
--

LOCK TABLES `Op_VAT` WRITE;
/*!40000 ALTER TABLE `Op_VAT` DISABLE KEYS */;
INSERT INTO `Op_VAT` VALUES (1,NULL,5,NULL,10.00,0.200,1.67,8.33,'2021-08-24 12:03:56'),(2,NULL,5,NULL,0.00,0.000,0.00,0.00,'2021-08-24 13:44:19'),(3,NULL,NULL,5,30.00,0.200,5.00,25.00,'2021-08-24 20:29:52'),(4,2,NULL,NULL,3300.00,0.200,550.00,2750.00,'2021-08-24 21:55:29'),(5,3,NULL,NULL,3000.00,NULL,500.00,2500.00,'2021-11-07 10:13:35'),(6,NULL,6,NULL,10.00,0.200,1.67,8.33,'2021-11-11 16:30:47'),(7,NULL,11,NULL,53.00,0.200,8.83,44.17,'2021-11-11 16:33:55'),(8,NULL,13,NULL,10.00,0.200,1.67,8.33,'2021-11-11 21:25:51'),(9,NULL,NULL,8,15.00,0.200,2.50,12.50,'2021-11-11 23:39:07'),(10,NULL,NULL,9,20.00,0.200,3.33,16.67,'2021-11-11 23:42:28'),(11,NULL,NULL,10,5.00,0.200,0.83,4.17,'2021-11-11 23:45:57'),(12,NULL,NULL,11,5.00,0.200,0.83,4.17,'2021-11-11 23:51:53'),(13,4,NULL,NULL,70200.00,NULL,10000.00,60200.00,'2021-12-06 11:46:04'),(14,6,NULL,NULL,7700.00,NULL,1283.33,6416.67,'2021-12-11 21:30:15'),(15,7,NULL,NULL,8700.00,NULL,1450.00,7250.00,'2021-12-11 21:43:27'),(16,NULL,NULL,12,16.87,0.200,2.81,14.06,'2022-01-07 02:38:17'),(17,8,NULL,NULL,6800.00,NULL,1133.33,5666.67,'2022-01-12 12:39:09');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_bank_transfer`
--

LOCK TABLES `Op_bank_transfer` WRITE;
/*!40000 ALTER TABLE `Op_bank_transfer` DISABLE KEYS */;
INSERT INTO `Op_bank_transfer` VALUES (1,1,0,10.00,'2021-05-16','2021-08-23 12:52:45'),(2,3,0,135.00,'2021-06-19','2021-08-23 13:07:52'),(3,3,0,135.00,'2021-06-19','2021-08-23 13:09:50'),(4,4,0,30.00,'2021-03-20','2021-08-23 13:56:45'),(5,5,0,10.00,'2021-08-21','2021-08-24 13:44:19'),(6,13,0,10.00,'2021-11-11','2021-11-11 21:25:51');
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
  `Deposit_flag` smallint NOT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Call_log_id`),
  UNIQUE KEY `Call_log_id` (`Call_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_call_Log`
--

LOCK TABLES `Op_call_Log` WRITE;
/*!40000 ALTER TABLE `Op_call_Log` DISABLE KEYS */;
INSERT INTO `Op_call_Log` VALUES (1,'Humzani Korr','F',7775639810,'Swadlingcote','SEAT IBIZA SPORT COUPE',7,'2021-08-21','11:30:00',1,'2021-08-27 19:57:34'),(2,'Odi Mfima','M',24075873676,'Nottingham',' C4 GRAND PICASSO  AK11 HBJ',5,'2021-08-28','11:31:00',0,'2021-09-27 23:04:25'),(3,'Salili Heish','F',322155648,'Northampton',' XF Luxuary  WK59HFE',15,'2021-06-09','11:40:00',0,'2021-12-15 22:43:46'),(4,'Kun Basinga Igwe','M',1444755623,'East Goscote',' Model S  S645 STR',18,'2021-03-27','10:33:00',0,'2021-12-15 22:52:11'),(5,'Bobo Solwinta','M',36214598,'Gratham',' XF Luxuary  WK59HFE',15,'2021-05-06','09:50:00',0,'2021-12-15 22:54:44'),(6,'Sharon Apple','F',87895431128,'Earl shilton',' Passat CC TDI  RJ59 BNF',17,'2021-06-10','15:05:00',0,'2021-12-15 22:56:49'),(7,'Sergei Berg','M',7811365469,'Coalville',' XF Luxuary  WK59HFE',15,'2021-04-08','17:57:00',0,'2021-12-15 22:59:07'),(8,'Sasha Kutunga','F',7771365461,'Hathern',' 5 Series  RV15 NAE',16,'2021-04-28','19:30:00',0,'2021-12-15 23:02:09'),(9,'Brian Greene','M',314758965,'Nottingham',' Model S  S645 STR',18,'2021-02-05','13:38:00',0,'2021-12-16 10:17:38'),(10,'Kris Jordan','F',7895466354,'Leicester',' XF Luxuary  WK59HFE',15,'2021-01-06','10:51:00',0,'2021-12-16 10:19:10'),(11,'Samira Ahmed','F',777888461,'Loughborough',' Model S  S645 STR',18,'2021-12-23','11:15:00',1,'2021-12-23 22:13:47'),(12,'Mbo Kasongo','M',7778956414,'Enderby','CLA200 CDI AMG SPORT  PX14 WPW',19,'2022-01-13','09:03:00',0,'2022-01-13 10:29:41');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_misc_Receipt`
--

LOCK TABLES `Op_misc_Receipt` WRITE;
/*!40000 ALTER TABLE `Op_misc_Receipt` DISABLE KEYS */;
INSERT INTO `Op_misc_Receipt` VALUES (1,'Asda','GB 362012792','Diesel',1.30,5,6.50,NULL,NULL,'2021-08-14','11:09:00','2021-08-22 22:18:32'),(3,'Westly Coats','012792','Car paint Black',5.00,6,50.00,164533,'58478373','2021-06-11','08:45:00','2021-08-22 22:34:56'),(4,'Westly Coats','012792','Car paint midnight green',5.00,4,50.00,164533,'58478373','2021-06-11','08:45:00','2021-08-22 22:36:42'),(5,'Asda Petrol Station','GB 240 6175 30','Diesel',1.30,15,30.00,5644,'6654789113','2021-07-12','11:15:00','2021-08-24 20:29:52'),(6,'Asda Petrol Station','GB 240 6175 30','windscreen washer',3.00,1,30.00,5644,'6654789113','2021-07-12','11:15:00','2021-08-24 20:32:13'),(7,'Asda Petrol Station','GB 240 6175 30','Sandwhich',2.50,1,30.00,5644,'6654789113','2021-07-12','11:15:00','2021-08-24 20:36:09'),(8,'Aldi','813053468','Dust bin',5.00,3,40.00,43236,'444111888','2021-11-11','10:07:00','2021-11-11 23:39:07'),(9,'Aldi','813053468','Microwave',20.00,1,40.00,43236,'444111888','2021-11-11','10:07:00','2021-11-11 23:42:28'),(10,'Aldi','813053468','Hand wash',1.00,5,40.00,43236,'444111888','2021-11-11','10:07:00','2021-11-11 23:45:57'),(11,'Asda Petrol station','GB 240 6175 30','Knives and forks set',5.00,1,30.00,5644,'444111888','2021-07-12','11:15:00','2021-11-11 23:51:53'),(12,'Asda','4569870001','Container box',16.87,1,16.87,4566321,'999875613254','2021-02-19','10:43:00','2022-01-07 02:38:17');
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
  `Serv_Invoice_Description` varchar(100) DEFAULT NULL,
  `Serv_type` varchar(11) NOT NULL,
  `Description` varchar(100) NOT NULL,
  `Price` decimal(7,2) DEFAULT NULL,
  `Serv_return_date` date DEFAULT NULL,
  `Service_quality_check_done` varchar(3) DEFAULT NULL,
  `Service_quality_description` varchar(100) DEFAULT NULL,
  `Date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_service`
--

LOCK TABLES `Op_service` WRITE;
/*!40000 ALTER TABLE `Op_service` DISABLE KEYS */;
INSERT INTO `Op_service` VALUES (1,NULL,NULL,NULL,1,1,'2021-05-09','A647583','2021-05-14',NULL,'Carwash','Washing the car',10.00,'2021-05-10','Yes','Very good work, quick and efficient','2021-08-22 10:00:30'),(2,1,NULL,NULL,NULL,1,'2021-06-16','I3789273','2021-06-23',NULL,'Mechanic','Radiator fix',70.00,'2021-06-19','Yes','Decent work done','2021-08-22 11:04:21'),(3,NULL,1,NULL,NULL,1,'2021-06-11','SM1114586','2021-06-17',NULL,'Electrical','Dashboard lighting fix',135.00,'2021-06-12','Yes','Electrifyingly good work','2021-08-22 11:18:23'),(4,NULL,NULL,3,NULL,1,'2021-03-16','AH75983732','2021-03-18',NULL,'MOT service','MOT Service',30.00,'2021-03-17','Yes','Quality!','2021-08-22 11:29:07'),(5,NULL,NULL,NULL,1,2,'2021-08-16','A647584','2021-08-19',NULL,'Carwash','Washing the car',10.00,'2021-08-17','Yes','Very good work, quick and efficient','2021-08-24 11:51:48'),(6,NULL,NULL,NULL,2,17,'2021-11-08','65164855','2021-11-10',NULL,'Carwash','Invoice for washing the car',10.00,'2021-11-10','Yes','Great work, the car is clean','2021-11-08 15:54:57'),(7,NULL,2,NULL,NULL,18,'2021-11-08',NULL,NULL,NULL,'Electrical','Battery change',NULL,'2021-12-02','Yes','Quality work done','2021-11-08 15:56:56'),(8,2,NULL,NULL,NULL,16,'2021-11-08','14896533','2021-11-10',NULL,'Mechanic','invoice for drive shaft repairs',80.00,'2021-11-09','Yes','Drive shaft is in good working order','2021-11-08 16:00:15'),(9,2,NULL,NULL,NULL,15,'2021-10-13',NULL,NULL,NULL,'Mechanic','Radiator fix',NULL,'2021-11-10','Yes','Radiator in good working order','2021-11-08 16:03:23'),(10,NULL,NULL,4,NULL,15,'2021-10-13','79835','2021-11-11',NULL,'MOT','Invoice for MOT service',32.00,'2021-11-11','Yes','MOT service done','2021-11-08 16:17:41'),(11,NULL,1,NULL,NULL,17,'2021-09-09','4669623','2021-11-10',NULL,'Electrical','Invoice for windows electrical work',53.00,'2021-11-08','Yes','The windows are working fine now','2021-11-08 16:33:33'),(12,2,NULL,NULL,NULL,18,'2021-10-04','7465998311','2021-11-10',NULL,'Mechanic','Invoice for tyre change',75.00,'2021-11-09','Yes','Good work done','2021-11-08 16:49:08'),(13,NULL,NULL,NULL,1,16,'2021-10-29','54566321','2021-11-10',NULL,'Carwash','Invoice for washing the car',10.00,'2021-11-10','Yes','Good work','2021-11-08 17:02:16'),(14,NULL,1,NULL,NULL,15,'2021-11-01','366546498','2021-11-10',NULL,'Electrical','Invoice for dashboard electronics',70.00,'2021-11-10','Yes','Electrics are all good','2021-11-08 21:39:11'),(15,NULL,NULL,NULL,2,18,'2021-11-06','468897223','2021-11-10',NULL,'Carwash','full vallet',10.00,'2021-11-09','Yes','Good work, the car is clean inside out','2021-11-08 21:49:34'),(16,NULL,NULL,4,NULL,17,'2021-11-03','79836','2021-11-11',NULL,'MOT','Invoice for MOT service',32.00,'2021-11-10','Yes','MOT service done','2021-11-08 21:54:30'),(17,NULL,NULL,NULL,2,15,'2021-11-10','33556499','2021-11-10',NULL,'Carwash','Invoice for car wash',10.00,'2021-11-10','Yes','Good work, the car is clean','2021-11-10 21:33:07'),(18,NULL,1,NULL,NULL,16,'2021-11-09',NULL,NULL,NULL,'Electrical','Dashboard light fixing',NULL,'2021-11-10','Yes','Solid work','2021-11-10 21:33:54'),(19,1,NULL,NULL,NULL,17,'2021-11-10',NULL,NULL,NULL,'Mechanic','Body work fix',NULL,'2021-11-10','Yes','MOT test done','2021-11-10 21:35:40'),(20,NULL,NULL,4,NULL,18,'2021-11-10','79837','2021-11-11',NULL,'MOT','Invoice for MOT service',32.00,'2021-11-11','Yes','MOT service done','2021-11-10 21:37:47');
/*!40000 ALTER TABLE `Op_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Op_service_Carwash`
--

DROP TABLE IF EXISTS `Op_service_Carwash`;
/*!50001 DROP VIEW IF EXISTS `Op_service_Carwash`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Op_service_Carwash` AS SELECT 
 1 AS `Op_service_id`,
 1 AS `Make`,
 1 AS `Model`,
 1 AS `Reg_numb`,
 1 AS `Entity_Name`,
 1 AS `Serv_date`,
 1 AS `Serv_Invoice_nbr`,
 1 AS `Serv_Invoice_Date`,
 1 AS `financial_year`,
 1 AS `Serv_type`,
 1 AS `Description`,
 1 AS `Price`,
 1 AS `Serv_return_date`,
 1 AS `Service_quality_check_done`,
 1 AS `Service_quality_description`,
 1 AS `Date_added`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_service_Receipt`
--

LOCK TABLES `Op_service_Receipt` WRITE;
/*!40000 ALTER TABLE `Op_service_Receipt` DISABLE KEYS */;
INSERT INTO `Op_service_Receipt` VALUES (1,1,0,'2021-05-16','15:36:00',44316,45687839847,10.00,'2021-08-22 20:26:22'),(2,2,0,'2021-06-25','12:51:00',998765,1093775856,70.00,'2021-08-22 20:37:27'),(3,4,0,'2021-03-18','09:31:00',22345,9487576,30.00,'2021-08-22 20:42:02'),(4,3,0,'2021-06-18','10:50:00',11319,87573543,135.00,'2021-08-22 20:46:46'),(5,5,0,'2021-08-21','13:57:00',44896,4889537661,10.00,'2021-08-24 12:03:56'),(6,6,0,'2021-11-11','09:06:00',66448,1545695331,10.00,'2021-11-11 16:30:47'),(7,11,0,'2021-11-11','10:48:00',66449,1545695332,53.00,'2021-11-11 16:33:55');
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Op_vehicle_viewing`
--

LOCK TABLES `Op_vehicle_viewing` WRITE;
/*!40000 ALTER TABLE `Op_vehicle_viewing` DISABLE KEYS */;
INSERT INTO `Op_vehicle_viewing` VALUES (1,'SEAT IBIZA SPORT COUPE',7,3,'25-29','F','Swadlingcote','2021-08-23','10:45:00',1,0,'2021-08-27 20:24:20'),(2,' X3 M SPORT  VK57 JXV',4,4,'40 to 49','M','Lutterworth','2021-08-08','15:33:00',0,1,'2021-09-27 23:45:09'),(3,' XF Luxuary  WK59HFE',15,2,'25 to 29','F','Northampton','2021-06-10','13:10:00',0,0,'2021-12-15 22:47:40'),(4,' XF Luxuary  WK59HFE',15,3,'60+','F','Leicester','2021-01-06','16:30:00',0,0,'2021-12-16 10:23:07'),(5,' Model S  S645 STR',18,1,'50 to 59','M','Nottingham','2021-02-05','15:43:00',0,0,'2021-12-16 10:25:10'),(6,' 5 Series  RV15 NAE',16,1,'25 to 29','M','Belton','2021-09-10','10:12:00',0,0,'2021-12-16 10:26:26'),(7,' Passat CC TDI  RJ59 BNF',17,1,'30 to 34','F','Thurmaston','2021-08-17','11:57:00',0,0,'2021-12-16 10:27:39'),(8,' Model S  S645 STR',18,3,'40 to 49','M','Syston','2021-09-29','16:33:00',0,0,'2021-12-16 10:29:07'),(9,' XF Luxuary  WK59HFE',15,1,'50 to 59','F','Hinckley','2021-04-05','00:16:00',0,0,'2021-12-16 10:33:08'),(10,' Model S  S645 STR',18,1,'50 to 59','F','Burbage','2021-11-10','17:35:00',0,0,'2021-12-16 10:35:00'),(11,' 5 Series  RV15 NAE',16,3,'25 to 29','M','Hinckley','2021-12-01','10:41:00',0,0,'2021-12-16 22:27:29'),(12,' 5 Series  RV15 NAE',16,2,'30 to 34','F','Hinckley','2021-10-14','16:10:00',0,0,'2021-12-16 22:29:53'),(13,' XF Luxuary  WK59HFE',15,3,'35 to 39','F','Nottingham','2021-10-26','11:14:00',0,0,'2021-12-16 22:32:39');
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Receipt`
--

LOCK TABLES `Receipt` WRITE;
/*!40000 ALTER TABLE `Receipt` DISABLE KEYS */;
INSERT INTO `Receipt` VALUES (1,4,NULL,1038758475,'Visa','2019-10-03','2022-10-01','2021-08-08','16:44:00',44653,4500.00,98476537,'2021-08-26 20:15:34'),(2,NULL,2,1038758475,'Visa','2019-10-03','2022-10-01','2021-08-03','16:44:00',44953,4500.00,984537,'2021-08-26 21:04:21'),(4,6,NULL,1038758475,'Visa','2019-10-03','2022-10-01','2021-08-08','16:44:00',44953,4500.00,9837,'2021-08-26 21:07:34'),(5,NULL,4,NULL,NULL,NULL,NULL,'2021-03-03','13:47:00',NULL,150.00,48576998,'2021-08-27 08:54:08'),(7,8,NULL,7464383937578,'VISA','2018-06-01','2022-05-30','2021-03-05','11:06:33',84738,3000.00,48576999,'2021-08-27 10:08:11'),(8,8,NULL,NULL,NULL,NULL,NULL,'2021-03-05','11:06:33',NULL,700.00,48577000,'2021-08-27 10:08:11'),(9,NULL,5,448823917143,'MasterCard','2019-03-25','2024-07-01','2021-10-11','09:40:00',375677,300.00,578993783356,'2021-10-11 20:55:17'),(10,NULL,7,NULL,NULL,NULL,NULL,'2021-10-14','11:22:00',NULL,222.00,22426662,'2021-10-14 20:57:27'),(11,NULL,8,98416415,'Visa','2019-09-23','2025-01-31','2021-10-28','10:30:00',46636,400.00,799232648,'2021-10-28 10:01:05'),(12,NULL,9,6549775214,'Maestro','2018-10-09','2023-07-13','2021-10-28','15:11:00',335578,110.00,4952626852,'2021-10-28 20:53:40'),(13,NULL,9,NULL,NULL,NULL,NULL,'2021-10-28','15:10:00',NULL,90.00,989745567,'2021-10-28 20:53:40'),(14,11,NULL,544669875,'Delta','2019-04-11','2024-05-01','2021-10-29','22:30:00',88874,7300.00,6499874,'2021-10-29 21:45:19'),(15,12,NULL,96555475,'Visa Electron','2017-08-25','2023-08-25','2021-10-30','15:10:00',33389,7500.00,669898746,'2021-10-30 15:45:14'),(16,13,NULL,445632456,'MasterCard','2017-06-30','2024-06-30','2021-10-30','08:35:00',879948,4000.00,131315444,'2021-10-30 21:52:35'),(17,13,NULL,NULL,NULL,NULL,NULL,'2021-10-30','08:45:00',NULL,4000.00,4656549888,'2021-10-30 21:52:35'),(18,14,NULL,NULL,NULL,NULL,NULL,'2022-02-22','02:02:00',NULL,2222.00,202,'2021-11-01 16:41:06'),(19,NULL,11,469684684,'MasterCard','2018-10-01','2023-03-09','2021-11-01','12:01:00',63354,135.00,21646134,'2021-11-01 20:26:35'),(20,16,NULL,6459974,'Visa Electron','2017-11-30','2021-12-30','2021-11-01','10:04:00',6654,4300.00,6548,'2021-11-01 23:28:45'),(21,16,NULL,7774569,'Visa Delta','2016-11-18','2021-11-19','2021-11-01','10:10:00',335488,3700.00,6549,'2021-11-01 23:28:45'),(22,17,NULL,6459978,'Maestro','2017-11-30','2021-12-30','2021-11-01','10:04:00',6651,4400.00,6550,'2021-11-01 23:37:43'),(23,17,NULL,7774561,'Delta','2016-11-18','2021-11-19','2021-11-01','10:10:00',335451,3600.00,6551,'2021-11-01 23:37:43'),(24,NULL,12,NULL,NULL,NULL,NULL,'2021-11-02','09:00:00',NULL,150.00,664625,'2021-11-02 01:10:54'),(25,18,NULL,456987778,'Visa','2018-04-30','2023-04-30','2021-11-02','09:15:00',46565,30980.00,165534887,'2021-11-02 01:20:16'),(26,NULL,13,48566871456,'MasterCard','2019-01-15','2023-01-14','2021-12-23','11:18:00',44657,300.00,4698756613278,'2021-12-23 22:29:10');
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
  `Sale_Time` time DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sale`
--

LOCK TABLES `Sale` WRITE;
/*!40000 ALTER TABLE `Sale` DISABLE KEYS */;
INSERT INTO `Sale` VALUES (2,5,3,1,'2021-06-19',NULL,4800.00,'2021-08-21 12:44:42'),(4,1,5,6,'2021-08-08',NULL,4500.00,'2021-08-26 20:15:34'),(6,1,8,11,'2020-08-08',NULL,4500.00,'2021-08-26 21:07:34'),(8,5,12,9,'2021-03-05',NULL,6700.00,'2021-08-27 10:08:11'),(10,1,55,13,'2021-10-29',NULL,78500.00,'2021-10-29 21:06:08'),(11,1,56,5,'2021-10-29',NULL,7300.00,'2021-10-29 21:45:19'),(12,9,57,10,'2021-10-30',NULL,15000.00,'2021-10-30 15:45:14'),(13,9,58,8,'2021-04-01',NULL,12000.00,'2021-10-30 21:52:35'),(14,9,59,2,'2022-02-22',NULL,2222.00,'2021-11-01 16:41:06'),(15,1,63,4,'2021-11-01',NULL,8300.00,'2021-11-01 22:14:51'),(16,1,64,3,'2021-11-01',NULL,8000.00,'2021-11-01 23:28:45'),(17,5,65,7,'2021-11-01',NULL,8000.00,'2021-11-01 23:37:43'),(18,5,68,14,'2021-11-02',NULL,75880.00,'2021-11-02 01:20:16');
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Split_Payment`
--

LOCK TABLES `Split_Payment` WRITE;
/*!40000 ALTER TABLE `Split_Payment` DISABLE KEYS */;
INSERT INTO `Split_Payment` VALUES (3,NULL,4,2,NULL,100.00,250.00,'2021-03-03','2021-08-27 08:54:08'),(4,NULL,4,NULL,7,150.00,250.00,'2021-03-03','2021-08-27 08:54:08'),(8,8,NULL,4,NULL,3000.00,6700.00,'2021-03-05','2021-08-27 10:08:11'),(9,8,NULL,NULL,10,3000.00,6700.00,'2021-03-05','2021-08-27 10:08:11'),(10,8,NULL,NULL,11,700.00,6700.00,'2021-03-05','2021-08-27 10:08:11'),(11,NULL,8,6,NULL,600.00,1000.00,'2021-10-28','2021-10-28 10:01:05'),(12,NULL,8,NULL,14,400.00,1000.00,'2021-10-28','2021-10-28 10:01:05'),(13,NULL,9,7,NULL,500.00,700.00,'2021-10-28','2021-10-28 20:53:40'),(14,NULL,9,NULL,15,110.00,700.00,'2021-10-28','2021-10-28 20:53:40'),(15,NULL,9,NULL,16,90.00,700.00,'2021-10-28','2021-10-28 20:53:40'),(16,10,NULL,9,NULL,0.00,4400.00,'2021-10-29','2021-10-29 21:06:08'),(17,12,NULL,10,NULL,7500.00,15000.00,'2021-10-30','2021-10-30 15:45:14'),(18,12,NULL,NULL,18,7500.00,15000.00,'2021-10-30','2021-10-30 15:45:14'),(19,13,NULL,11,NULL,4000.00,12000.00,'2021-10-30','2021-10-30 21:52:35'),(20,13,NULL,NULL,19,4000.00,12000.00,'2021-10-30','2021-10-30 21:52:35'),(21,13,NULL,NULL,20,4000.00,12000.00,'2021-10-30','2021-10-30 21:52:35'),(22,15,NULL,13,NULL,0.00,8300.00,'2021-11-01','2021-11-01 22:14:51'),(23,16,NULL,NULL,23,4300.00,8000.00,'2021-11-01','2021-11-01 23:28:45'),(24,16,NULL,NULL,24,3700.00,8000.00,'2021-11-01','2021-11-01 23:28:45'),(25,17,NULL,NULL,25,4400.00,8000.00,'2021-11-01','2021-11-01 23:37:43'),(26,17,NULL,NULL,26,3600.00,8000.00,'2021-11-01','2021-11-01 23:37:43'),(27,18,NULL,14,NULL,14000.00,75880.00,'2021-11-02','2021-11-02 01:20:16'),(28,18,NULL,15,NULL,30900.00,75880.00,'2021-11-02','2021-11-02 01:20:16'),(29,18,NULL,NULL,28,30980.00,75880.00,'2021-11-02','2021-11-02 01:20:16');
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
  `Passwd` blob,
  `iv` blob,
  `Date_Added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Staff_id`),
  UNIQUE KEY `Staff_id` (`Staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Staff`
--

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES (1,NULL,NULL,'2021-08-21 11:01:13'),(5,_binary 'D65C3A9E35DD35AFBA94DCE4FA673B3E',_binary 'ø\"cl]\Ò\”\‰+¶\0ù\€\‡)','2021-11-04 00:26:18'),(9,_binary 'EDF8F3CBF79AFE87CE9D1E60657D821B9C70686843E8B951074B960E45375251',_binary 'F\ÿqïó^∆áb\√R»øÑû','2021-11-04 11:16:11');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transfer`
--

LOCK TABLES `Transfer` WRITE;
/*!40000 ALTER TABLE `Transfer` DISABLE KEYS */;
INSERT INTO `Transfer` VALUES (2,NULL,4,'HONDA CR-V EX I-VTEC','2021-08-27 08:54:08'),(4,8,NULL,'HONDA CR-V EX I-VTEC Sale','2021-08-27 10:08:11'),(5,NULL,6,'T-800','2021-10-14 20:38:35'),(6,NULL,8,'El Rico','2021-10-28 10:01:05'),(7,NULL,9,'Renault Clio','2021-10-28 20:53:40'),(9,10,NULL,'El Rico 1','2021-10-29 21:06:08'),(10,12,NULL,'ASX RE60 LPY','2021-10-30 15:45:14'),(11,13,NULL,'GD10 XAO 30OCT2021','2021-10-30 21:52:35'),(12,NULL,10,'Sonko 123','2021-11-01 19:58:16'),(13,15,NULL,'Hitashi 01-11-2021','2021-11-01 22:14:51'),(14,18,NULL,'Eddie 1 model x','2021-11-02 01:20:16'),(15,18,NULL,'Eddie 1.1 Model x','2021-11-02 01:20:16');
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `V5C`
--

LOCK TABLES `V5C` WRITE;
/*!40000 ALTER TABLE `V5C` DISABLE KEYS */;
INSERT INTO `V5C` VALUES (1,'ZC14 1XW','',15891368541,'2014-09-16','2014-09-16','BMW','3 Series','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Blue','2020-06-04','1995 CC',5,'Ivo Ngodo Kom','1 Goodman Avenue Leicester LE4 1AG','2020-05-15','Jojo bojak','3 fudichi kinanga Mpele MP1 35LX','2019-01-09','Ntonkana Mpinkanza','184 zizi buvanada Bukavuvu Sama BU10 13BA','2015-03-27','Bebo Bubana','1 seaside court Portsmouth England PO1 13A','2014-09-19','2021-08-21 11:10:55'),(2,'AN1 Tish','',8475673,'2011-07-30','2011-07-30','Renault','Clio','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Gray','2021-03-13','2000 CC',5,'Mark Ngo','8 Forge Street Leicester LE6 3NN','2016-03-27','Sue Botta','1 Ingles road Belford BE 1 8ST','2015-05-09',NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-24 11:45:29'),(3,'S954LJU','',2004054783,'2016-03-30','2017-03-30','Renault','Clio','5 door Hatchback','Petrol','Heavy Oil',5,'M1','Green','2021-01-27','1995 CC',3,'Jija Fonta','19 Kraviun Avenue Doncaster England DD1 3YA','2019-02-14','Kolo Ubunza','1 Highfield road Reading RG4 7PT','2018-08-11','Akizo Uzu','33 Pangol crescent Nottingham NG4 1KE','2016-04-17',NULL,NULL,NULL,'2021-08-26 19:50:55'),(4,'VK57 JXV','',5784883,'2015-06-12','2015-06-12','BMW','X3 M SPORT','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2021-07-04','1995 CC',2,'Hellen Winstanly','19 Grange street Derby DE5 1CB','2019-05-15','John Arinze','3 kalanga kinanga Mpele MP1 35LX','2016-06-26',NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:51:46'),(5,'AK11 HBJ','',158919376,'2012-07-13','2012-07-13','CITROEN','C4 GRAND PICASSO','7 door Hatchback','Diesel car','Heavy Oil',7,'M1','Blue','2020-09-24','1995 CC',1,'Ivo Ngodo Kom','1 Goodman Avenue Leicester LE4 1AG','2020-05-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:52:11'),(6,'WK08 JYE','',874673368541,'2015-02-09','2015-02-09','JAGUAR','XF PREMIUM LUXUARY','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2018-01-04','3000 CC',2,'Jojo bojak','3 fudichi kinanga Mpele MP1 35LX','2019-01-09','Ntonkana Mpinkanza','184 zizi buvanada Bukavuvu Sama BU10 13BA','2015-02-09',NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:52:42'),(7,'SH58 BBZ','',674328541,'2019-12-12','2019-12-12','SEAT','IBIZA SPORT COUPE','3 door Hatchback','Petrol','Light Oil',5,'M1','Silver','2020-06-04','1995 CC',1,'Bebo Bubana','1 seaside court Portsmouth England PO1 13A','2019-12-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:53:05'),(8,'GDI0 XAO','',158913331,'2018-05-30','2018-05-30','PEUGEOT','308','3 Door Coupe','Diesel car','Heavy Oil',5,'M1','Blue','2020-06-04','1995 CC',1,'Karen Ayre','7 Sloane square Reading Bershire RG7 3PY','2018-06-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:53:32'),(9,'DS57 GCO','',15411341,'2016-08-03','2016-08-03','HONDA','CR-V EX I-VTEC','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Silver','2021-06-28','2500 CC',1,'Pyr Khune','39 Hamburger row St Helens England ST1 3TX','2016-08-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:54:09'),(10,'RE60 LPY','',158541,'2019-01-25','2019-01-25','MITSUBISHI','ASX','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2020-10-06','2000 CC',1,'Nerizio Pella','1 Njojo Bara BA 1AG','2019-04-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:54:35'),(11,'VK11 XTM','',41948372,'2017-07-30','2017-07-30','MERCEDES BENZ','C CLASS C220 CDI','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2021-03-10','3500 CC',1,'Nuambe Mbokele','1 Artler Gore Kime 7638HQ','2017-08-13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-08-26 19:55:07'),(13,'El Rico Suave','',847663771,'2021-09-23','2021-09-23','Tesla','Model S','5 door hatchback','Electric','Battery',5,'E1','Midnight Green','2021-09-29','3000cc',1,'El Rico Suave','El Rico Mansion, Suave Chico Estada','2021-09-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-09-23 16:26:14'),(14,'M3 TY8X','',47883311184,'2021-09-29','2021-09-29','Tesla','Model X','5 door hatchback','Electric','Battery',5,'E1','Dark Green','2021-09-30','3000',1,'Lunga','1 Falama Njeke Ngrinda','2021-09-29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-09-29 09:48:40'),(15,'WK59HFE','',64486566256,'2015-03-17','2015-03-17','Jaguar','XF Luxuary','5 door hatchback','Diesel car','Heavy oil',5,'M1','Silver','2019-06-19','3000 cc',3,'Kitana','8 Choi shuai fang Edenia realm','2015-04-08','Eddy Gordo','1 Decampino Brasilia Brazil 159866','2019-06-30','Uub Nijam','3 Capsule Corp Fire mountain Dragon land','2021-04-04',NULL,NULL,NULL,'2021-11-07 10:01:59'),(16,'RV15 NAE','',66445889,'2016-09-01','2016-09-01','BMW','5 Series','5 Door hatchback','Diesel car','Heavy oil',5,'M1','Light gold','2021-05-04','3000 cc',1,'MPalu Rizakendu','489 Salunga nkumu Njede Mfe 456879','2017-01-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-11-08 15:11:17'),(17,'RJ59 BNF','',664444123,'2014-05-19','2014-05-19','Volkswagen','Passat CC TDI','5 Door hatchback','Diesel car','Heavy oil',5,'M1','Black','2021-01-25','1800 cc',1,'Radu Bangula','133 Fangu Ntikana ndegu 647889','2014-10-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-11-08 15:18:34'),(18,'S645 STR','',97444148,'2018-05-10','2018-05-10','Tesla','Model S','5 Door hatchback','Electric','Battery',5,'E1','Midnight Green	','2021-06-14','4000 cc',1,'Shola Amma','81 Kensington Lane London SW1 1AE','2018-12-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-11-08 15:30:52'),(19,'PX14 WPW','',4569,'2019-04-01','2019-04-01','MERCEDES BENZ','CLA200 CDI AMG SPORT','5 door Hatchback','Diesel car','Heavy Oil',5,'M1','Black','2020-02-05','2100',1,'Salongo Kasongo','1 kipupu elengo Ndaka k14 7NP','2020-04-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2022-01-12 12:16:06');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vendor`
--

LOCK TABLES `Vendor` WRITE;
/*!40000 ALTER TABLE `Vendor` DISABLE KEYS */;
INSERT INTO `Vendor` VALUES (1,'BA101','2021-08-21 15:11:04'),(2,'Aurora n0150683','2021-11-06 11:37:02');
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

--
-- Final view structure for view `Op_service_Carwash`
--

/*!50001 DROP VIEW IF EXISTS `Op_service_Carwash`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Op_service_Carwash` AS select `b`.`Op_service_id` AS `Op_service_id`,`a`.`Make` AS `Make`,`a`.`Model` AS `Model`,`a`.`Reg_numb` AS `Reg_numb`,`c`.`Entity_Name` AS `Entity_Name`,`b`.`Serv_date` AS `Serv_date`,`b`.`Serv_Invoice_nbr` AS `Serv_Invoice_nbr`,`b`.`Serv_Invoice_Date` AS `Serv_Invoice_Date`,(case when ((concat(year(`b`.`Serv_Invoice_Date`),'/04/06') < `b`.`Serv_Invoice_Date`) and (`b`.`Serv_Invoice_Date` < concat((year(`b`.`Serv_Invoice_Date`) + 1),'/04/06'))) then year(`b`.`Serv_Invoice_Date`) when ((`b`.`Serv_Invoice_Date` < concat(year(`b`.`Serv_Invoice_Date`),'/04/06')) and (`b`.`Serv_Invoice_Date` > concat((year(`b`.`Serv_Invoice_Date`) - 1),'/04/06'))) then (year(`b`.`Serv_Invoice_Date`) - 1) else year(`b`.`Serv_Invoice_Date`) end) AS `financial_year`,`b`.`Serv_type` AS `Serv_type`,`b`.`Description` AS `Description`,`b`.`Price` AS `Price`,`b`.`Serv_return_date` AS `Serv_return_date`,`b`.`Service_quality_check_done` AS `Service_quality_check_done`,`b`.`Service_quality_description` AS `Service_quality_description`,`b`.`Date_added` AS `Date_added` from ((`V5C` `a` left join `Op_service` `b` on((`a`.`V5C_id` = `b`.`V5C_id`))) left join `Entity` `c` on((`b`.`Carwash_id` = `c`.`Carwash_id`))) where (`c`.`Entity_Name` is not null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-24 14:44:27
